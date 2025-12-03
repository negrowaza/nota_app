import 'package:flutter/material.dart';
import '../database/basedatos.dart';
import '../utils/colors.dart';

class MateriasScreen extends StatefulWidget {
  @override
  _MateriasScreenState createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  List<Map<String, dynamic>> materias = [];
  Map<String, dynamic>? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    cargarMaterias();
  }

  void cargarMaterias() async {
    materias = await BaseDatos.instancia.obtenerMaterias();
    setState(() {});
  }

  void crearMateria() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Crear materia'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                await BaseDatos.instancia.insertarMateria(ctrl.text.trim());
                cargarMaterias();
              }
              Navigator.pop(context);
            },
            child: Text('Guardar'),
          )
        ],
      ),
    );
  }

  void abrirMateria(Map<String, dynamic> materia) {
    Navigator.pushNamed(context, '/materia_detail', arguments: {'materia': materia, 'user': user});
  }

  @override
  Widget build(BuildContext context) {
    final rol = user?['rol'] ?? 'alumno';
    return Scaffold(
      appBar: AppBar(title: Text('Materias')),
      floatingActionButton: rol == 'admin' || rol == 'profesor'
          ? FloatingActionButton(
              onPressed: crearMateria,
              child: Icon(Icons.add, color: AppColors.black),
            )
          : null,
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: materias.length,
        itemBuilder: (_, i) {
          final m = materias[i];
          return Card(
            color: AppColors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppColors.neonGreen.withOpacity(0.6))),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.neonGreen, child: Icon(Icons.book, color: AppColors.black)),
              title: Text(m['nombre'], style: TextStyle(color: Colors.white)),
              subtitle: Text('Ver detalles', style: TextStyle(color: Colors.white70)),
              trailing: Icon(Icons.arrow_forward_ios, color: AppColors.neonGreen),
              onTap: () => abrirMateria(m),
            ),
          );
        },
      ),
    );
  }
}
