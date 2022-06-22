import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';

/// The AppBar (top of the App) that contains searchbar and links to impressum, datenschutz and
/// login/logout.
class MainAppBar extends StatefulWidget with PreferredSizeWidget {
  MainAppBar({
    Key? key,
  }) : super(key: key);

  /// The height of the appBar.
  final double barHeight = 150;

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  /// The size of the appbar.
  @override
  Size get preferredSize => Size.fromHeight(barHeight);
}

/// State of the [MainAppBar].
class _MainAppBarState extends State<MainAppBar> {
  @override
  // Build the appBar
  Widget build(BuildContext context) {
    // If mobile or narrow desktop browser. Main difference:
    // Narrow windows show a dropdown for login/impressum/datenschutz.
    return Stack(children: [
      Container(
        height: AppBar().preferredSize.height,
        color: DesignColors.backgroundBlue,
      ),
      SafeArea(
        child: Container(
          height: AppBar().preferredSize.height,
          clipBehavior: Clip.none,
          // Set background color and rounded bottom corners.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            color: DesignColors.backgroundBlue,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      SafeArea(
        child: Center(
          child: Image(
            height: 500,
            image: AssetImage('assets/logo-pink.png'),
          ),
        ),
      ),
    ]);
  }
}
