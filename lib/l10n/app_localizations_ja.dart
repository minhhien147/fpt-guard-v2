// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'FPT Guard';

  @override
  String get hello => 'こんにちは';

  @override
  String get currentLocation => '現在地';

  @override
  String get gettingLocation => '位置情報を取得中...';

  @override
  String get coordinates => '座標';

  @override
  String get share => '共有';

  @override
  String get shareLocation => '位置を共有';

  @override
  String get mekongWaterLevel => 'メコン川の水位';

  @override
  String get track5Stations => 'デルタの5つの駅を追跡';

  @override
  String get sosButton => 'SOS緊急';

  @override
  String get sendingSOS => 'SOSを送信中...';

  @override
  String get quickCall => 'クイックコール';

  @override
  String get add => '追加';

  @override
  String get addContact => '連絡先を追加';

  @override
  String get name => '名前';

  @override
  String get nameHint => '例: お父さん、お母さん、親友...';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get phoneHint => '例: 0901234567';

  @override
  String get cancel => 'キャンセル';

  @override
  String get emergencyContacts => '緊急連絡先';

  @override
  String get security => '警備';

  @override
  String get police => '警察 113';

  @override
  String get hospital => '病院 115';

  @override
  String get fireStation => '消防署 114';

  @override
  String get personalContacts => '個人の連絡先';

  @override
  String get deleteContact => '連絡先を削除';

  @override
  String deleteContactConfirm(String name) {
    return '連絡先から\"$name\"を削除してもよろしいですか？';
  }

  @override
  String get delete => '削除';

  @override
  String get settings => '設定';

  @override
  String get personalInfo => '個人情報';

  @override
  String get fullName => '氏名';

  @override
  String get fullNameRequired => '氏名 *';

  @override
  String get studentId => '学生ID';

  @override
  String get studentIdRequired => '学生ID *';

  @override
  String get phone => '電話番号';

  @override
  String get phoneRequired => '電話番号 *';

  @override
  String get email => 'メール';

  @override
  String get emailRequired => 'メール *';

  @override
  String get emailHelper => '緊急アラートを受信するメール';

  @override
  String get saveInfo => '情報を保存';

  @override
  String get saved => '情報が保存されました';

  @override
  String get error => 'エラーが発生しました';

  @override
  String get appInfo => 'アプリ情報';

  @override
  String get version => 'バージョン';

  @override
  String get organization => '組織';

  @override
  String get organizationName => 'FPT大学カントー';

  @override
  String get application => 'アプリケーション';

  @override
  String get appName => 'FPT Guard 2.0';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get validationName => '名前を入力してください';

  @override
  String get validationStudentId => '学生IDを入力してください';

  @override
  String get validationPhone => '電話番号を入力してください';

  @override
  String get validationEmail => 'メールを入力してください';

  @override
  String get validationEmailInvalid => '無効なメール';

  @override
  String get updateUserInfo => '設定で個人情報を更新してください';

  @override
  String get gettingLocationProgress => '位置情報を取得中...';

  @override
  String get cannotGetLocation => '位置情報を取得できません。GPSを有効にしてください';

  @override
  String get pleaseAddEmergencyEmail => '連絡先に緊急連絡先メールを追加してください';

  @override
  String get cannotCall => '電話をかけられません';

  @override
  String get noContactWithEmail => '共有するメールを持つ連絡先がありません';

  @override
  String get sendingLocation => '位置を送信中...';

  @override
  String get locationShared => '✅ 位置が正常に共有されました！';

  @override
  String get cannotShareLocation => '❌ 位置を共有できません';

  @override
  String get locationUpdated => '位置が更新されました';

  @override
  String get pleaseEnterAllInfo => 'すべての情報を入力してください';

  @override
  String get contactAdded => '連絡先が追加されました';

  @override
  String get cannotAddContact => '連絡先を追加できません';

  @override
  String get contactDeleted => '連絡先が削除されました';

  @override
  String get cannotDeleteContact => '連絡先を削除できません';

  @override
  String get shakeDetected => '振動を検知！';

  @override
  String get sendSOSNow => '緊急SOSアラートをすぐに送信しますか？\n（写真は不要）';

  @override
  String get sendSOSButton => '今すぐSOSを送信';

  @override
  String get autoWarning => '⚠️ 自動警告: デバイスから緊急振動が検出されました！';

  @override
  String sosSentSuccess(int count) {
    return '✅ SOSアラートが$count通のメールに送信されました！';
  }

  @override
  String get sosError => '❌ メール送信エラー';

  @override
  String get refresh => '更新';

  @override
  String get call => '電話';

  @override
  String get contacts => '連絡先';

  @override
  String get location => '位置';

  @override
  String get news => 'ニュース';

  @override
  String get tide => '潮汐';

  @override
  String get waterLevel => '水位';

  @override
  String get sosForm => 'SOSフォーム';

  @override
  String get home => 'ホーム';
}
