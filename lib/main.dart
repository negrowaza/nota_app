import 'package:flutter/material.dart';
import 'utils/colors.dart';
import 'screen/login_screen.dart';
import 'screen/registro_screen.dart';
import 'screen/home_screen.dart';
import 'screen/materias_screen.dart';
import 'screen/materia_detail_screen.dart';
import 'screen/nota_form_screen.dart';
import 'screen/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CitaYa - Notas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.black,
        primaryColor: AppColors.neonGreen,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.neonGreen,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.neonGreen),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/registro': (_) => RegistroScreen(),
        '/home': (_) => HomeScreen(), // requiere argumentos: usuario map
        '/materias': (_) => MateriasScreen(),
        '/materia_detail': (_) => MateriaDetailScreen(),
        '/nota_form': (_) => NotaFormScreen(),
        '/profile': (_) => ProfileScreen(),
      },
    );
  }
}
