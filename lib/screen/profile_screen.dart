import 'package:flutter/material.dart';
import '../database/basedatos.dart';
import '../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
  }

  void _editarNombre() async {
    final ctrl = TextEditingController(text: user!['nombre']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar nombre'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          TextButton(onPressed: () async {
            await BaseDatos.instancia.crearUsuario({
              // simplificamos: para demo no actualizamos DB completa (puedes implementar Update)
            });
            Navigator.pop(context);
          }, child: Text('Guardar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return Scaffold(body: Center(child: Text('No user', style: TextStyle(color: Colors.white))));
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CircleAvatar(radius: 60, backgroundImage: NetworkImage(user!['foto'] ?? 'https://i.pravatar.cc/150?img=15')),
            SizedBox(height: 8),
            Text(user!['nombre'], style: TextStyle(color: AppColors.neonGreen, fontSize: 20)),
            SizedBox(height: 6),
            Text(user!['email'], style: TextStyle(color: Colors.white70)),
            SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen, foregroundColor: Colors.black),
              onPressed: _editarNombre,
              child: Text('Editar perfil (demo)'),
            )
          ],
        ),
      ),
    );
  }
}
