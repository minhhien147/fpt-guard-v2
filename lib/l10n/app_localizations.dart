import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('vi')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'SAFE GUARD'**
  String get appTitle;

  /// Greeting
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting location...'**
  String get gettingLocation;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share Location'**
  String get shareLocation;

  /// No description provided for @mekongWaterLevel.
  ///
  /// In en, this message translates to:
  /// **'Mekong River Water Level'**
  String get mekongWaterLevel;

  /// No description provided for @track5Stations.
  ///
  /// In en, this message translates to:
  /// **'Track 5 Delta Stations'**
  String get track5Stations;

  /// No description provided for @sosButton.
  ///
  /// In en, this message translates to:
  /// **'SOS Emergency'**
  String get sosButton;

  /// No description provided for @sendingSOS.
  ///
  /// In en, this message translates to:
  /// **'Sending SOS...'**
  String get sendingSOS;

  /// No description provided for @quickCall.
  ///
  /// In en, this message translates to:
  /// **'Quick Call'**
  String get quickCall;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Dad, Mom, Best friend...'**
  String get nameHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: 0901234567'**
  String get phoneHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @police.
  ///
  /// In en, this message translates to:
  /// **'Police 113'**
  String get police;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital 115'**
  String get hospital;

  /// No description provided for @fireStation.
  ///
  /// In en, this message translates to:
  /// **'Fire Station 114'**
  String get fireStation;

  /// No description provided for @personalContacts.
  ///
  /// In en, this message translates to:
  /// **'Personal Contacts'**
  String get personalContacts;

  /// No description provided for @deleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete Contact'**
  String get deleteContact;

  /// No description provided for @deleteContactConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\" from contacts?'**
  String deleteContactConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullNameRequired;

  /// No description provided for @studentId.
  ///
  /// In en, this message translates to:
  /// **'Student ID'**
  String get studentId;

  /// No description provided for @studentIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Student ID *'**
  String get studentIdRequired;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone *'**
  String get phoneRequired;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailRequired;

  /// No description provided for @emailHelper.
  ///
  /// In en, this message translates to:
  /// **'Email to receive emergency alerts'**
  String get emailHelper;

  /// No description provided for @saveInfo.
  ///
  /// In en, this message translates to:
  /// **'Save Information'**
  String get saveInfo;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Information saved'**
  String get saved;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfo;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @organizationName.
  ///
  /// In en, this message translates to:
  /// **'FPT University Can Tho'**
  String get organizationName;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SAFE GUARD'**
  String get appName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @validationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get validationName;

  /// No description provided for @validationStudentId.
  ///
  /// In en, this message translates to:
  /// **'Please enter student ID'**
  String get validationStudentId;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get validationPhone;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get validationEmail;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validationEmailInvalid;

  /// No description provided for @updateUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Please update personal information in Settings'**
  String get updateUserInfo;

  /// No description provided for @gettingLocationProgress.
  ///
  /// In en, this message translates to:
  /// **'Getting location...'**
  String get gettingLocationProgress;

  /// No description provided for @cannotGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Cannot get location. Please enable GPS'**
  String get cannotGetLocation;

  /// No description provided for @pleaseAddEmergencyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please add emergency contact email in Contacts'**
  String get pleaseAddEmergencyEmail;

  /// No description provided for @cannotCall.
  ///
  /// In en, this message translates to:
  /// **'Cannot make call'**
  String get cannotCall;

  /// No description provided for @noContactWithEmail.
  ///
  /// In en, this message translates to:
  /// **'No contact with email to share'**
  String get noContactWithEmail;

  /// No description provided for @sendingLocation.
  ///
  /// In en, this message translates to:
  /// **'Sending location...'**
  String get sendingLocation;

  /// No description provided for @locationShared.
  ///
  /// In en, this message translates to:
  /// **'✅ Location shared successfully!'**
  String get locationShared;

  /// No description provided for @cannotShareLocation.
  ///
  /// In en, this message translates to:
  /// **'❌ Cannot share location'**
  String get cannotShareLocation;

  /// No description provided for @locationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Location updated'**
  String get locationUpdated;

  /// No description provided for @pleaseEnterAllInfo.
  ///
  /// In en, this message translates to:
  /// **'Please enter all information'**
  String get pleaseEnterAllInfo;

  /// No description provided for @contactAdded.
  ///
  /// In en, this message translates to:
  /// **'Contact added'**
  String get contactAdded;

  /// No description provided for @cannotAddContact.
  ///
  /// In en, this message translates to:
  /// **'Cannot add contact'**
  String get cannotAddContact;

  /// No description provided for @contactDeleted.
  ///
  /// In en, this message translates to:
  /// **'Contact deleted'**
  String get contactDeleted;

  /// No description provided for @cannotDeleteContact.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete contact'**
  String get cannotDeleteContact;

  /// No description provided for @shakeDetected.
  ///
  /// In en, this message translates to:
  /// **'Shake Detected!'**
  String get shakeDetected;

  /// No description provided for @sendSOSNow.
  ///
  /// In en, this message translates to:
  /// **'Send SOS emergency alert immediately?\n(No photo needed)'**
  String get sendSOSNow;

  /// No description provided for @sendSOSButton.
  ///
  /// In en, this message translates to:
  /// **'Send SOS Now'**
  String get sendSOSButton;

  /// No description provided for @autoSendSOSIn5Seconds.
  ///
  /// In en, this message translates to:
  /// **'Auto record and send SOS in 5 seconds if not cancelled.'**
  String get autoSendSOSIn5Seconds;

  /// No description provided for @autoWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ AUTO WARNING: Emergency shake detected from device!'**
  String get autoWarning;

  /// No description provided for @sosSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ SOS alert sent to {count} email(s)!'**
  String sosSentSuccess(int count);

  /// No description provided for @sosError.
  ///
  /// In en, this message translates to:
  /// **'❌ Error sending email'**
  String get sosError;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @tide.
  ///
  /// In en, this message translates to:
  /// **'Tide'**
  String get tide;

  /// No description provided for @waterLevel.
  ///
  /// In en, this message translates to:
  /// **'Water Level'**
  String get waterLevel;

  /// No description provided for @sosForm.
  ///
  /// In en, this message translates to:
  /// **'SOS Form'**
  String get sosForm;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
