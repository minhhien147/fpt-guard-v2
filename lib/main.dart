import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/location_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/news_screen.dart';
import 'screens/tide_screen.dart';
import 'screens/sos_form_screen.dart';
import 'screens/group_login_screen.dart';
import 'screens/verify_email_screen.dart';
// import 'screens/water_level_screen.dart'; // ĐÃ ẨN - uncomment để bật lại
import 'providers/user_provider.dart';
import 'providers/location_provider.dart';
import 'providers/contacts_provider.dart';
// import 'providers/water_level_provider.dart'; // ĐÃ ẨN - uncomment để bật lại
import 'providers/locale_provider.dart';
import 'services/database_service.dart';
import 'services/foreground_service_controller.dart';
import 'services/auth_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables (with error handling)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // If .env file doesn't exist, use default values
    debugPrint('Warning: .env file not found, using default configuration');
    dotenv.env['API_BASE_URL'] = 'https://web-production-dd806.up.railway.app';
  }
  
  // Initialize database
  await DatabaseService.instance.database;
  
  // Initialize locale
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  // Chỉ tự động bật foreground service nếu người dùng đã chủ động bật trước đó
  try {
    final prefs = await SharedPreferences.getInstance();
    final backgroundEnabled =
        prefs.getBool('background_protection_enabled') ?? false;
    if (backgroundEnabled) {
      await ForegroundServiceController.start();
    }
  } catch (e) {
    debugPrint('Error starting foreground service from main: $e');
  }

  // Khi admin khóa tài khoản (401/403), app tự logout và chuyển về màn login
  AuthService().onUnauthorized = () {
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  };

  runApp(MyApp(localeProvider: localeProvider));
}

class MyApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  
  const MyApp({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
        // ChangeNotifierProvider(create: (_) => WaterLevelProvider()), // ĐÃ ẨN - uncomment để bật lại
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'SAFE GUARD',
            debugShowCheckedModeBanner: false,
            // Localization
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
            
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00B4D8),
                brightness: Brightness.light,
                primary: const Color(0xFF0077B6),
                secondary: const Color(0xFF00B4D8),
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Color(0xFF03045E),
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF00B4D8),
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00B4D8),
                brightness: Brightness.dark,
                primary: const Color(0xFF00B4D8),
                secondary: const Color(0xFF90E0EF),
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Color(0xFF03045E),
                foregroundColor: Colors.white,
              ),
            ),
            themeMode: ThemeMode.system,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/contacts': (context) => const ContactsScreen(),
              '/location': (context) => const LocationScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/news': (context) => const NewsScreen(),
              '/tide': (context) => const TideScreen(),
              '/sos-form': (context) => const SOSFormScreen(),
              '/group-login': (context) => const GroupLoginScreen(),
              // VerifyEmailScreen needs email arg → pushed via MaterialPageRoute, not named route
              // '/water-level': (context) => const WaterLevelScreen(), // ĐÃ ẨN - uncomment để bật lại
            },
          );
        },
      ),
    );
  }
}

