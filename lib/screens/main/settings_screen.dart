import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController emojiController;

  /// Initialize [emojiController] to safe the emoji.
  @override
  void initState() {
    emojiController = widget.appState.player?.emoji == null
        ? TextEditingController()
        : TextEditingController(text: widget.appState.player?.emoji);
    super.initState();
  }

  @override
  void dispose() {
    emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: emojiController,
                  decoration: const InputDecoration(
                    hintText: "Gebe ienen neuen Emoji ein.",
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.appState.player?.emoji = emojiController.text;
                    widget.appState.updateUser();
                  },
                  icon: const Icon(Icons.emoji_emotions),
                  label: const Text("Emoji auswählen"),
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => {},
            icon: const Icon(Icons.switch_access_shortcut),
            label: const Text("Namen ändern."),
          ),
          ElevatedButton.icon(
            onPressed: () => {widget.appState.logout()},
            icon: const Icon(Icons.logout),
            label: const Text("Abmelden"),
          ),
          ElevatedButton.icon(
            onPressed: () => {},
            icon: const Icon(Icons.delete_forever),
            label: const Text("Account löschen"),
          ),
        ],
      ),
    );
  }
}
