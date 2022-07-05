import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          ? () => showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                backgroundColor: Colors.transparent,
                isDismissible: true,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 20, right: 20),
                        constraints: const BoxConstraints(
                          maxWidth: 700,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.dangerous,
                              size: 100,
                              color: DesignColors.red,
                            ),
                            SelectableText(
                              "Du verlässt diese APP!",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: DesignColors.red),
                            ),
                            SelectableText(
                              msg,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(link),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        DesignColors.red),
                              ),
                              onPressed: () async {
                                if (!await launch(link)) {
                                  throw 'could not launch';
                                }
                                Navigator.of(context).pop(context);
                              },
                              child: Text(
                                "Trotzdem fortfahren.",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
          : () async {
              if (!await launch(link)) {
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
