import 'package:flutter/material.dart';
import 'dart:async';

class PomoTimer extends StatefulWidget {
  final int startSeconds;

  const PomoTimer({super.key, required this.startSeconds});

  @override
  State<PomoTimer> createState() => _PomoTimerState();
}

enum Phase {breakPhase, studyPhase}

class _PomoTimerState extends State<PomoTimer> {
  // Set variables
  late int studyTime;
  late int breakTime;
  late int currentTime;
  Phase _phase = Phase.breakPhase;
  Timer? _timer;

  @override
  void initState() {
    // Initialize study time to be the duration from last page
    // and break time to be 20% of this
    super.initState();
    studyTime = widget.startSeconds;
    breakTime = (studyTime * 0.2).toInt();
    currentTime = breakTime;
  }

  void _studyTimer() {
    // Turn off the timer
    _timer?.cancel();
    
    // Start up the timer 
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      // If the timer is finished switch from break 
      // phase to study phase or vice versa
      if (currentTime <= 0) {
        _timer?.cancel();
        setState(() {
          if (_phase == Phase.breakPhase) {
            _phase = Phase.studyPhase;
            currentTime = studyTime;
          }
          else {
            _phase = Phase.breakPhase;
            currentTime = breakTime;
          }
        });
        return;
      }

      setState(() {
        // Decrement time
        currentTime--;
      });
    });
  }  

  void _stopTimer() {
      _timer?.cancel();
  }  

  // Function to format time as 00:00:00
  String _formattedTime(int seconds) {
    final h = seconds ~/3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(h)}:${twoDigits(m)}:${twoDigits(s)}";
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = 
      // Button text depending on current phase
      _phase == Phase.breakPhase ? "Start Break" : "Start Studying";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 131, 125, 225),
        title: Center(
          child: Text(
            "Your Pomodoro", 
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30)
          )
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _phase == Phase.breakPhase ? "Break Time:" : "Study Time:",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              _formattedTime(currentTime), 
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height:40),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 171, 167, 232))),
              onPressed: _studyTimer,
              child: Text(buttonText),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 171, 167, 232))),
              onPressed: _stopTimer,
              child: Text("Stop")
            ),
          ],
        ),
      ),
    );
  }
}