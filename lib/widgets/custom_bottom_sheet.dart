import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Static Class containing various functions to display bottom sheets. Can be called without instantiation.
class CustomBottomSheet {
  /// Shows a custom bottom sheet with a given [child] and [context].
  ///
  /// [scrollable] defines if the bottom sheet should be scrollable.
  /// [initialHeight] defines the initial height of the bottom sheet, only if [scrollable] is true.
  /// [onClose] defines a function that is called when the bottom sheet is closed.
  static void showCustomBottomSheet(
      {required Widget child,
      required BuildContext context,
      bool scrollable = false,
      double initialHeight = 0.9,
      Function? onClosed}) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      clipBehavior: Clip.none,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        if (scrollable) {
          return _makeSheetDismissable(
            context: context,
            onClosed: onClosed,
            child: DraggableScrollableSheet(
              minChildSize: 0.4,
              maxChildSize: 1,
              initialChildSize: initialHeight,
              builder: (_, controller) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                // add child
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  controller: controller,
                  children: [child],
                ),
              ),
            ),
          );
        }
        // if not scrollable
        else {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: SafeArea(
                child:
                    Padding(padding: const EdgeInsets.all(15), child: child)),
          );
        }
      },
    ).then((value) => onClosed?.call());
  }

  /// Makes a given [child] dismissable by tapping on the background.
  ///
  /// [onClosed] defines a function that is called when [child] is closed.
  static Widget _makeSheetDismissable(
      {required Widget child,
      required BuildContext context,
      Function? onClosed}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        onClosed?.call();
        Navigator.of(context).pop();
      },
      child: GestureDetector(onTap: () {}, child: child),
    );
  }
}
