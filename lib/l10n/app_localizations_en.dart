// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dvir';

  @override
  String get scopesTitle => 'My places';

  @override
  String scopePapers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '$count document',
    );
    return '$_temp0';
  }

  @override
  String scopeFacts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count facts',
      one: '$count fact',
    );
    return '$_temp0';
  }

  @override
  String scopeInside(int count) {
    return '$count inside';
  }

  @override
  String get scopesCommunities => 'Communities';

  @override
  String get scopesUnits => 'Homes';

  @override
  String get scopePending => 'Waiting for approval';

  @override
  String get addScope => 'Add';

  @override
  String get memberStatusPending => 'Waiting for approval';

  @override
  String get memberStatusActive => 'Active';

  @override
  String get memberStatusRejected => 'Turned down';

  @override
  String get memberStatusBlocked => 'Access closed';

  @override
  String get profileTitle => 'Profile';

  @override
  String get navObjects => 'Places';

  @override
  String get profileHint =>
      'People in your homes see this name. Without it you are just “Resident” to them.';

  @override
  String get profileName => 'Name';

  @override
  String get profileNameHint => 'Maria Levchenko';

  @override
  String get profileNameRequired => 'Enter a name';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profilePhoneHint => '+380 67 123 45 67';

  @override
  String get profilePhoneInvalid => 'That doesn’t look like a number';

  @override
  String get profileSaved => 'Saved';

  @override
  String get settingsTitle => 'Settings';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsStoredHere => 'Everything is kept on this phone';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageUk => 'Українська';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String settingsUnitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places',
      one: '$count place',
    );
    return '$_temp0';
  }

  @override
  String settingsSizeKilobytes(String size) {
    return '$size KB';
  }

  @override
  String settingsSizeMegabytes(String size) {
    return '$size MB';
  }

  @override
  String get backupCreate => 'Make a copy';

  @override
  String get backupCreateHint =>
      'Every record, document and contact in one archive. Keep it in the cloud or on a computer, and a lost phone will not take the home with it.';

  @override
  String get backupRestore => 'Restore from a copy';

  @override
  String get backupRestoreHint =>
      'Takes an archive and replaces everything now in the app with it.';

  @override
  String get backupRestoreConfirmTitle => 'Restore from the copy?';

  @override
  String backupRestoreConfirmBody(
    String date,
    int units,
    int documents,
    int contacts,
  ) {
    return 'Copy from $date.\nPlaces: $units\nDocuments: $documents\nContacts: $contacts\n\nEverything now in the app will be replaced with what is in the copy.';
  }

  @override
  String get backupRestoreConfirmCta => 'Restore';

  @override
  String get backupRestored => 'Restored from the copy';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get signOut => 'Sign out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm the password';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create an account';

  @override
  String get dontHaveAccount => 'No account yet? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get invalidEmail => 'Check the address';

  @override
  String get passwordRequired => 'Enter a password';

  @override
  String get passwordTooShort => 'At least 6 characters';

  @override
  String get passwordsDontMatch => 'The passwords do not match';

  @override
  String get confirmEmailTitle => 'Check your email';

  @override
  String confirmEmailBody(String email) {
    return 'We have sent a letter to $email. Open the link in it to finish signing up.';
  }

  @override
  String get backToSignIn => 'Back to signing in';

  @override
  String get onboardingTitle => 'Where do we start?';

  @override
  String get onboardingCreateCommunity => 'Create a community';

  @override
  String get onboardingCreateUnit => 'Create a home';

  @override
  String get onboardingJoinByCode => 'Join with a code';

  @override
  String get pendingApprovalTitle => 'The request is sent';

  @override
  String get pendingApprovalBody =>
      'Wait for approval. We will open access as soon as the request has been looked at.';

  @override
  String get rejectedTitle => 'The request was turned down';

  @override
  String get rejectedBody =>
      'Your request to join was turned down. Try asking whoever invited you for the code again.';

  @override
  String get blockedTitle => 'Access closed';

  @override
  String get blockedBody => 'The owner of the home has closed your access.';

  @override
  String get refreshCta => 'Refresh';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get withdrawRequest => 'Withdraw the request';

  @override
  String get withdrawRequestTitle => 'Withdraw the request?';

  @override
  String get withdrawRequestBody =>
      'You will be able to send it again with the same code.';

  @override
  String get pendingOtherWays => 'Create your own home or enter another code';

  @override
  String get joinByCodeIntro =>
      'Enter the invite code you were sent to join a community or a home.';

  @override
  String get joinCodeHint => 'A3F9C1B2';

  @override
  String get joinCodeRequired => 'Enter the invite code';

  @override
  String get joinCta => 'Join';

  @override
  String get communityName => 'Community name';

  @override
  String get communityNameHint => 'Kashtan HOA';

  @override
  String get communityNameRequired => 'Enter the community name';

  @override
  String get communityType => 'Community type';

  @override
  String get communityAddress => 'Address';

  @override
  String get communityAddressHint => '1 Khreshchatyk St';

  @override
  String get communityCity => 'City';

  @override
  String get communityCityHint => 'Kyiv';

  @override
  String get optional => 'optional';

  @override
  String fieldTooLong(int max) {
    return '$max characters at most';
  }

  @override
  String get createCommunityCta => 'Create a community';

  @override
  String get communityTypeOsbb => 'Homeowners’ association';

  @override
  String get communityTypeResidentialComplex => 'Residential complex';

  @override
  String get communityTypeDachaCooperative => 'Dacha cooperative';

  @override
  String get communityTypeGarageCooperative => 'Garage cooperative';

  @override
  String get communityTypeCottageTown => 'Cottage village';

  @override
  String get communityTypeDormitory => 'Dormitory';

  @override
  String get communityTypeCustom => 'Other';

  @override
  String get unitCreateTitle => 'New home';

  @override
  String get unitName => 'Name';

  @override
  String get unitNameHint => 'House 223';

  @override
  String get unitNameRequired => 'Name the home';

  @override
  String get unitType => 'Type';

  @override
  String unitTypeMore(String count) {
    return '$count more…';
  }

  @override
  String get createUnitCta => 'Create';

  @override
  String get unitTypeHouse => 'House';

  @override
  String get unitTypeApartment => 'Apartment';

  @override
  String get unitTypeRoom => 'Room';

  @override
  String get unitTypeGarage => 'Garage';

  @override
  String get unitTypePlot => 'Plot';

  @override
  String get unitTypeBasement => 'Basement';

  @override
  String get unitTypeSummerKitchen => 'Summer kitchen';

  @override
  String get unitTypeSummerHouse => 'Summer house';

  @override
  String get unitTypeShed => 'Shed';

  @override
  String get unitTypePool => 'Pool';

  @override
  String get unitTypeBalcony => 'Balcony';

  @override
  String get unitTypeLoggia => 'Loggia';

  @override
  String get unitTypeBathroom => 'Bathroom';

  @override
  String get unitTypeCorridor => 'Corridor';

  @override
  String get unitTypeStoreroom => 'Storeroom';

  @override
  String get unitTypeOffice => 'Office';

  @override
  String get unitTypeCustom => 'Other';

  @override
  String get unitTypeGroupMain => 'Stands at an address';

  @override
  String get unitTypeGroupRooms => 'Inside';

  @override
  String get unitTypeGroupBuildings => 'Separate buildings';

  @override
  String get unitTypeGroupOther => 'Odds and ends';

  @override
  String get unitRoleOwner => 'Owner';

  @override
  String get unitRoleFamily => 'Family';

  @override
  String get unitRoleTenant => 'Tenant';

  @override
  String get unitPeople => 'People';

  @override
  String get unitPeopleEmpty =>
      'Family, a tenant, somebody with keys. The people who need this home too.';

  @override
  String get giveAccess => 'Give access';

  @override
  String get unnamedMember => 'Resident';

  @override
  String unnamedMemberNumbered(int number) {
    return 'Resident $number';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get moreActions => 'More';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Turn down';

  @override
  String get changeRole => 'Change the role';

  @override
  String get removeMember => 'Remove';

  @override
  String get rejectTitle => 'Turn the request down?';

  @override
  String rejectBody(String name) {
    return '$name will not get access to this home. The request can be sent again.';
  }

  @override
  String get removeMemberTitle => 'Remove the resident?';

  @override
  String removeMemberBody(String name) {
    return '$name will lose access to this home and to everything that belongs to it.';
  }

  @override
  String get roleSheetTitle => 'Role in the home';

  @override
  String get rotateCode => 'Refresh the code';

  @override
  String get codeRotated => 'The code is refreshed';

  @override
  String get rotateCodeTitle => 'Refresh the code?';

  @override
  String get rotateCodeBody =>
      'The old code will stop working. Anybody not added yet will need the new one.';

  @override
  String get unitAddNotAllowed => 'Nothing can be added in here';

  @override
  String get deleteUnit => 'Delete';

  @override
  String deleteUnitTitle(String label) {
    return 'Delete “$label”?';
  }

  @override
  String get deleteUnitBody =>
      'Everything inside it goes, and everybody in it. This cannot be undone.';

  @override
  String get unitAttributes => 'Worth knowing';

  @override
  String get unitAttributesEdit => 'Change';

  @override
  String get unitAttributesEmpty =>
      'Storeys, the year it was built, what the walls are made of. Write down what is worth remembering about this home.';

  @override
  String unitAttributesShowAll(int count) {
    return 'Show all $count';
  }

  @override
  String get unitAttributeAddTitle => 'New fact';

  @override
  String get unitAttributeEditTitle => 'Fact';

  @override
  String get unitAttributeName => 'Name';

  @override
  String get unitAttributeNameHint => 'Meter number';

  @override
  String get unitFactYearBuilt => 'Year built';

  @override
  String get unitFactArea => 'Area';

  @override
  String get unitFactFloors => 'Storeys';

  @override
  String get unitFactWalls => 'Walls';

  @override
  String get unitFactHeating => 'Heating';

  @override
  String get unitAttributeNameRequired => 'Give it a name';

  @override
  String get unitAttributeValue => 'Value';

  @override
  String get unitAttributeValueHint => '09143281';

  @override
  String get unitAttributeValueRequired => 'Give it a value';

  @override
  String get editAttribute => 'Edit';

  @override
  String get deleteAttribute => 'Delete';

  @override
  String get deleteAttributeTitle => 'Delete the fact?';

  @override
  String deleteAttributeBody(String name) {
    return '“$name” will go from what this home says about itself.';
  }

  @override
  String get documents => 'Documents';

  @override
  String get allDocumentsEmpty =>
      'Documents from all your places gather here. The first one is added on a place’s own screen.';

  @override
  String get documentsEmpty =>
      'The deed, contracts, warranties. This is where the documents that prove what is written above are kept.';

  @override
  String documentsShowAll(int count) {
    return 'Show all $count';
  }

  @override
  String get documentSourceTitle => 'Add a document';

  @override
  String get documentSourceCamera => 'Take a photo';

  @override
  String get documentSourceCameraHint => 'The document is in front of me';

  @override
  String get documentSourceGallery => 'From the gallery';

  @override
  String get documentSourceGalleryHint => 'Photographed already';

  @override
  String get documentSourceFile => 'File';

  @override
  String get documentSourceFileHint => 'A PDF on the phone';

  @override
  String get documentAddTitle => 'New document';

  @override
  String get documentEditTitle => 'Document name';

  @override
  String get documentName => 'Name';

  @override
  String get documentNameHint => 'Deed';

  @override
  String get documentNameRequired => 'Give it a name';

  @override
  String documentSizeKb(String size) {
    return '$size KB';
  }

  @override
  String documentSizeMb(String size) {
    return '$size MB';
  }

  @override
  String documentAddedOn(String date) {
    return 'Added $date';
  }

  @override
  String documentMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'January',
      '2': 'February',
      '3': 'March',
      '4': 'April',
      '5': 'May',
      '6': 'June',
      '7': 'July',
      '8': 'August',
      '9': 'September',
      '10': 'October',
      '11': 'November',
      '12': 'December',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String documentMonthOfYear(String month, String year) {
    return '$month $year';
  }

  @override
  String get editDocument => 'Rename';

  @override
  String get deleteDocument => 'Delete';

  @override
  String get deleteDocumentTitle => 'Delete the document?';

  @override
  String deleteDocumentBody(String title) {
    return '“$title” goes along with the file. This cannot be undone.';
  }

  @override
  String get contacts => 'Who to call';

  @override
  String get allContactsEmpty =>
      'Numbers from all your places gather here. The first one is added on a place’s own screen.';

  @override
  String get contactsEmpty =>
      'Your own electrician, a plumber, the gas emergency line. The numbers people look for when there is no time left to look.';

  @override
  String contactsShowAll(int count) {
    return 'Show all $count';
  }

  @override
  String get contactAddTitle => 'New contact';

  @override
  String get contactEditTitle => 'Contact';

  @override
  String get contactName => 'Name';

  @override
  String get contactNameHint => 'Serhii';

  @override
  String get contactNameRequired => 'Give a name';

  @override
  String get contactRole => 'Who it is';

  @override
  String get contactRoleHint => 'Electrician';

  @override
  String get contactPhone => 'Phone';

  @override
  String get contactPhoneHint => '+38 067 123 45 67';

  @override
  String get contactPhoneRequired => 'Give a number';

  @override
  String get contactPhoneInvalid => 'That doesn’t look like a number';

  @override
  String get contactCallFailed => 'The dialler would not open';

  @override
  String get editContact => 'Change';

  @override
  String get deleteContact => 'Delete';

  @override
  String get deleteContactTitle => 'Delete the contact?';

  @override
  String deleteContactBody(String name) {
    return '“$name” will go from this home’s list.';
  }

  @override
  String get unitNested => 'Inside';

  @override
  String get unitNestedEmpty =>
      'A room, a garage, a summer kitchen, a plot. Add what you keep track of on its own.';

  @override
  String get unitStartLead =>
      'There is no need to write everything down at once. Start with what you will have to look for first.';

  @override
  String unitStartFacts(String type) {
    return 'Write down what sort of $type this is';
  }

  @override
  String get unitStartFactsWhy => 'The things worth remembering';

  @override
  String get unitStartDocument => 'Add the deed';

  @override
  String get unitStartDocumentNested => 'Add a document';

  @override
  String get unitStartDocumentWhy =>
      'A document that proves what is written above';

  @override
  String get unitStartContact => 'Add a phone number';

  @override
  String get unitStartContactWhy =>
      'The number people look for when there is no time left to look';

  @override
  String get unitStartAlso => 'Also:';

  @override
  String get unitStartAlsoNested => 'a place inside';

  @override
  String get unitAddTitle => 'New place';

  @override
  String get unitAddCta => 'Add';

  @override
  String get unitEditTitle => 'Edit';

  @override
  String get saveCta => 'Save';

  @override
  String unitHeadInside(String type, String parent) {
    return '$type · inside: $parent';
  }

  @override
  String scopeNested(String items) {
    return 'Inside: $items';
  }

  @override
  String scopeNestedMore(int count) {
    return '+$count';
  }

  @override
  String get communityCreatedTitle => 'The community is created';

  @override
  String get unitCreatedTitle => 'The home is created';

  @override
  String get inviteCodeLabel => 'Invite code';

  @override
  String get inviteCodeHint =>
      'Share this code with the residents, and they will join the community with it.';

  @override
  String get unitInviteCodeHint =>
      'Share this code with your family, and they will join the home with it.';

  @override
  String get shareCode => 'Share';

  @override
  String shareInviteText(String name, String code) {
    return 'Join “$name” in the Dvir app. Invite code: $code';
  }

  @override
  String get copyCode => 'Copy the code';

  @override
  String get codeCopied => 'The code is copied';

  @override
  String get goToHome => 'To the home screen';

  @override
  String get errorNetwork => 'No internet connection';

  @override
  String get errorServer => 'Server error. Try again later';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorUnknown => 'Unexpected error';

  @override
  String get errorInvalidCredentials => 'Wrong email or password';

  @override
  String get errorEmailAlreadyRegistered => 'This email is registered already';

  @override
  String get errorEmailAddressInvalid => 'Give a real email address';

  @override
  String get errorSignUpDisabled => 'Signing up is turned off for now';

  @override
  String get errorWeakPassword => 'The password is too simple';

  @override
  String get errorEmailNotConfirmed => 'Confirm your email first';

  @override
  String get errorTooManyRequests => 'Too many attempts. Try again later';

  @override
  String get errorAuthUnknown => 'The action did not go through';

  @override
  String get errorInvalidInviteCode => 'There is no such code. Check it again';

  @override
  String get errorNotAllowed => 'Not enough rights for this action';

  @override
  String get errorNotAuthenticated => 'The session has ended. Sign in again';

  @override
  String get errorLastAdmin =>
      'This is the last person in charge. Appoint somebody else first';

  @override
  String get errorSelfModeration => 'You cannot change your own status';

  @override
  String get errorScopeUnknown => 'The action did not go through';

  @override
  String get errorFileTooLarge => 'The file is too big. 20 MB at most';

  @override
  String get errorFileTypeNotAllowed => 'This kind of file is not supported';

  @override
  String get errorFileMissing =>
      'The file is not there. It may have been deleted already';

  @override
  String get errorFileUnknown => 'The file could not be handled';

  @override
  String get errorFileCannotOpen => 'There is no app here that opens this file';

  @override
  String get errorNotABackup => 'This does not look like a backup copy';

  @override
  String get errorBackupFromNewerApp =>
      'The copy was made by a newer version of the app. Update it first';

  @override
  String get errorBackupCannotWrite =>
      'The copy could not be made. The device may be out of space';

  @override
  String get errorBackupCannotRead => 'This file could not be read';

  @override
  String get errorRestoreFailed =>
      'Restoring from the copy failed. Nothing was changed';

  @override
  String get errorRestoreFilesIncomplete =>
      'The records are back, but not all the files. Try restoring from the same copy again';

  @override
  String get errorBackupUnknown => 'Something went wrong with the backup copy';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get retry => 'Try again';
}
