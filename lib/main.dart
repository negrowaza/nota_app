import 'package:flutter/material.dart';
import 'screen/materias_screen.dart';
import 'screen/nota_screen.dart';

void main() {
  runApp(MyNotasApp());
}

class MyNotasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => MateriasScreen(),
        '/notas': (_) => NotaScreen(),
      },
    );
  }
}
