import 'package:flutter/material.dart';
import '../database/basedatos.dart';
import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  void _login() async {
    setState(() { _loading = true; _error = null; });
    final user = await BaseDatos.instancia.obtenerUsuarioPorEmail(_email.text.trim());
    await Future.delayed(Duration(milliseconds: 300));
    if (user == null) {
      setState(() { _error = 'Usuario no encontrado'; _loading = false; });
      return;
    }
    if (user['password'] != _password.text.trim()) {
      setState(() { _error = 'Contraseña incorrecta'; _loading = false; });
      return;
    }
    setState(() { _loading = false; });
    Navigator.pushReplacementNamed(context, '/home', arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            SizedBox(height: 12),
            CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=7'),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 18),
            TextField(
              controller: _email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: AppColors.neonGreen),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.neonGreen)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.neonGreen)),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: AppColors.neonGreen),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.neonGreen)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.neonGreen)),
              ),
            ),
            SizedBox(height: 12),
            if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen, foregroundColor: Colors.black),
              onPressed: _loading ? null : _login,
              child: _loading ? CircularProgressIndicator() : Text('Ingresar'),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/registro'),
              child: Text('Crear cuenta', style: TextStyle(color: AppColors.neonGreen)),
            )
          ],
        ),
      ),
    );
  }
}
