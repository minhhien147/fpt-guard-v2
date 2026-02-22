import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/location_provider.dart';
import '../providers/contacts_provider.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    // Initialize auth service
    final authService = AuthService();
    final isLoggedIn = await authService.init();
    
    // Wait minimum time for splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check if user is logged in
    if (isLoggedIn) {
      // Load user data
      await context.read<UserProvider>().loadUser();
      
      // Load contacts
      await context.read<ContactsProvider>().loadContacts();
      
      // Get current location
      await context.read<LocationProvider>().getCurrentLocation();
      await context.read<LocationProvider>().loadSafeLocations();
      
      // Navigate to home
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      // Navigate to login
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF03045E),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00B4D8).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF00B4D8).withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // App name
              const Text(
                'SAFE GUARD',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Version 2.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF90E0EF),
                ),
              ),
              const SizedBox(height: 56),

              // Loading indicator
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B4D8)),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Đang khởi động...',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF90E0EF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

