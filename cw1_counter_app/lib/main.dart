import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatelessWidget {
  const CounterImageToggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CW1 Counter & Toggle',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
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

  // Goal meter
  int _goal = 50;
  bool _celebrated = false;

  // History & undo (stores last 5 counter values before each action)
  final List<int> _history = [];

  // Navigator key so dialogs get a context below MaterialApp
  final _navKey = GlobalKey<NavigatorState>();

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

  void _pushHistory() {
    _history.add(_counter);
    if (_history.length > 5) _history.removeAt(0);
  }

  void _incrementCounter() {
    _pushHistory();
    setState(() => _counter++);
    _checkGoal();
    _saveCounter();
  }

  void _incrementBy(int n) {
    _pushHistory();
    setState(() => _counter += n);
    _checkGoal();
    _saveCounter();
  }

  void _decrementCounter() {
    _pushHistory();
    setState(() => _counter--);
    _celebrated = false;
    _saveCounter();
  }

  void _resetCounter() {
    _pushHistory();
    setState(() => _counter = 0);
    _celebrated = false;
    _saveCounter();
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() {
      _counter = _history.removeLast();
      _celebrated = _counter >= _goal;
    });
    _saveCounter();
  }

  void _checkGoal() {
    if (_counter >= _goal && !_celebrated) {
      _celebrated = true;
      Future.microtask(() {
        if (!mounted) return;
        final ctx = _navKey.currentContext;
        if (ctx == null) return;
        showDialog(
          context: ctx,
          builder: (dialogCtx) => AlertDialog(
            title: const Text('Goal reached!'),
            content: Text('You hit your target of $_goal!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Awesome!'),
              ),
            ],
          ),
        );
      });
    }
  }

  void _setGoal() {
    final ctx = _navKey.currentContext;
    if (ctx == null) return;
    final textController = TextEditingController(text: _goal.toString());
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Set Goal'),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Target count'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(textController.text);
              if (val != null && val > 0) {
                setState(() {
                  _goal = val;
                  _celebrated = _counter >= _goal;
                });
              }
              Navigator.pop(dialogCtx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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
      navigatorKey: _navKey,
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ─── Goal progress bar ───
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Goal: $_counter / $_goal'),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: (_counter / _goal).clamp(0.0, 1.0),
                                minHeight: 12,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation(
                                  _counter >= _goal ? Colors.green : Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _setGoal,
                        icon: const Icon(Icons.flag),
                        tooltip: 'Set goal',
                      ),
                    ],
                  ),
                  if (_counter >= _goal)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Goal reached!',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),

                  const SizedBox(height: 16),

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
                        onPressed: () => _incrementBy(5),
                        child: const Text('+5'),
                      ),
                      ElevatedButton(
                        onPressed: () => _incrementBy(10),
                        child: const Text('+10'),
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
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

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

                  const SizedBox(height: 24),

                  // ─── History & Undo ───
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent history', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: _history.isNotEmpty ? _undo : null,
                        icon: const Icon(Icons.undo, size: 18),
                        label: const Text('Undo'),
                      ),
                    ],
                  ),
                  if (_history.isEmpty)
                    const Text('No actions yet.', style: TextStyle(color: Colors.grey))
                  else
                    Wrap(
                      spacing: 8,
                      children: _history
                          .reversed
                          .map((v) => Chip(label: Text('$v')))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}