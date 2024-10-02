import 'package:flutter/material.dart';

class VoiceNote extends StatefulWidget {
  const VoiceNote({super.key});

  @override
  State<VoiceNote> createState() => _VoiceNoteState();
}

class _VoiceNoteState extends State<VoiceNote> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Voice Note'),
      ),
    );
  }
}
