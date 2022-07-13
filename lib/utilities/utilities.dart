import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

/// Static Class containing various utility functions. Can be called without
/// calling a constructor.
class Utils {
  /// Checks if the value of a given [TextEditingController] is empty. Used for
  /// the errortext on [TextField].
  static String? checkIfEmpty(TextEditingController textEditingController) {
    final text = textEditingController.text;
    if (text.isEmpty) {
      return 'Kann nicht leer sein';
    }
    // return null if the text is valid
    return null;
  }

  /// Regular expression to filter emojis.
  static final RegExp regexEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  static final RegExp regexUsername = RegExp(r'[a-zA-Z0-9_.-]');

  static const int usernameMinLength = 3;

  /// Checks if the Value of a [TextEditingController] is a number within
  /// the interval [0, 31].
  static String? checkIfDay(TextEditingController textEditingController) {
    final text = textEditingController.text != ""
        ? int.parse(textEditingController.text)
        : 0;
    if (text > 31) {
      return 'Kein valider Tag.';
    }
    // return null if the text is valid
    return null;
  }

  /// Checks if the Value of a [TextEditingController] is a number within
  /// the interval [0, 12].
  static String? checkIfMonth(TextEditingController textEditingController) {
    final text = textEditingController.text != ""
        ? int.parse(textEditingController.text)
        : 0;
    if (text > 12) {
      return 'Kein valider Monat.';
    }
    // return null if the text is valid
    return null;
  }

  /// Checks if the Value of a [TextEditingController] is a number within
  /// smaller than the current year.
  static String? checkIfYear(TextEditingController textEditingController) {
    final text = textEditingController.text != ""
        ? int.parse(textEditingController.text)
        : 0;
    if (text > DateTime.now().year) {
      return 'Keine Zeitreise bitte.';
    }
    // return null if the text is valid
    return null;
  }

  /// Checks if the Value of a [TextEditingController] is longer than
  /// [minLength].
  static String? checkIfLongerThan(
      TextEditingController textEditingController, int minLength) {
    final text = textEditingController.text;
    if (text.length < minLength) {
      return 'Mindestens ${minLength.toString()} Zeichen';
    }
    // return null if the text is valid
    return null;
  }

  /// Checks if the Value of a [TextEditingController] is empy or equal to a
  /// given string [compareString].
  static String? checkIfEmptyOrEqualTo(
      TextEditingController textEditingController, String compareString) {
    final text = textEditingController.text;
    if (text == compareString) {
      return 'Text ist unverändert';
    }
    // return null if the text is valid
    return null;
  }

  /// compress an Image [pic] and pass it to a [callback].
  static void compressImage(Uint8List pic, Function callback) async {
    img.Image tempFile = img.decodeImage(List.from(pic))!;
    tempFile = img.copyResize(
      tempFile,
      width: tempFile.height > tempFile.width ? -1 : 800,
      height: tempFile.height > tempFile.width ? 800 : -1,
    );
    // convert back to bytes
    callback(img.encodeJpg(tempFile, quality: 50));
  }
}

/// static class containing all possible values of
/// [Statement.statementCorrectness].
class CorrectnessCategory {
  static const String correct = "richtig";
  static const String unverified = "unbelegt";
  static const String falseContext = "falscher Kontext";
  static const String manipulated = "manipuliert";
  static const String misleading = "irreführend";
  static const String fabricatedContent = "frei erfunden";
  static const String falseInformation = "Fehlinformation";
  static const String satire = "Satire";
}

class UsernameTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase().characters.take(12).toString(),
      selection: newValue.selection,
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.width * 0.145)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
