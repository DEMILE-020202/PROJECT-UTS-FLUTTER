import 'package:flutter/material.dart';
import 'package:assigner/models/dark_mode_theme.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  ProfilePage({required this.userData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Color? avatarColor;
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
    _setAvatarColor(darkMode);
  }

  _setAvatarColor(bool darkMode) {
    setState(() {
      switch (widget.userData['profession']) {
        case 'Student':
          avatarColor = isDarkMode ? Colors.blue[900] : Colors.blue;
          break;
        case 'Teacher':
          avatarColor = isDarkMode ? Colors.green[900] : Colors.green;
          break;
        default: avatarColor = Colors.grey;
      }
    });
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
            const Text("Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 40,
              backgroundColor: avatarColor,
              child: Text(
                "${widget.userData['username'][0]}",
                style: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.white,
                    fontSize: 36
                ),
              ),
            ),
            const SizedBox(height: 64),
            Flexible(child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Username:",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text("${widget.userData['username']}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 34),
                  const Text("Email:",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text("${widget.userData['email']}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 34),
                  const Text("Role/Profession:",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text("${widget.userData['profession']}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 54),
                ],
              ),
            ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(128, 64),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const ContinuousRectangleBorder(),
                    backgroundColor: isDarkMode ? Colors.blue[900] : Colors.blueAccent,
                  ),
                  child: Text("Close",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.grey : Colors.white),
                  ),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () {
                    logoutConfirmation(context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(128, 64),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const ContinuousRectangleBorder(),
                    backgroundColor: isDarkMode ? Colors.red[900] : Colors.redAccent,
                  ),
                  child: const Text("Log Out",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void logoutConfirmation(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Log Out"),
          content: const Text("Are you sure you want to log out?",
            style: TextStyle(
                fontSize: 18,
                ),
          ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  },
                child: const Text("Cancel",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  },
                child: const Text("Log Out",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ]
        );
      }
  );
}