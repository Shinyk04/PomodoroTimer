import 'package:first_app/pages/pomodoro.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  // Set variables
  int timeElapsed = 0;
  bool timerRunning = false;
  Timer? _timer;
  final TextEditingController _studyController = TextEditingController();
  final TextEditingController _breakController = TextEditingController();

  // Function to format time as 00:00:00
  String get _formattedTime {
    final hours = timeElapsed ~/3600;
    final minutes = (timeElapsed % 3600) ~/ 60;
    final seconds = timeElapsed % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  // Start the timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        //Start timer
        timeElapsed++;
      });
    });
    timerRunning = true;
  }

  // Stop the timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    timerRunning = false;
  }

  // Reset the timer
  void _resetTime() {
    timeElapsed = 0;
  }

  // Enter a specified time

  @override
  void dispose() {
    _timer?.cancel();
    _studyController.dispose();
    _breakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 131, 125, 225),
        title: Center(
          child: Text(
            "Base Timer", 
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30)
          )
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Time elapsed:"),
            Text(_formattedTime, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            Row ( 
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 171, 167, 232))),
                onPressed: () {
                  setState(() {
                    timerRunning ? _stopTimer() : _startTimer();
                  });
                },
                child: Text(timerRunning ? "Stop" : "Start"),
              ),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 232, 167, 172))),
                onPressed: () {
                  setState(() {
                    _resetTime();
                  });
                },
                child: Text("Reset"),
                ),
              ],
            ),

            Column(
              children: [
                const Text("Or enter custom times (minutes):"),

                Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _studyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Study time (minutes)",
                    )
                  ),
                ),

                Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _breakController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Break time (minutes)",
                    ),
                  ),
                ),
              ],  
            ),
//          ],
//        )
            
            ElevatedButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 171, 167, 232))),
              onPressed: () {
                final int? studyMinutes = 
                  int.tryParse(_studyController.text);
                final int? breakMinutes = 
                  int.tryParse(_breakController.text);

                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => PomoTimer(
                      startSeconds: studyMinutes != null ? studyMinutes*60 : timeElapsed,
                      breakSeconds: breakMinutes != null ? breakMinutes*60 : null,
                      )
                  ),
                );
              }, 
              child: Text("Use this duration")
            ),
          ],
        ),
      ),
    );
  }
}