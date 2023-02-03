import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  Widget build(BuildContext context) {
    if (appState.authProvider.errorHandler.error == null) {
      return const SizedBox.shrink();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50, left: 10, right: 10),
        child: Container(
          decoration: const BoxDecoration(
            color: DesignColors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(alignment: WrapAlignment.center, children: [
              Text(appState.authProvider.errorHandler.error!),
            ]),
          ),
        ),
      ),
    );
  }
}
