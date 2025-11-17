import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @introTitle0.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ChatApp'**
  String get introTitle0;

  /// No description provided for @introSubtitle0.
  ///
  /// In en, this message translates to:
  /// **'Connect with your friends and family easily with our secure chat app'**
  String get introSubtitle0;

  /// No description provided for @introTitle1.
  ///
  /// In en, this message translates to:
  /// **'Express Yourself'**
  String get introTitle1;

  /// No description provided for @introSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Share messages, photos, and reaction  safety and instantly'**
  String get introSubtitle1;

  /// No description provided for @introTitle2.
  ///
  /// In en, this message translates to:
  /// **'Smart Messaging'**
  String get introTitle2;

  /// No description provided for @introSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Stay connected anytime with a clean and distraction-free messaging experience'**
  String get introSubtitle2;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Chat App'**
  String get appName;

  /// No description provided for @subTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect • Share • Enjoy'**
  String get subTitle;

  /// No description provided for @joinUs.
  ///
  /// In en, this message translates to:
  /// **'Join Us'**
  String get joinUs;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'SignUp'**
  String get signup;

  /// No description provided for @signUpWith.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get signUpWith;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @youHaveAlreadyAnAccount.
  ///
  /// In en, this message translates to:
  /// **'You have already an account? '**
  String get youHaveAlreadyAnAccount;

  /// No description provided for @youHaveNotAnAccount.
  ///
  /// In en, this message translates to:
  /// **'You have not an account? '**
  String get youHaveNotAnAccount;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget password?'**
  String get forgetPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'confirm password'**
  String get confirmPassword;

  /// No description provided for @pleaseEnterYour.
  ///
  /// In en, this message translates to:
  /// **'please enter your'**
  String get pleaseEnterYour;

  /// No description provided for @yourPassIsShort.
  ///
  /// In en, this message translates to:
  /// **'password less than 6 characters'**
  String get yourPassIsShort;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'invalid email'**
  String get invalidEmail;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @pleaseCheckInformation.
  ///
  /// In en, this message translates to:
  /// **'Please check your information'**
  String get pleaseCheckInformation;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get pleaseTryAgain;

  /// No description provided for @pleaseConfirmEmail.
  ///
  /// In en, this message translates to:
  /// **'We sent you a verification email. Please check your Inbox,if not found, look in Spam/Junk.'**
  String get pleaseConfirmEmail;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'We sent you a password reset. Please check your Inbox,if not found, look in Spam/Junk.'**
  String get resetPassword;

  /// No description provided for @resetPasswordFalse.
  ///
  /// In en, this message translates to:
  /// **'Please check the email address you entered and try again.'**
  String get resetPasswordFalse;

  /// No description provided for @emailExists.
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get emailExists;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'chats'**
  String get chats;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'calls'**
  String get calls;

  /// No description provided for @invitations.
  ///
  /// In en, this message translates to:
  /// **'invitations'**
  String get invitations;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'setting'**
  String get setting;

  /// No description provided for @myFriends.
  ///
  /// In en, this message translates to:
  /// **'My friends'**
  String get myFriends;

  /// No description provided for @chatBox.
  ///
  /// In en, this message translates to:
  /// **'Chat Box'**
  String get chatBox;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'users'**
  String get users;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'sent'**
  String get sent;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'received'**
  String get received;

  /// No description provided for @noChats.
  ///
  /// In en, this message translates to:
  /// **'No Chats'**
  String get noChats;

  /// No description provided for @writeSomethingHere.
  ///
  /// In en, this message translates to:
  /// **'Write something here...'**
  String get writeSomethingHere;

  /// No description provided for @makeItFriendAndSayHi.
  ///
  /// In en, this message translates to:
  /// **'Make it friend and say hi 👋 '**
  String get makeItFriendAndSayHi;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message(s)?'**
  String get deleteMessage;

  /// No description provided for @areYouSureDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete selected message(s)?'**
  String get areYouSureDeleteMessage;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'last Seen'**
  String get lastSeen;

  /// No description provided for @editValue.
  ///
  /// In en, this message translates to:
  /// **'Edit Value'**
  String get editValue;

  /// No description provided for @enterNewValue.
  ///
  /// In en, this message translates to:
  /// **'Enter new value'**
  String get enterNewValue;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @joiningDate.
  ///
  /// In en, this message translates to:
  /// **'Joining date'**
  String get joiningDate;

  /// No description provided for @failedToLoadUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load users'**
  String get failedToLoadUsers;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @noReceivedInviteFound.
  ///
  /// In en, this message translates to:
  /// **'No received invitation found'**
  String get noReceivedInviteFound;

  /// No description provided for @noSentInviteFound.
  ///
  /// In en, this message translates to:
  /// **'No sent invitation found'**
  String get noSentInviteFound;

  /// No description provided for @noRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'No recent searches'**
  String get noRecentSearches;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'clear all'**
  String get clearAll;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @ignore.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get ignore;

  /// No description provided for @cancelFriend.
  ///
  /// In en, this message translates to:
  /// **'Cancel friend'**
  String get cancelFriend;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @chatWithYouFriend.
  ///
  /// In en, this message translates to:
  /// **'chat with you friend'**
  String get chatWithYouFriend;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends '**
  String get friends;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About me'**
  String get aboutMe;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

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

  /// No description provided for @allTheUsers.
  ///
  /// In en, this message translates to:
  /// **'all the users'**
  String get allTheUsers;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @twoFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuthentication;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @leaveApp.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave the app?'**
  String get leaveApp;

  /// No description provided for @deleteAccountAlert.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountAlert;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get ok;

  /// No description provided for @successfullyUpdatePhoto.
  ///
  /// In en, this message translates to:
  /// **'successfully update your photo'**
  String get successfullyUpdatePhoto;

  /// No description provided for @successfullyLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'successfully logged out'**
  String get successfullyLoggedOut;

  /// No description provided for @successDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'successfully delete account'**
  String get successDeleteAccount;

  /// No description provided for @pleaseCheckYourNet.
  ///
  /// In en, this message translates to:
  /// **'Please check your network!'**
  String get pleaseCheckYourNet;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
