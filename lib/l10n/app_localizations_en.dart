// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SAFE GUARD';

  @override
  String get hello => 'Hello';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get gettingLocation => 'Getting location...';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get share => 'Share';

  @override
  String get shareLocation => 'Share Location';

  @override
  String get mekongWaterLevel => 'Mekong River Water Level';

  @override
  String get track5Stations => 'Track 5 Delta Stations';

  @override
  String get sosButton => 'SOS Emergency';

  @override
  String get sendingSOS => 'Sending SOS...';

  @override
  String get quickCall => 'Quick Call';

  @override
  String get add => 'Add';

  @override
  String get addContact => 'Add Contact';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'E.g.: Dad, Mom, Best friend...';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneHint => 'E.g.: 0901234567';

  @override
  String get cancel => 'Cancel';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get security => 'Security';

  @override
  String get police => 'Police 113';

  @override
  String get hospital => 'Hospital 115';

  @override
  String get fireStation => 'Fire Station 114';

  @override
  String get personalContacts => 'Personal Contacts';

  @override
  String get deleteContact => 'Delete Contact';

  @override
  String deleteContactConfirm(String name) {
    return 'Are you sure you want to delete \"$name\" from contacts?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get settings => 'Settings';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameRequired => 'Full Name *';

  @override
  String get studentId => 'Student ID';

  @override
  String get studentIdRequired => 'Student ID *';

  @override
  String get phone => 'Phone';

  @override
  String get phoneRequired => 'Phone *';

  @override
  String get email => 'Email';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emailHelper => 'Email to receive emergency alerts';

  @override
  String get saveInfo => 'Save Information';

  @override
  String get saved => 'Information saved';

  @override
  String get error => 'An error occurred';

  @override
  String get appInfo => 'App Information';

  @override
  String get version => 'Version';

  @override
  String get organization => 'Organization';

  @override
  String get organizationName => 'FPT University Can Tho';

  @override
  String get application => 'Application';

  @override
  String get appName => 'SAFE GUARD';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get validationName => 'Please enter your name';

  @override
  String get validationStudentId => 'Please enter student ID';

  @override
  String get validationPhone => 'Please enter phone number';

  @override
  String get validationEmail => 'Please enter email';

  @override
  String get validationEmailInvalid => 'Invalid email';

  @override
  String get updateUserInfo => 'Please update personal information in Settings';

  @override
  String get gettingLocationProgress => 'Getting location...';

  @override
  String get cannotGetLocation => 'Cannot get location. Please enable GPS';

  @override
  String get pleaseAddEmergencyEmail =>
      'Please add emergency contact email in Contacts';

  @override
  String get cannotCall => 'Cannot make call';

  @override
  String get noContactWithEmail => 'No contact with email to share';

  @override
  String get sendingLocation => 'Sending location...';

  @override
  String get locationShared => '✅ Location shared successfully!';

  @override
  String get cannotShareLocation => '❌ Cannot share location';

  @override
  String get locationUpdated => 'Location updated';

  @override
  String get pleaseEnterAllInfo => 'Please enter all information';

  @override
  String get contactAdded => 'Contact added';

  @override
  String get cannotAddContact => 'Cannot add contact';

  @override
  String get contactDeleted => 'Contact deleted';

  @override
  String get cannotDeleteContact => 'Cannot delete contact';

  @override
  String get shakeDetected => 'Shake Detected!';

  @override
  String get sendSOSNow =>
      'Send SOS emergency alert immediately?\n(No photo needed)';

  @override
  String get sendSOSButton => 'Send SOS Now';

  @override
  String get autoSendSOSIn5Seconds =>
      'Auto record and send SOS in 5 seconds if not cancelled.';

  @override
  String get autoWarning =>
      '⚠️ AUTO WARNING: Emergency shake detected from device!';

  @override
  String sosSentSuccess(int count) {
    return '✅ SOS alert sent to $count email(s)!';
  }

  @override
  String get sosError => '❌ Error sending email';

  @override
  String get refresh => 'Refresh';

  @override
  String get call => 'Call';

  @override
  String get contacts => 'Contacts';

  @override
  String get location => 'Location';

  @override
  String get news => 'News';

  @override
  String get tide => 'Tide';

  @override
  String get waterLevel => 'Water Level';

  @override
  String get sosForm => 'SOS Form';

  @override
  String get home => 'Home';
}
