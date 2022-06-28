import 'package:flutter/material.dart';

import '../constants/constants.dart';

/// The AppBar (top of the App) that contains searchbar and links to impressum, datenschutz and
/// login/logout.
class TitleAppBar extends StatefulWidget with PreferredSizeWidget {
  TitleAppBar({Key? key, required this.title}) : super(key: key);

  /// The height of the appBar.
  final double barHeight = 150;
  final String title;
  @override
  State<TitleAppBar> createState() => _TitleAppBarState();

  /// The size of the appbar.
  @override
  Size get preferredSize => Size.fromHeight(barHeight);
}

/// State of the [TitleAppBar].
class _TitleAppBarState extends State<TitleAppBar> {
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
          clipBehavior: Clip.none,
          padding: const EdgeInsets.all(10),
          height: AppBar().preferredSize.height * 1.5,
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: Colors.white)),
              ),
              Positioned(
                left: 0,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
