import 'package:flutter/material.dart';
import '../database/basedatos.dart';
import '../utils/colors.dart';

class NotaFormScreen extends StatefulWidget {
  @override
  _NotaFormScreenState createState() => _NotaFormScreenState();
}

class _NotaFormScreenState extends State<NotaFormScreen> {
  final _titulo = TextEditingController();
  final _valor = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? args;
  Map<String, dynamic>? notaExistente;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args!['nota'] != null) {
      notaExistente = args!['nota'];
      _titulo.text = notaExistente!['titulo'];
      _valor.text = notaExistente!['valor'].toString();
    } else {
      if (args != null && args!['idAlumno'] != null) {
        // preselect alumno
      }
    }
  }

  void _guardar() async {
    setState(() => _loading = true);
    if (notaExistente != null) {
      // actualizar
      final data = {
        'titulo': _titulo.text.trim(),
        'valor': double.parse(_valor.text.trim()),
        'fecha': DateTime.now().toString(),
      };
      await BaseDatos.instancia.actualizarNota(notaExistente!['id'], data);
    } else {
      // crear nueva nota: necesitamos idMateria e idAlumno
      final idMateria = args!['idMateria'];
      final idAlumno = args!['idAlumno'];
      final data = {
        'idMateria': idMateria,
        'idUsuario': idAlumno,
        'titulo': _titulo.text.trim(),
        'valor': double.parse(_valor.text.trim()),
        'fecha': DateTime.now().toString(),
      };
      await BaseDatos.instancia.insertarNota(data);
    }
    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = notaExistente != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar nota' : 'Agregar nota')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _titulo, decoration: InputDecoration(labelText: 'Título', labelStyle: TextStyle(color: AppColors.neonGreen))),
            SizedBox(height: 8),
            TextField(controller: _valor, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Valor', labelStyle: TextStyle(color: AppColors.neonGreen))),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen, foregroundColor: Colors.black),
              onPressed: _loading ? null : _guardar,
              child: _loading ? CircularProgressIndicator() : Text(isEdit ? 'Actualizar' : 'Guardar'),
            )
          ],
        ),
      ),
    );
  }
}
