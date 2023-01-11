import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quellenreiter_app/utilities/utilities.dart';

void main() {
  group("Testing utilities", () {
    TextEditingController controller = TextEditingController(text: "");

    test(
        "checkIfEmpty() should should return a string if controller.text is empty",
        () {
      expect(Utils.checkIfEmpty(controller), "Kann nicht leer sein");
    });

    test(
        "checkIfEmpty() should should return null if controller.text is not empty",
        () {
      controller.text = "Test";
      expect(Utils.checkIfEmpty(controller), null);
    });
  });
}
