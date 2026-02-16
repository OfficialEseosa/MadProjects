import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatelessWidget {
  const CounterImageToggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _isDark = false;
  bool _isFirstImage = true;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..value = 1.0;
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() => _counter++);
    _saveCounter();
  }

  void _decrementCounter() {
    setState(() => _counter--);
    _saveCounter();
  }

  void _resetCounter() {
    setState(() => _counter = 0);
    _saveCounter();
  }

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  void _toggleImage() async {
    await _controller.reverse();
    setState(() => _isFirstImage = !_isFirstImage);
    await _controller.forward();  
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CW1 Counter & Toggle'),
          actions: [
            IconButton(
              onPressed: _toggleTheme,
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Counter: $_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text('+1'),
                  ),
                  ElevatedButton(
                    onPressed:() {
                      for (int i = 0; i < 5; i++){
                        _incrementCounter();
                      }
                    },
                    child: const Text('+5')
                  ),
                  ElevatedButton(
                    onPressed:() {
                      for (int i = 0; i < 10; i++){
                        _incrementCounter();
                      }
                    },
                    child: const Text('+10')
                  ),
                ],
              ),
              
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _counter > 0 ? _decrementCounter : null,
                    child: const Text('-1'),
                  ),
                  ElevatedButton(
                    onPressed: _counter > 0 ? _resetCounter : null,
                    child: const Text("Reset"),
                  ),
                ],
              ),

              FadeTransition(
                opacity: _fade,
                child: Image.asset(
                  _isFirstImage ? 'assets/image1.png' : 'assets/image2.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _toggleImage,
                child: const Text('Toggle Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}