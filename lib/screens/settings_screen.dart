import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setString('selectedLanguage', selectedLanguage);
  }

  void _changeLanguage(String lang) {
    setState(() {
      selectedLanguage = lang;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() => notificationsEnabled = value);
              _saveSettings();
            },
          ),
          ListTile(
            title: const Text('Change Language'),
            subtitle: Text(selectedLanguage),
            onTap: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text('Select Language'),
                  children: [
                    for (var lang in ['English', 'Hindi', 'Kannada'])
                      SimpleDialogOption(
                        child: Text(lang),
                        onPressed: () => Navigator.pop(context, lang),
                      ),
                  ],
                ),
              );
              if (result != null) _changeLanguage(result);
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'FeelSafe',
                applicationVersion: '1.0.0',
                children: const [
                  Text('A women safety app with emergency SOS, location tracking, and more.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
