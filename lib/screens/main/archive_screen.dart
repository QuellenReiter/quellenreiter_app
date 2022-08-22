import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import '../../constants/constants.dart';
import '../../widgets/statement_card.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key, required this.appState}) : super(key: key);

  final QuellenreiterAppState appState;
  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.appState.safedStatements == null ||
        widget.appState.safedStatements!.statements.isEmpty) {
      return Center(
        child: Text(
            "Hier kannst du Faktenchecks speichern, die du interessant findest",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(color: DesignColors.lightBlue)),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.appState.safedStatements!.statements.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              horizontalOffset: 20.0,
              curve: Curves.elasticOut,
              child: FadeInAnimation(
                child: StatementCard(
                  statement: widget.appState.safedStatements!.statements[index],
                  appState: widget.appState,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
