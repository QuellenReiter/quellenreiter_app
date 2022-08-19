import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';

/// The AppBar (top of the App) that contains searchbar and links to impressum, datenschutz and
/// login/logout.
class StatsAppBar extends StatefulWidget with PreferredSizeWidget {
  StatsAppBar({
    required this.appState,
    Key? key,
  }) : super(key: key);

  /// The height of the appBar.
  final double barHeight = 150;

  final QuellenreiterAppState appState;

  @override
  State<StatsAppBar> createState() => _StatsAppBarState();

  /// The size of the appbar.
  @override
  Size get preferredSize => Size.fromHeight(barHeight);
}

/// State of the [StatsAppBar].
class _StatsAppBarState extends State<StatsAppBar> {
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.appState.route == Routes.addFriends)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: BackButton(
                    color: Colors.white,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    widget.appState.player!.emoji,
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.appState.player!.name,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Stack(alignment: Alignment.center, children: [
                      SfLinearGauge(
                        minimum: widget.appState.player!
                            .getPreviousLevelXp()
                            .toDouble(),
                        maximum:
                            widget.appState.player!.getNextLevelXp().toDouble(),
                        animateAxis: true,
                        axisTrackStyle: LinearAxisTrackStyle(
                          thickness: 20,
                          edgeStyle: LinearEdgeStyle.bothCurve,
                        ),
                        animateRange: true,
                        animationDuration: 400,
                        showTicks: false,
                        showLabels: false,
                        barPointers: [
                          LinearBarPointer(
                            edgeStyle: LinearEdgeStyle.bothCurve,
                            thickness: 20,
                            value: widget.appState.player!.getXp().toDouble(),
                            color: DesignColors.pink,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.appState.player!.getLevel().toString(),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(
                              widget.appState.player!.getXp().toString() +
                                  "/" +
                                  widget.appState.player!
                                      .getNextLevelXp()
                                      .toString() +
                                  " XP",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(
                              (widget.appState.player!.getLevel() + 1)
                                  .toString(),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                      )
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    size: 40,
                    color: DesignColors.yellow,
                  ),
                  Text(
                    '${widget.appState.player!.getLevel()}',
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: DesignColors.yellow),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
