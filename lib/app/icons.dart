import 'package:flutter/material.dart';

/// Every icon the app draws, named by the role it plays rather than by the
/// shape it has.
///
/// A design token file like `AppSpacing` and `AppColors` next door, and it
/// exists for the same reason: the glyph for "delete" is a decision the app
/// makes once. Before this, `refresh` and `refresh_rounded` — the same idea
/// drawn twice — both shipped, because nobody writing the second one knew
/// about the first.
///
/// Two rules keep it from rotting:
///
/// 1. **`Icons.` appears nowhere else.** A widget reads `AppIcons.delete`. That
///    is what makes swapping the icon set a one-file change instead of an
///    eighty-line one.
/// 2. **Names describe the meaning, not the picture** — `delete`, not
///    `trashCan`. A name that describes the drawing survives a swap only by
///    accident, and then lies about it.
///
/// Two meanings may share a glyph today ([community] and [unitApartment], or
/// [changeRole] and [roleTenant]). They stay separate entries on purpose: they
/// are separate decisions that happen to have landed on the same drawing, and
/// the next icon set is where they part.
abstract final class AppIcons {
  // Actions.
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData copy = Icons.copy_outlined;
  static const IconData share = Icons.ios_share;
  static const IconData refresh = Icons.refresh_rounded;

  /// Trading the invite code for a new one, which invalidates the old — a
  /// different promise from [refresh], which only re-reads what is there.
  static const IconData regenerate = Icons.autorenew_rounded;

  static const IconData more = Icons.more_vert_rounded;
  static const IconData signOut = Icons.logout;
  static const IconData selected = Icons.check;
  static const IconData drag = Icons.drag_indicator_rounded;

  // Navigation and disclosure.

  /// Not `chevron_left_rounded`, whose glyph fills only about half its box and
  /// reads as undersized in an app bar; this one is the same shape drawn nearly
  /// full height.
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData forward = Icons.chevron_right_rounded;
  static const IconData expand = Icons.expand_more_rounded;

  // Form fields.
  static const IconData reveal = Icons.visibility_outlined;
  static const IconData conceal = Icons.visibility_off_outlined;
  static const IconData email = Icons.mail_outline;

  // People.
  static const IconData profile = Icons.person_outline;
  static const IconData settings = Icons.settings_outlined;
  static const IconData addPerson = Icons.person_add_alt_outlined;
  static const IconData removePerson = Icons.person_remove_outlined;
  static const IconData rejectPerson = Icons.person_off_outlined;
  static const IconData changeRole = Icons.badge_outlined;

  // What someone is to an object.
  static const IconData roleOwner = Icons.key_rounded;
  static const IconData roleFamily = Icons.people_alt_outlined;
  static const IconData roleTenant = Icons.badge_outlined;

  // Status and feedback.
  static const IconData success = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData info = Icons.info_rounded;
  static const IconData offline = Icons.cloud_off_rounded;
  static const IconData pending = Icons.hourglass_top;
  static const IconData blocked = Icons.block;
  static const IconData rejected = Icons.cancel_outlined;
  static const IconData emailSent = Icons.mark_email_unread_outlined;
  static const IconData brokenImage = Icons.broken_image_outlined;

  // Documents, by what the file turns out to be.
  static const IconData documentImage = Icons.image_outlined;
  static const IconData documentPdf = Icons.picture_as_pdf_outlined;
  static const IconData documentGeneric = Icons.description_outlined;

  // Where a document is picked from.
  static const IconData sourceFiles = Icons.folder_outlined;
  static const IconData sourceGallery = Icons.photo_library_outlined;
  static const IconData sourceCamera = Icons.photo_camera_outlined;

  // Contacts.
  static const IconData call = Icons.call_outlined;

  /// The object's own free-form facts — what it is, in its owner's words.
  static const IconData attribute = Icons.list_alt_outlined;

  // The kinds of place an object can be. Mapped from `UnitType` next to its
  // wording, so the enum stays a plain list of database values.
  static const IconData unitHouse = Icons.home_rounded;
  static const IconData unitApartment = Icons.apartment_rounded;
  static const IconData unitRoom = Icons.meeting_room_rounded;
  static const IconData unitGarage = Icons.garage_rounded;
  static const IconData unitPlot = Icons.grass_rounded;
  static const IconData unitStorage = Icons.inventory_2_outlined;
  static const IconData unitSummerKitchen = Icons.outdoor_grill_rounded;
  static const IconData unitShed = Icons.cabin_rounded;
  static const IconData unitPool = Icons.pool_rounded;
  static const IconData unitBalcony = Icons.balcony_rounded;
  static const IconData unitBathroom = Icons.shower_rounded;
  static const IconData unitOffice = Icons.business_rounded;
  static const IconData unitOther = Icons.place_rounded;

  // A community — an OSBB, a co-op — as opposed to one object inside it.
  static const IconData community = Icons.apartment_rounded;

  /// The app's own mark, drawn where there is no launcher icon to show.
  static const IconData appMark = Icons.holiday_village_outlined;
}
