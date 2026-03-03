import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../providers/locale_provider.dart';
import '../models/user_model.dart';
import '../widgets/custom_drawer.dart';
import '../services/auth_service.dart';
import '../services/foreground_service_controller.dart';
import '../services/location_share_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _backgroundEnabled = false;
  String? _shareUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBackgroundSetting();
  }

  void _loadUserData() {
    final userProvider = context.read<UserProvider>();
    if (userProvider.hasUser) {
      final user = userProvider.user!;
      _nameController.text = user.fullName;
      _studentIdController.text = user.studentId;
      _phoneController.text = user.phone;
      _emailController.text = user.email;
    }
  }

  Future<void> _loadBackgroundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('background_protection_enabled') ?? false;
    final url = await LocationShareService().getShareUrl();
    if (mounted) {
      setState(() {
        _shareUrl = url;
        _backgroundEnabled = enabled;
      });
    }
  }

  Future<void> _toggleBackgroundProtection(bool value) async {
    // Kiểm tra Pro
    final user = AuthService().currentUser;
    if (value && user != null && !user.isPro) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Tính năng Pro'),
          content: const Text(
            'Chạy nền là tính năng dành cho tài khoản Pro.\n\nLiên hệ admin để được nâng cấp.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() { _backgroundEnabled = value; });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('background_protection_enabled', value);

    if (value) {
      await ForegroundServiceController.start();
      // Start location share (Pro only)
      final user = AuthService().currentUser;
      if (user != null && user.isPro) {
        await LocationShareService().start();
        final url = await LocationShareService().getShareUrl();
        if (mounted) setState(() => _shareUrl = url);
      }
    } else {
      await ForegroundServiceController.stop();
      LocationShareService().stop();
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value ? 'Đã bật chế độ bảo vệ 24/7' : 'Đã tắt chế độ bảo vệ',
        ),
        backgroundColor: value ? Colors.green : Colors.grey[700],
      ),
    );
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final user = UserModel(
      fullName: _nameController.text,
      studentId: _studentIdController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      createdAt: DateTime.now(),
    );

    final success = await context.read<UserProvider>().saveUser(user);

    setState(() => _isLoading = false);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? l10n.saved : l10n.error),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
  
  void _showLanguageDialog(BuildContext context, LocaleProvider localeProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleProvider.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              title: Text(localeProvider.getLanguageName(locale.languageCode)),
              value: locale,
              groupValue: localeProvider.locale,
              onChanged: (Locale? value) {
                if (value != null) {
                  localeProvider.setLocale(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      // Logout
      await AuthService().logout();
      
      // Clear user provider
      if (mounted) {
        context.read<UserProvider>().clearUser();
      }
      
      // Navigate to login
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCAF0F8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF0077B6),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Language selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.language,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(l10n.selectLanguage),
                        subtitle: Text(localeProvider.getLanguageName(localeProvider.locale.languageCode)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showLanguageDialog(context, localeProvider),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Background protection toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bảo vệ chạy nền',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Giữ SAFE GUARD hoạt động khi thu nhỏ ứng dụng để hỗ trợ SOS và vị trí khẩn cấp.',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Bật chạy nền (Foreground Service)'),
                        subtitle: Text(
                          _backgroundEnabled
                              ? 'Đang chạy nền'
                              : 'Đã tắt, chỉ hoạt động khi mở app',
                          style: TextStyle(
                            color: _backgroundEnabled
                                ? Colors.green[700]
                                : Colors.grey[600],
                          ),
                        ),
                        value: _backgroundEnabled,
                        onChanged: _toggleBackgroundProtection,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Real-time location share (Pro)
              Consumer<UserProvider>(
                builder: (context, up, _) {
                  final isPro = up.user?.isPro ?? false;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Chia sẻ vị trí thời gian thực',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              if (isPro)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.amber[100],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text('PRO',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isPro
                                ? 'Khi bật bảo vệ chạy nền, vị trí cập nhật mỗi 60 giây. Gửi link cho người thân để theo dõi.'
                                : 'Nâng cấp Pro để chia sẻ vị trí thời gian thực với người thân.',
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          if (isPro && _shareUrl != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Link theo dõi vị trí:',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(_shareUrl!,
                                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                                      maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: _shareUrl!));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Đã sao chép link!')),
                                        );
                                      },
                                      icon: const Icon(Icons.copy, size: 16),
                                      label: const Text('Sao chép link'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (isPro && _shareUrl == null && _backgroundEnabled) ...[
                            const SizedBox(height: 10),
                            const Text('Đang khởi tạo link chia sẻ...',
                                style: TextStyle(fontSize: 13, color: Colors.grey)),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Geofence shortcut
              Card(
                child: ListTile(
                  leading: const Icon(Icons.fence, color: Color(0xFF0077B6)),
                  title: const Text('Khu vực an toàn (Geofence)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Cảnh báo khi ra khỏi vùng định sẵn'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.pushNamed(context, '/geofence'),
                ),
              ),
              const SizedBox(height: 20),

              // Form fields
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.personalInfo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.fullNameRequired,
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.validationName;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      
                      TextFormField(
                        controller: _studentIdController,
                        decoration: InputDecoration(
                          labelText: l10n.studentIdRequired,
                          prefixIcon: const Icon(Icons.badge),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.validationStudentId;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: l10n.phoneRequired,
                          prefixIcon: const Icon(Icons.phone),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.validationPhone;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: l10n.emailRequired,
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(),
                          helperText: l10n.emailHelper,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.validationEmail;
                          }
                          if (!value.contains('@')) {
                            return l10n.validationEmailInvalid;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.saveInfo,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              
              const SizedBox(height: 30),
              
              // App info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appInfo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _InfoRow(
                        icon: Icons.info,
                        label: l10n.version,
                        value: '2.0.0',
                      ),
                      const Divider(),
                      _InfoRow(
                        icon: Icons.school,
                        label: l10n.organization,
                        value: l10n.organizationName,
                      ),
                      const Divider(),
                      _InfoRow(
                        icon: Icons.shield,
                        label: l10n.application,
                        value: l10n.appName,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Logout button (only show if logged in)
              if (AuthService().isLoggedIn) ...[
                const SizedBox(height: 20),
                Card(
                  color: Colors.red[50],
                  child: InkWell(
                    onTap: _handleLogout,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đăng xuất',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[900],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Đăng xuất khỏi tài khoản hiện tại',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red[700]),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

