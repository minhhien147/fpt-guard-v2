import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'screens/water_level_screen.dart';
import 'providers/user_provider.dart';
import 'providers/location_provider.dart';
import 'providers/contacts_provider.dart';
import 'providers/water_level_provider.dart';
import 'providers/locale_provider.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  // Initialize database
  await DatabaseService.instance.database;
  
  // Initialize locale
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();
  
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
        ChangeNotifierProvider(create: (_) => WaterLevelProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'FPT Guard 2.0',
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
                seedColor: Colors.orange,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.orange,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
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
              '/water-level': (context) => const WaterLevelScreen(),
            },
          );
        },
      ),
    );
  }
}

