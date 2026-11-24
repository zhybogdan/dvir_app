import 'dart:io';

import 'package:dvir/core/logging/app_logger.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_file_picker.g.dart';

/// Choosing a copy to restore from (Base).
///
/// Its own data source rather than two lines in a controller, for the reason
/// `DocumentPicker` is one: it talks to a platform plugin, and what it hands
/// back has to be faked to test anything that uses it.
abstract interface class BackupFilePicker {
  /// Null when the person backed out, or when the picker would not open.
  Future<File?> pick();
}

class BackupFilePickerImpl implements BackupFilePicker {
  const BackupFilePickerImpl();

  @override
  Future<File?> pick() async {
    // Narrower than the real answer: a copy is a zip, and naming the extension
    // is what keeps the picker from offering every file on the phone. Android
    // sometimes resolves a group by mime type instead of by extension, so both
    // are given.
    const group = XTypeGroup(
      label: 'backup',
      extensions: ['zip'],
      mimeTypes: ['application/zip'],
    );

    try {
      final file = await openFile(acceptedTypeGroups: const [group]);
      if (file == null) return null;

      // The path and not the bytes: a copy of a full phone is hundreds of
      // megabytes, and both reading the manifest and unpacking the archive work
      // from the file on disk.
      return File(file.path);
    } on PlatformException catch (error) {
      // A picker that will not open has already said so in the system's own
      // words — repeating it would be the second dialog about one refusal.
      appLogger.d('The backup picker refused to open: ${error.code}');

      return null;
    }
  }
}

@Riverpod(keepAlive: true)
BackupFilePicker backupFilePicker(Ref ref) => const BackupFilePickerImpl();
