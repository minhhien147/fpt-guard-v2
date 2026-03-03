import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/location_provider.dart';
import '../providers/contacts_provider.dart';
import '../services/email_service.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../services/audio_recording_service.dart';

class SOSFormScreen extends StatefulWidget {
  const SOSFormScreen({super.key});

  @override
  State<SOSFormScreen> createState() => _SOSFormScreenState();
}

class _SOSFormScreenState extends State<SOSFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  File? _audioFile;
  bool _isSending = false;
  bool _isRecording = false;
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startAutoRecord();
  }

  Future<void> _startAutoRecord() async {
    final user = AuthService().currentUser;
    if (user == null || !user.isPro) return;

    // Bắt đầu ghi ngay (non-blocking)
    await AudioRecordingService().startBackground();
    if (!mounted) return;
    setState(() => _isRecording = true);

    // Đếm giây để hiển thị UI – ghi tối đa 60s rồi tự dừng
    for (int i = 1; i <= 60; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !AudioRecordingService().isRecording) break;
      setState(() => _recordingSeconds = i);
    }
    // Tự dừng sau 60s nếu user chưa gửi
    if (AudioRecordingService().isRecording) {
      final f = await AudioRecordingService().stopAndGetFile();
      if (mounted) setState(() { _audioFile = f; _isRecording = false; });
    }
  }

  @override
  void dispose() {
    AudioRecordingService().stopRecording();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chụp ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chọn ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _takePicture();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn từ thư viện'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            if (_imageFile != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Xóa ảnh', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _imageFile = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendSOS() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chụp ảnh tình huống'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final userProvider = context.read<UserProvider>();
      final locationProvider = context.read<LocationProvider>();
      final contactsProvider = context.read<ContactsProvider>();

      final user = userProvider.user!;
      final latitude = locationProvider.latitude!;
      final longitude = locationProvider.longitude!;
      final address = locationProvider.currentAddress;
      final description = _descriptionController.text.trim();

      // 1. Gửi SOS đến backend API (nếu đã đăng nhập)
      Map<String, dynamic>? apiResult;
      if (AuthService().isLoggedIn) {
        apiResult = await AuthService().createSOSReport(
          latitude: latitude,
          longitude: longitude,
          message: description,
        );
      }

      // 2. Lưu vào local database
      await DatabaseService.instance.insertSOSAlert(
        userId: user.id ?? 1,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      // 3. Gửi email backup (nếu API thất bại hoặc làm backup)
      final emails = contactsProvider.getEmergencyEmails();
      if (user.email.isNotEmpty) {
        emails.insert(0, user.email);
      }

      // Dừng ghi âm và lấy file (dù còn đang ghi hay đã xong)
      if (AudioRecordingService().isRecording) {
        final f = await AudioRecordingService().stopAndGetFile();
        if (f != null) _audioFile = f;
      }

      bool emailSent = false;
      if (emails.isNotEmpty) {
        emailSent = await EmailService.sendSOSEmail(
          userName: user.fullName,
          userEmail: user.email,
          address: address,
          latitude: latitude,
          longitude: longitude,
          recipientEmails: emails,
          description: description,
          imageFile: _imageFile!,
          audioFile: _audioFile,
        );
      }

      // Hiển thị kết quả
      if (mounted) {
        if (apiResult != null && apiResult['success']) {
          // SOS đã được gửi lên server thành công
          final message = emailSent 
              ? '✅ Đã gửi cảnh báo lên hệ thống và ${emails.length} email!'
              : '✅ Đã gửi cảnh báo lên hệ thống!';
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        } else if (apiResult == null && emailSent) {
          // Chưa đăng nhập nhưng đã gửi email thành công
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Đã gửi cảnh báo đến ${emails.length} email!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        } else if (apiResult != null && !apiResult['success']) {
          // API thất bại nhưng có thể email đã gửi
          if (emailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('⚠️ Đã gửi email nhưng lỗi kết nối server: ${apiResult['error']}'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 4),
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Lỗi: ${apiResult['error']}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Không gửi được cả API và email
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Không thể gửi cảnh báo. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error sending SOS: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚨 Gửi Cảnh Báo SOS'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thông báo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Vui lòng chụp ảnh và mô tả tình huống để tránh spam',
                            style: TextStyle(
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Chụp ảnh
              Text(
                '📷 Chụp ảnh tình huống *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _imageFile == null ? Colors.grey[400]! : Colors.green,
                      width: 2,
                    ),
                  ),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Nhấn để chụp ảnh',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _imageFile!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nhấn vào khung để chụp ảnh hoặc chọn từ thư viện',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Mô tả tình huống
              Text(
                '✍️ Mô tả tình huống *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Ví dụ: Tôi đang bị theo dõi bởi một người lạ...\nTôi bị lạc đường và không biết về đâu...\nTôi gặp tai nạn và cần giúp đỡ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng mô tả tình huống của bạn';
                  }
                  if (value.trim().length < 10) {
                    return 'Mô tả phải có ít nhất 10 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Mô tả chi tiết sẽ giúp người hỗ trợ hiểu rõ tình huống',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Audio recording indicator (Pro only)
              if (_isRecording || _audioFile != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.orange[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isRecording ? Colors.orange : Colors.green,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isRecording ? Icons.mic : Icons.mic_none,
                        color: _isRecording ? Colors.orange : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _isRecording
                              ? 'Đang ghi âm hiện trường... ${_recordingSeconds}s'
                              : 'Đã ghi âm ${_recordingSeconds}s – sẽ đính kèm vào email',
                          style: TextStyle(
                            fontSize: 13,
                            color: _isRecording ? Colors.orange[800] : Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Nút gửi
              ElevatedButton(
                onPressed: _isSending ? null : _sendSOS,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSending
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Đang gửi...'),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Gửi Cảnh Báo SOS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

