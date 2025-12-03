import 'package:flutter/material.dart';
import '../database/basedatos.dart';

class MateriasScreen extends StatefulWidget {
  @override
  _MateriasScreenState createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  List<Map<String, dynamic>> materias = [];

  @override
  void initState() {
    super.initState();
    cargarMaterias();
  }

  void cargarMaterias() async {
    materias = await BaseDatos.instancia.obtenerMaterias();
    setState(() {});
  }

  void agregarMateria() {
    TextEditingController newMateria = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Agregar Materia"),
        content: TextField(controller: newMateria),
        actions: [
          TextButton(
            child: Text("Guardar"),
            onPressed: () async {
              if (newMateria.text.isNotEmpty) {
                await BaseDatos.instancia.insertarMateria(newMateria.text);
                cargarMaterias();
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void abrirNotas(int idMateria, String nombreMateria) {
    Navigator.pushNamed(context, '/notas', arguments: {
      'idMateria': idMateria,
      'nombreMateria': nombreMateria,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Materias")),
      floatingActionButton: FloatingActionButton(
        onPressed: agregarMateria,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: materias.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(materias[i]['nombre']),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => abrirNotas(materias[i]['id'], materias[i]['nombre']),
          );
        },
      ),
    );
  }
}
