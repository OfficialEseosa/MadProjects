import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  // Variable to manage the current theme mode
  ThemeMode _themeMode = ThemeMode.system;
  
  // Variable to control the container color for animation
  Color _containerColor = Colors.grey;

  // Sizing constants used inside the theme toggle card
  static const double _cardIconSize = 36.0;
  static const double _cardTitleFontSize = 20.0;
  static const double _cardStatusFontSize = 16.0;

  // Method to toggle the theme
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      // Update container color for animation
      _containerColor = themeMode == ThemeMode.dark ? Colors.white : Colors.grey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Demo',
      
      // TODO: Customize these themes further if desired
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255), // Light mode background
      ),
      darkTheme: ThemeData.dark(), // Dark mode configuration
      
      themeMode: _themeMode, // Connects the state to the app

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PART 1 TASK: Container and Text
              AnimatedContainer(
                width: 300,
                height: 200,
                margin: const EdgeInsets.all(20),
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  // Use state variable for smooth animation
                  color: _containerColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Mobile App Development Testing',
                  style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              Card(
                color: Theme.of(context).colorScheme.primary, // Use theme color with opacity
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                      'Choose Your Theme',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _cardTitleFontSize,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      ),
                    ),
                    // Icons and switch laid out horizontally for the theme picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Icon(
                        Icons.wb_sunny,
                        size: _cardIconSize,
                        color: _themeMode != ThemeMode.dark ? Colors.yellow : Colors.grey,
                      ),
                      Switch(
                        value: _themeMode == ThemeMode.dark, 
                        onChanged: (bool value) {
                        changeTheme(value ? ThemeMode.dark : ThemeMode.light);
                        },
                        ),
                      Icon(
                        Icons.nightlight_round,
                        size: _cardIconSize,
                        color: _themeMode == ThemeMode.dark ? Colors.yellow : Colors.grey,
                      ),
                      ],
                    ),
                    // Status label reflects current theme with larger text
                    Text(
                      _themeMode == ThemeMode.dark ? "Dark Mode" : "Light Mode",
                      style: TextStyle(
                        fontSize: _cardStatusFontSize,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      )
                  ],
                ),
              ),

              SizedBox(height: 30), // Spacing between card and buttons

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => changeTheme(ThemeMode.light),
                    child: const Text('Light Theme'),
                  ),
                  ElevatedButton(
                    onPressed: () => changeTheme(ThemeMode.dark),
                    child: const Text('Dark Theme'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
