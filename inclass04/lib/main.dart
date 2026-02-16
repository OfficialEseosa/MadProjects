import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Stateful Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget that will be started on the application startup
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}


class _CounterWidgetState extends State<CounterWidget> {
//initial couter value
  int _counter = 0;
  int _goal = 80;
  int _max = 100;
  bool _celebrated = false;
  bool _maxCelebrated = false;
  TextEditingController _controller = TextEditingController();

    void _checkGoal(BuildContext context) {
    if (_counter >= _max && !_maxCelebrated) {
      _maxCelebrated = true;
      Future.microtask(() {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            title: const Text('Maximum Reached!'),
            content: Text('You hit the absolute max of $_max! Amazing!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Incredible!'),
              ),
            ],
          ),
        );
      });
    } else if (_counter >= _goal && !_celebrated) {
      _celebrated = true;
      Future.microtask(() {
        if (!mounted) return;
        showDialog(
          context: context,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.blue,
              child: Text(
                //displays the current number
                '$_counter',
                style: TextStyle(fontSize: 50.0),
              ),
            ),
          ),
          Slider(
            min: 0,
            max: _max.toDouble(),
            value: _counter.toDouble().clamp(0, _max.toDouble()),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt().clamp(0, _max);
                _checkGoal(context);
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _counter > 0
                ? () {
                  setState(() {
                    _counter--;
                  });
                } : null,
                child: Text("Decrement"),
              ),
              ElevatedButton(
                onPressed: _counter > 0
                ? () {
                  setState(() {
                    _counter = 0;
                  });
                } : null,
                child: Text("Reset")
                ),
            ],
          ),

          SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: "Custom increment: ",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: (){
                  setState(() {
                    int increment = _controller.text.isNotEmpty ? int.parse(_controller.text) : 0;
                    _counter = (_counter + increment).clamp(0, _max);
                    _checkGoal(context);
                  });
                }, 
                child: Text("Increment"),
                ),
            ],
          ),

        ],
      ),
    );
  }
}
