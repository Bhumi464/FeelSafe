import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/report_incident_screen.dart';
import '../screens/incident_list_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/contact_screen.dart';
import '../services/fake_call_service.dart';
import '../services/sms_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool sosClicked = false;

  Future<void> _handleSosTap() async {
    setState(() {
      sosClicked = true;
    });

    await SMSService.sendSOSMessage();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          sosClicked = false;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('FeelSafe',
        style: TextStyle(
        color: Colors.black,
        fontSize: 40,
        fontWeight: FontWeight.bold
        ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings,size: 28,color: Colors.black,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onTap: _handleSosTap,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.6),
                        blurRadius: 25,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'SOS',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (sosClicked)
              const Text(
                'You have clicked SOS button',
                style: TextStyle(color: Colors.purple, fontSize: 20),
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
                );
              },
              child: const Text('Report Incident',
                style: TextStyle(fontSize: 20, color: Colors.black),),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IncidentListScreen()),
                );
              },
              child: const Text('View Incidents',
                style: TextStyle(fontSize: 20, color: Colors.black),),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactScreen()),
                );
              },
              child: const Text('Trusted Contacts',
                style: TextStyle(fontSize: 20, color: Colors.black),),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FakeCallService()),
                );
              },
              icon: const Icon(Icons.call, color: Colors.white, size: 28),
              label: const Text('Fake Call',
                style: TextStyle(fontSize: 26, color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
