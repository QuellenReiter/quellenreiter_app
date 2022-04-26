import 'dart:typed_data';
import 'package:flutter/material.dart';
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
  static String correct = "richtig";
  static String unverified = "unbelegt";
  static String falseContext = "falscher Kontext";
  static String manipulated = "manipuliert";
  static String misleading = "irreführend";
  static String fabricatedContent = "frei erfunden";
  static String falseInformation = "Fehlinformation";
  static String satire = "Satire";
}
