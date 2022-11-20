import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/widgets/custom_bottom_sheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/constants.dart';

class LinkAlert extends StatelessWidget {
  const LinkAlert({
    Key? key,
    required this.link,
    required this.msg,
    this.label = "",
    this.color,
  }) : super(key: key);
  final String link;
  final String msg;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: msg != ""
          ? () => CustomBottomSheet.showCustomBottomSheet(
                context: context,
                scrollable: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 100,
                      color: DesignColors.backgroundBlue,
                    ),
                    SelectableText(
                      "Du öffnest einen archivierten Link",
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: DesignColors.pink),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SelectableText(
                      msg,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(link),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(DesignColors.pink),
                      ),
                      onPressed: () async {
                        if (!await launchUrlString(link)) {
                          throw 'could not launch';
                        }
                        Navigator.of(context).pop(context);
                      },
                      child: Text(
                        "öffnen",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              )
          : () async {
              HapticFeedback.mediumImpact();
              if (!await launchUrlString(link)) {
                throw 'could not launch';
              }
            },
      style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(0),
          ),
          alignment: Alignment.centerLeft),
      label: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: color ?? DesignColors.lightGrey),
      ),
      icon: Icon(
        Icons.link_rounded,
        size: Theme.of(context).textTheme.subtitle2!.fontSize! + 5,
        color: color ?? DesignColors.lightGrey,
      ),
    );
  }
}
