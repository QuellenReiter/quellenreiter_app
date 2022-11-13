import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../constants/constants.dart';

/// The AppBar (top of the App) that contains searchbar and links to impressum, datenschutz and
/// login/logout.
class ResultsAppBar extends StatefulWidget with PreferredSizeWidget {
  ResultsAppBar({
    required this.appState,
    Key? key,
  }) : super(key: key);

  /// The height of the appBar.
  final double barHeight = 150;

  final QuellenreiterAppState appState;

  @override
  State<ResultsAppBar> createState() => _ResultsAppBarState();

  /// The size of the appbar.
  @override
  Size get preferredSize => Size.fromHeight(barHeight);
}

/// State of the [ResultsAppBar].
class _ResultsAppBarState extends State<ResultsAppBar> {
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
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Text(
                          widget.appState.player!.emoji,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Positioned(
                          bottom: -10,
                          child: Text(
                            widget.appState.player!.name,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.appState.currentOpponent!.openGame!.player
                            .getPoints()
                            .toString() +
                        " : " +
                        widget.appState.currentOpponent!.openGame!.opponent
                            .getPoints()
                            .toString(),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Flexible(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Text(
                          widget.appState.currentOpponent!.opponent.emoji,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Positioned(
                          bottom: -10,
                          child: Text(
                            widget.appState.currentOpponent!.opponent.name,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
