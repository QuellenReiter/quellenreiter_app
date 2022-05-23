import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../constants/constants.dart';
import '../../models/statement.dart';
import '../../widgets/correctness_badge.dart';
import '../../widgets/fact_display_container.dart';
import '../../widgets/link_alert.dart';
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
    if (widget.appState.safedStatements == null) {
      return const Center(
        child: Text("Keine gespeicherten Fakten oder Fakes."),
      );
    }

    return ListView.builder(
      itemCount: widget.appState.safedStatements!.statements.length,
      itemBuilder: (BuildContext context, int index) {
        return StatementCard(
          statement: widget.appState.safedStatements!.statements[index],
        );
      },
    );
  }
}
