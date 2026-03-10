import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:shake/shake.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../providers/location_provider.dart';
import '../providers/contacts_provider.dart';
import '../services/email_service.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../services/tide_service.dart';
import '../services/volume_sos_service.dart';
import '../services/audio_recording_service.dart';
import '../models/tide_model.dart';
import '../models/contact_model.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/sos_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _isSendingSOS = false;
  TideModel? _todayTide;
  ShakeDetector? _shakeDetector;
  bool _shakeToSOSEnabled = true;
  final VolumeSOSService _volumeSOSService = VolumeSOSService();
  bool _volumeSOSEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Callbacks nhận sự kiện thay đổi hạng tài khoản
    AuthService().onProUpgraded = () {
      if (mounted) _showProCelebrationDialog();
    };
    AuthService().onProDowngraded = () {
      if (mounted) _showProDowngradeDialog();
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().startLocationTracking();
      _loadTodayTide();
      _initShakeDetector();
      _initVolumeSOSDetector();
    });
  }

  /// Khi app trở lại foreground, refresh trạng thái user để phát hiện nâng cấp Pro.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshUserStatus();
    }
  }

  Future<void> _refreshUserStatus() async {
    final auth = AuthService();
    if (!auth.isLoggedIn) return;
    final ok = await auth.loadCurrentUser();
    if (ok && mounted) {
      // Sync lại UserProvider từ AuthService
      final user = auth.currentUser;
      if (user != null) {
        context.read<UserProvider>().saveUser(user);
      }
    }
  }

  /// Dialog ăn mừng nâng cấp Pro.
  void _showProCelebrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ProUpgradeDialog(),
    );
  }

  /// Dialog thông báo hạ về Free.
  void _showProDowngradeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ProDowngradeDialog(),
    );
  }

  void _initShakeDetector() {
    if (!_shakeToSOSEnabled) return;
    
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) {
        _onShakeDetected();
      },
      minimumShakeCount: 2, // Cần rung 2 lần
      shakeSlopTimeMS: 500, // Trong khoảng 500ms
      shakeCountResetTime: 3000, // Reset sau 3 giây
      shakeThresholdGravity: 2.7, // Độ mạnh (2.7 = rung khá mạnh)
    );
  }

  void _initVolumeSOSDetector() {
    if (!_volumeSOSEnabled) return;
    
    _volumeSOSService.initialize(
      onTriplePress: () {
        _onVolumeTriplePress();
      },
    );
  }

  void _onShakeDetected() {
    if (_isSendingSOS) return; // Đang gửi SOS rồi thì không làm gì
    
    // Vibrate để người dùng biết đã phát hiện rung
    // HapticFeedback.heavyImpact();
    
    // Hiển thị dialog xác nhận
    _showShakeSOSDialog();
  }

  void _onVolumeTriplePress() {
    if (_isSendingSOS) return; // Đang gửi SOS rồi thì không làm gì
    
    // Hiển thị dialog xác nhận
    _showVolumeSOSDialog();
  }

  void _showShakeSOSDialog() {
    final l10n = AppLocalizations.of(context)!;
    Timer? autoSendTimer;
    autoSendTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.of(context).pop();
      _sendQuickSOS();
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 48,
        ),
        title: Text(
          l10n.shakeDetected,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.sendSOSNow,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.autoSendSOSIn5Seconds,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              autoSendTimer?.cancel();
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              autoSendTimer?.cancel();
              Navigator.pop(dialogContext);
              _sendQuickSOS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.sendSOSButton),
          ),
        ],
      ),
    );
  }

  void _showVolumeSOSDialog() {
    final l10n = AppLocalizations.of(context)!;
    Timer? autoSendTimer;
    autoSendTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.of(context).pop();
      _sendQuickSOS();
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.volume_up_rounded,
          color: Colors.red,
          size: 48,
        ),
        title: const Text(
          '🚨 PHÁT HIỆN NÚT ÂM LƯỢNG',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.sendSOSNow,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.autoSendSOSIn5Seconds,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              autoSendTimer?.cancel();
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              autoSendTimer?.cancel();
              Navigator.pop(dialogContext);
              _sendQuickSOS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.sendSOSButton),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTodayTide() async {
    final tide = await TideService.getTodayTide();
    if (mounted) {
      setState(() => _todayTide = tide);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AuthService().onProUpgraded   = null;
    AuthService().onProDowngraded = null;
    _shakeDetector?.stopListening();
    _volumeSOSService.dispose();
    context.read<LocationProvider>().stopLocationTracking();
    super.dispose();
  }

  Future<void> _handleSOS() async {
    final userProvider = context.read<UserProvider>();
    final locationProvider = context.read<LocationProvider>();
    final l10n = AppLocalizations.of(context)!;

    // Kiểm tra user
    if (!userProvider.hasUser) {
      _showMessage(l10n.updateUserInfo, isError: true);
      return;
    }

    // Kiểm tra vị trí
    if (locationProvider.latitude == null) {
      _showMessage(l10n.gettingLocationProgress, isError: false);
      await locationProvider.getCurrentLocation();
      if (locationProvider.latitude == null) {
        _showMessage(l10n.cannotGetLocation, isError: true);
        return;
      }
    }

    // Mở màn hình SOS form
    Navigator.pushNamed(context, '/sos-form');
  }

  // Gửi SOS nhanh khi shake (không cần ảnh và mô tả)
  Future<void> _sendQuickSOS() async {
    setState(() => _isSendingSOS = true);

    try {
      final userProvider = context.read<UserProvider>();
      final locationProvider = context.read<LocationProvider>();
      final contactsProvider = context.read<ContactsProvider>();
      final l10n = AppLocalizations.of(context)!;

      // Kiểm tra user
      if (!userProvider.hasUser) {
        _showMessage(l10n.updateUserInfo, isError: true);
        return;
      }

      final user = userProvider.user!;

      // Kiểm tra vị trí
      if (locationProvider.latitude == null) {
        _showMessage(l10n.gettingLocationProgress, isError: false);
        await locationProvider.getCurrentLocation();
        if (locationProvider.latitude == null) {
          _showMessage(l10n.cannotGetLocation, isError: true);
          return;
        }
      }

      final latitude = locationProvider.latitude!;
      final longitude = locationProvider.longitude!;
      final address = locationProvider.currentAddress;

      // (1) Gửi SOS lên backend để Admin Dashboard cập nhật (nếu đã đăng nhập)
      Map<String, dynamic>? apiResult;
      if (AuthService().isLoggedIn) {
        apiResult = await AuthService().createSOSReport(
          latitude: latitude,
          longitude: longitude,
          message: l10n.autoWarning,
        );
      }

      // Lưu SOS alert vào database
      await DatabaseService.instance.insertSOSAlert(
        userId: user.id ?? 1,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      // Lấy danh sách email
      final emails = contactsProvider.getEmergencyEmails();
      if (user.email.isNotEmpty) {
        emails.insert(0, user.email);
      }

      if (emails.isEmpty) {
        if (mounted) {
          _showMessage(l10n.pleaseAddEmergencyEmail, isError: true);
        }
        return;
      }

      // Ghi âm 5 giây cho trường hợp khẩn cấp (shake/volume trigger)
      File? audioFile;
      if (mounted) {
        _showMessage('🎤 Đang ghi âm...', isError: false);
      }
      
      try {
        audioFile = await AudioRecordingService().recordAudio(durationSeconds: 5);
        if (mounted && audioFile != null) {
          _showMessage('✅ Đã ghi âm xong, đang gửi SOS...', isError: false);
        }
      } catch (e) {
        debugPrint('Error recording audio: $e');
        // Tiếp tục gửi SOS dù không ghi được âm
      }

      // Gửi email SOS với file audio đính kèm
      final success = await EmailService.sendSOSEmail(
        userName: user.fullName,
        userEmail: user.email,
        address: address,
        latitude: latitude,
        longitude: longitude,
        recipientEmails: emails,
        description: l10n.autoWarning,
        imageFile: null, // Không cần ảnh
        audioFile: audioFile, // Đính kèm file audio nếu có
      );

      if (mounted) {
        if (apiResult != null && apiResult['success'] == true) {
          // Server đã nhận SOS -> dashboard sẽ thấy
          final msg = success
              ? '✅ Đã gửi SOS lên hệ thống + ${emails.length} email!'
              : '✅ Đã gửi SOS lên hệ thống (email thất bại)';
          _showMessage(msg, isError: false);
        } else if (apiResult != null && apiResult['success'] == false) {
          // Có token nhưng post fail (thường do token hết hạn)
          final msg = success
              ? '⚠️ Đã gửi email nhưng lỗi server: ${apiResult['error']}'
              : '❌ Lỗi server: ${apiResult['error']}';
          _showMessage(msg, isError: !success);
        } else {
          // Chưa đăng nhập -> không post server được, chỉ email
          if (success) {
            _showMessage(l10n.sosSentSuccess(emails.length), isError: false);
          } else {
            _showMessage(l10n.sosError, isError: true);
          }
        }
      }
    } catch (e) {
      print('Error sending quick SOS: $e');
      if (mounted) {
        _showMessage('Error: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSendingSOS = false);
      }
    }
  }


  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Hiển thị dialog chia sẻ vị trí
  void _showShareLocationDialog() {
    final contactsProvider = context.read<ContactsProvider>();
    final allContacts = contactsProvider.allContacts;
    final l10n = AppLocalizations.of(context)!;
    
    // Lọc contacts có email
    final contactsWithEmail = allContacts.where((c) => c.contactEmail != null && c.contactEmail!.isNotEmpty).toList();
    
    if (contactsWithEmail.isEmpty) {
      _showMessage(l10n.noContactWithEmail, isError: true);
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.share_location, color: Colors.blue),
            const SizedBox(width: 8),
            Text(l10n.shareLocation),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: contactsWithEmail.length,
            itemBuilder: (context, index) {
              final contact = contactsWithEmail[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.person, color: Colors.blue.shade700),
                ),
                title: Text(contact.contactName),
                subtitle: Text(contact.contactEmail ?? ''),
                onTap: () {
                  Navigator.pop(context);
                  _shareLocation(contact.contactEmail!);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  // Chia sẻ vị trí qua email
  Future<void> _shareLocation(String recipientEmail) async {
    final userProvider = context.read<UserProvider>();
    final locationProvider = context.read<LocationProvider>();
    final l10n = AppLocalizations.of(context)!;
    
    if (!userProvider.hasUser) {
      _showMessage(l10n.updateUserInfo, isError: true);
      return;
    }
    
    if (locationProvider.latitude == null) {
      _showMessage(l10n.cannotGetLocation, isError: true);
      return;
    }
    
    _showMessage(l10n.sendingLocation, isError: false);
    
    final user = userProvider.user!;
    final success = await EmailService.sendLocationEmail(
      userName: user.fullName,
      userEmail: user.email,
      address: locationProvider.currentAddress,
      latitude: locationProvider.latitude!,
      longitude: locationProvider.longitude!,
      recipientEmail: recipientEmail,
    );
    
    if (success) {
      _showMessage(l10n.locationShared, isError: false);
    } else {
      _showMessage(l10n.cannotShareLocation, isError: true);
    }
  }

  Future<void> _callEmergency(String phone) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final uri = Uri(scheme: 'tel', path: phone);
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(uri);
      } else {
        _showMessage(l10n.cannotCall, isError: true);
      }
    } catch (e) {
      _showMessage(l10n.cannotCall, isError: true);
    }
  }

  // Hiển thị dialog để thêm contact mới
  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addContact),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                hintText: l10n.nameHint,
                prefixIcon: const Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: l10n.phoneNumber,
                hintText: l10n.phoneHint,
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              
              if (name.isEmpty || phone.isEmpty) {
                _showMessage(l10n.pleaseEnterAllInfo, isError: true);
                return;
              }
              
              final contact = ContactModel(
                contactName: name,
                contactPhone: phone,
                contactType: 'personal',
              );
              
              final success = await context.read<ContactsProvider>().addContact(contact);
              
              if (success) {
                Navigator.pop(context);
                _showMessage(l10n.contactAdded, isError: false);
              } else {
                _showMessage(l10n.cannotAddContact, isError: true);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  // Xác nhận xóa contact
  void _confirmDeleteContact(ContactModel contact) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteContact),
        content: Text(l10n.deleteContactConfirm(contact.contactName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await context.read<ContactsProvider>().deleteContact(contact.id!);
              
              Navigator.pop(context);
              
              if (success) {
                _showMessage(l10n.contactDeleted, isError: false);
              } else {
                _showMessage(l10n.cannotDeleteContact, isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildTideMiniInfo({
    required IconData icon,
    required String label,
    required String value,
    required String time,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await locationProvider.getCurrentLocation();
              _showMessage(l10n.locationUpdated);
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome message
              if (userProvider.hasUser)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.hello,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          userProvider.user!.fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Current location
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(
                                l10n.currentLocation,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (locationProvider.latitude != null)
                            ElevatedButton.icon(
                              onPressed: () => _showShareLocationDialog(),
                              icon: const Icon(Icons.share, size: 16),
                              label: Text(l10n.share),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        locationProvider.currentAddress.isEmpty
                            ? l10n.gettingLocation
                            : locationProvider.currentAddress,
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (locationProvider.latitude != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${l10n.coordinates}: ${locationProvider.latitude!.toStringAsFixed(6)}, ${locationProvider.longitude!.toStringAsFixed(6)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Mực nước sông Mekong - ĐÃ ẨN (uncomment để bật lại)
              // Card(
              //   color: Colors.lightBlue[50],
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.pushNamed(context, '/water-level');
              //     },
              //     borderRadius: BorderRadius.circular(12),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Row(
              //         children: [
              //           Container(
              //             padding: const EdgeInsets.all(12),
              //             decoration: BoxDecoration(
              //               color: Colors.blue[700],
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //             child: const Icon(
              //               Icons.waves,
              //               color: Colors.white,
              //               size: 28,
              //             ),
              //           ),
              //           const SizedBox(width: 16),
              //           Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   l10n.mekongWaterLevel,
              //                   style: const TextStyle(
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 const SizedBox(height: 4),
              //                 Text(
              //                   l10n.track5Stations,
              //                   style: const TextStyle(
              //                     fontSize: 13,
              //                     color: Colors.grey,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           const Icon(
              //             Icons.arrow_forward_ios,
              //             size: 16,
              //             color: Colors.grey,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),

              // SOS Button
              Builder(builder: (context) {
                final user = AuthService().currentUser;
                return SOSButton(
                  onPressed: _isSendingSOS ? null : _handleSOS,
                  isLoading: _isSendingSOS,
                  isPro: user?.isPro ?? false,
                  sosUsed: user?.sosCount ?? 0,
                  sosLimit: 10,
                );
              }),
              const SizedBox(height: 30),

              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.quickCall,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddContactDialog(),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: Text(l10n.add),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Nút gọi nhanh khẩn cấp
              Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _QuickCallButton(
                              icon: Icons.security,
                              label: 'Bảo vệ FPT',
                              phone: '0123456789',
                              color: Colors.blue,
                              onTap: () => _callEmergency('0123456789'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickCallButton(
                              icon: Icons.local_police,
                              label: 'Công an 113',
                              phone: '113',
                              color: Colors.red,
                              onTap: () => _callEmergency('113'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _QuickCallButton(
                              icon: Icons.local_hospital,
                              label: 'Y tế 115',
                              phone: '115',
                              color: Colors.green,
                              onTap: () => _callEmergency('115'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickCallButton(
                              icon: Icons.fire_truck,
                              label: 'Cứu hỏa 114',
                              phone: '114',
                              color: Colors.orange,
                              onTap: () => _callEmergency('114'),
                            ),
                          ),
                        ],
                      ),
                      
                      // Liên hệ cá nhân user đã thêm
                      Consumer<ContactsProvider>(
                        builder: (context, cp, _) {
                          if (cp.personalContacts.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  l10n.personalContacts,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...cp.personalContacts.map((contact) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: _PersonalContactCard(
                                    contact: contact,
                                    onCall: () => _callEmergency(contact.contactPhone.replaceAll(RegExp(r'[^0-9]'), '')),
                                    onDelete: () => _confirmDeleteContact(contact),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _QuickCallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String phone;
  final Color color;
  final VoidCallback onTap;

  const _QuickCallButton({
    required this.icon,
    required this.label,
    required this.phone,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pro Upgrade Celebration Dialog ──────────────────────────────────────────

class _ProUpgradeDialog extends StatefulWidget {
  @override
  State<_ProUpgradeDialog> createState() => _ProUpgradeDialogState();
}

class _ProUpgradeDialogState extends State<_ProUpgradeDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proFeatures = [
      'SOS không giới hạn mỗi tháng',
      'Tự động ghi âm hiện trường khi gửi SOS',
      'Bảo vệ chạy nền liên tục',
      'Chia sẻ vị trí thời gian thực (link theo dõi)',
      'Lịch sử & thống kê SOS',
      'Khu vực an toàn (Geofence) với cảnh báo email',
      'Thêm không giới hạn liên hệ khẩn cấp',
    ];

    return FadeTransition(
      opacity: _fade,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Crown icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber.withValues(alpha: 30 / 255),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: const Text('👑', style: TextStyle(fontSize: 40)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chúc mừng!',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tài khoản của bạn đã được\nnâng cấp lên PRO',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 20),
                // Divider
                Container(height: 1, color: Colors.amber.withValues(alpha: 60 / 255)),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bạn đã mở khóa:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...proFeatures.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✦ ', style: TextStyle(color: Colors.amber, fontSize: 13)),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text(
                      'Bắt đầu trải nghiệm PRO  🚀',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Pro Downgrade Notification Dialog ───────────────────────────────────────

class _ProDowngradeDialog extends StatefulWidget {
  @override
  State<_ProDowngradeDialog> createState() => _ProDowngradeDialogState();
}

class _ProDowngradeDialogState extends State<_ProDowngradeDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const lockedFeatures = [
      'Ghi âm tự động khi gửi SOS',
      'Bảo vệ chạy nền',
      'Chia sẻ vị trí thời gian thực',
      'Lịch sử & thống kê SOS',
      'Khu vực an toàn (Geofence)',
      'Không giới hạn liên hệ (còn tối đa 3)',
    ];

    return FadeTransition(
      opacity: _fade,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon khoá
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withValues(alpha: 0.15),
                    border: Border.all(color: Colors.grey[600]!, width: 2),
                  ),
                  child: const Text('🔒', style: TextStyle(fontSize: 38)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tài khoản đã hạ về FREE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Gói Pro của bạn đã hết hạn hoặc bị thu hồi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 20),
                Container(height: 1, color: Colors.grey[700]),
                const SizedBox(height: 14),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Các tính năng bị khóa:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...lockedFeatures.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✕ ', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                      Expanded(
                        child: Text(
                          f,
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'SOS free: tối đa 10 lần/tháng, tự reset đầu tháng.',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text(
                      'Đã hiểu',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PersonalContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onCall;
  final VoidCallback onDelete;

  const _PersonalContactCard({
    required this.contact,
    required this.onCall,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            Icons.person,
            color: Colors.blue.shade700,
          ),
        ),
        title: Text(
          contact.contactName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          contact.contactPhone,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: onCall,
              tooltip: 'Gọi điện',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Xóa',
            ),
          ],
        ),
      ),
    );
  }
}
