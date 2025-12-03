import 'package:flutter/material.dart';
import '../database/basedatos.dart';

class NotaScreen extends StatefulWidget {
  @override
  _NotaScreenState createState() => _NotaScreenState();
}

class _NotaScreenState extends State<NotaScreen> {
  int? idMateria;
  String materia = "";
  List<Map<String, dynamic>> notas = [];

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    idMateria = args['idMateria'];
    materia = args['nombreMateria'];
    cargarNotas();
    super.didChangeDependencies();
  }

  void cargarNotas() async {
    notas = await BaseDatos.instancia.obtenerNotasPorMateria(idMateria!);
    setState(() {});
  }

  void agregarNota() {
    TextEditingController titulo = TextEditingController();
    TextEditingController valor = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Agregar Nota"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titulo, decoration: InputDecoration(labelText: "Título")),
            TextField(
              controller: valor,
              decoration: InputDecoration(labelText: "Valor"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Guardar"),
            onPressed: () async {
              if (titulo.text.isNotEmpty && valor.text.isNotEmpty) {
                await BaseDatos.instancia.insertarNota({
                  'idMateria': idMateria,
                  'titulo': titulo.text,
                  'valor': double.parse(valor.text),
                  'fecha': DateTime.now().toString(),
                });
                cargarNotas();
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notas de $materia")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: agregarNota,
      ),
      body: ListView.builder(
        itemCount: notas.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(notas[i]['titulo']),
            subtitle: Text("Nota: ${notas[i]['valor']}"),
          );
        },
      ),
    );
  }
}
