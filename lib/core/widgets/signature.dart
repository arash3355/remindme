import 'package:flutter/material.dart';

class Signature extends StatelessWidget {
  const Signature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 18, bottom: 10),
      child: Text(
        '© Abdul Rahman Shalehudin - 22552011002',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Colors.black54),
      ),
    );
  }
}
