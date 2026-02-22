import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';
import '../providers/location_provider.dart';
import '../providers/contacts_provider.dart';

class GroupLoginScreen extends StatefulWidget {
  const GroupLoginScreen({super.key});

  @override
  State<GroupLoginScreen> createState() => _GroupLoginScreenState();
}

class _GroupLoginScreenState extends State<GroupLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _handleGroupLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService().groupLogin(
      code: _codeController.text.trim().toUpperCase(),
      nickname: _nicknameController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false).loadUser();
        await Provider.of<ContactsProvider>(context, listen: false).loadContacts();
        await Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      setState(() => _errorMessage = result['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF03045E),
              Color(0xFF023E8A),
              Color(0xFF0077B6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),

                        // Icon
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFF03045E),
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00B4D8).withOpacity(0.4),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.group,
                            size: 36,
                            color: Color(0xFF00B4D8),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          'Đăng nhập nhóm',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0077B6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nhập mã nhóm do quản trị viên cung cấp',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        // Info box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B4D8).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF00B4D8).withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline,
                                  size: 18, color: Color(0xFF0077B6)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Mỗi tên hiển thị trong cùng nhóm là duy nhất. '
                                  'Dùng cùng tên ở thiết bị khác để tiếp tục phiên của bạn.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0077B6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Error message
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red.shade700),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Colors.red.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Group code field
                        TextFormField(
                          controller: _codeController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            labelText: 'Mã nhóm',
                            hintText: 'Ví dụ: FPT2024',
                            prefixIcon: const Icon(Icons.key_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập mã nhóm';
                            }
                            if (value.trim().length < 3) {
                              return 'Mã nhóm quá ngắn';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Nickname field
                        TextFormField(
                          controller: _nicknameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Tên hiển thị',
                            hintText: 'Ví dụ: Nguyen Van A',
                            prefixIcon: const Icon(Icons.person_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập tên hiển thị';
                            }
                            if (value.trim().length < 2) {
                              return 'Tên phải có ít nhất 2 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleGroupLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0077B6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Vào nhóm',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
