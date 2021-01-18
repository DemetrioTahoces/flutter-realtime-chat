import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: Text(
        'Términos y condiciones de uso',
        style: TextStyle(fontWeight: FontWeight.w200),
      ),
    );
  }
}
