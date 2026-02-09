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
                    style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
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
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Icon(
                        Icons.wb_sunny,
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
                        color: _themeMode == ThemeMode.dark ? Colors.yellow : Colors.grey,
                      ),
                      ],
                    ),
                    Text(
                      _themeMode == ThemeMode.dark ? "Dark Mode" : "Light Mode",
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}