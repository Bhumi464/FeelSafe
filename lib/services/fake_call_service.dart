// fake_call_service.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FakeCallService extends StatefulWidget {
  @override
  _FakeCallServiceState createState() => _FakeCallServiceState();
}

class _FakeCallServiceState extends State<FakeCallService> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playRingtone();
  }

  Future<void> _playRingtone() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('fake_ringtone.mp3'));
  }

  void _stopRingtone() {
    _audioPlayer.stop();
  }

  @override
  void dispose() {
    _stopRingtone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Incoming Call...', style: TextStyle(color: Colors.white70, fontSize: 22)),
            const SizedBox(height: 20),
            const CircleAvatar(radius: 50, backgroundImage: AssetImage('fake_caller.png')),
            const SizedBox(height: 12),
            const Text('Unknown Caller', style: TextStyle(color: Colors.white, fontSize: 28)),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _callButton(Icons.call_end, Colors.red, () {
                  _stopRingtone();
                  Navigator.pop(context);
                }),
                _callButton(Icons.call, Colors.green, () {
                  _stopRingtone();
                  Navigator.pop(context);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _callButton(IconData icon, Color color, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 30,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
