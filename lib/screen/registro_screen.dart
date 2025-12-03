import 'package:flutter/material.dart';
import '../database/basedatos.dart';
import '../utils/colors.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}
class _RegistroScreenState extends State<RegistroScreen> {
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String rol = 'alumno';
  String? _error;
  bool _loading = false;
  final _fotoController = TextEditingController(text: 'https://i.pravatar.cc/150?img=15');

  void _registrar() async {
    setState(() { _loading = true; _error = null; });
    final existing = await BaseDatos.instancia.obtenerUsuarioPorEmail(_email.text.trim());
    if (existing != null) {
      setState(() { _error = 'El email ya está registrado'; _loading = false; });
      return;
    }
    final data = {
      'nombre': _nombre.text.trim(),
      'email': _email.text.trim(),
      'password': _password.text.trim(),
      'rol': rol,
      'foto': _fotoController.text.trim(),
    };
    await BaseDatos.instancia.crearUsuario(data);
    setState(() { _loading = false; });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: _nombre, decoration: InputDecoration(labelText: 'Nombre', labelStyle: TextStyle(color: AppColors.neonGreen))),
            SizedBox(height: 8),
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: AppColors.neonGreen))),
            SizedBox(height: 8),
            TextField(controller: _password, obscureText: true, decoration: InputDecoration(labelText: 'Contraseña', labelStyle: TextStyle(color: AppColors.neonGreen))),
            SizedBox(height: 8),
            TextField(controller: _fotoController, decoration: InputDecoration(labelText: 'URL foto (opcional)', labelStyle: TextStyle(color: AppColors.neonGreen))),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: rol,
              dropdownColor: AppColors.black,
              items: [
                DropdownMenuItem(value: 'alumno', child: Text('Alumno')),
                DropdownMenuItem(value: 'profesor', child: Text('Profesor')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (v) => setState(() => rol = v!),
              decoration: InputDecoration(labelText: 'Rol', labelStyle: TextStyle(color: AppColors.neonGreen)),
            ),
            SizedBox(height: 12),
            if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen, foregroundColor: Colors.black),
              onPressed: _loading ? null : _registrar,
              child: _loading ? CircularProgressIndicator() : Text('Registrar'),
            )
          ],
        ),
      ),
    );
  }
}
