import 'package:assigner/models/dark_mode_theme.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final VoidCallback onDarkMode;

  SettingPage({required this.onDarkMode});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;
  final DarkModeTheme _darkMode = DarkModeTheme();

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  _loadTheme() async {
    bool darkMode = await _darkMode.getDarkMode();
    setState(() {
      isDarkMode = darkMode;
    });
  }

  _toggleTheme(bool value) async {
    await _darkMode.setDarkMode(value);
    setState(() {
      isDarkMode = value;
    });
    widget.onDarkMode();
  }

    @override
    Widget build(BuildContext context) {
      return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 8,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.height * 0.85,
                padding: const EdgeInsets.all(18),
                color: isDarkMode ? Colors.grey[700] : Colors.white54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text("Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 32,),
                    SwitchListTile(
                      title: const Text('Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      value: isDarkMode,
                      onChanged: _toggleTheme,
                    ),
                  ],
                ),
              ),
      );
  }
}

