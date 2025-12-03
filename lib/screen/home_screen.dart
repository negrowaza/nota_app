import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final nombre = user['nombre'] ?? 'Usuario';
    final rol = user['rol'] ?? 'alumno';
    final foto = user['foto'] ??
        'https://i.pravatar.cc/150?img=8';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $nombre', style: TextStyle(color: AppColors.neonGreen)),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: AppColors.neonGreen),
            onPressed: () => Navigator.pushNamed(context, '/profile', arguments: user),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.black,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 36, backgroundImage: NetworkImage(foto)),
                  SizedBox(height: 8),
                  Text(nombre, style: TextStyle(color: AppColors.neonGreen, fontSize: 18)),
                  Text(rol.toUpperCase(), style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.book, color: AppColors.neonGreen),
              title: Text('Materias', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pushNamed(context, '/materias', arguments: user),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.neonGreen),
              title: Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             CircleAvatar(radius: 60, backgroundImage: NetworkImage(foto)),
             SizedBox(height: 12),
             Text(nombre, style: TextStyle(color: AppColors.neonGreen, fontSize: 22)),
             SizedBox(height: 6),
             Text(rol.toString().toUpperCase(), style: TextStyle(color: Colors.white70)),
             SizedBox(height: 18),
             if (rol == 'profesor') ElevatedButton.icon(
               style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen, foregroundColor: Colors.black),
               onPressed: () => Navigator.pushNamed(context, '/materias', arguments: user),
               icon: Icon(Icons.note_add),
               label: Text('Ingresar notas'),
             ),
             if (rol == 'alumno') ElevatedButton.icon(
               style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen, foregroundColor: Colors.black),
               onPressed: () => Navigator.pushNamed(context, '/materias', arguments: user),
               icon: Icon(Icons.assignment),
               label: Text('Ver mis materias'),
             ),
          ],
        ),
      ),
    );
  }
}
