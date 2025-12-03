import 'package:flutter/material.dart';
import '../database/basedatos.dart';
import '../utils/colors.dart';

class MateriaDetailScreen extends StatefulWidget {
  @override
  _MateriaDetailScreenState createState() => _MateriaDetailScreenState();
}

class _MateriaDetailScreenState extends State<MateriaDetailScreen> {
  Map<String, dynamic>? materia;
  Map<String, dynamic>? user;
  List<Map<String, dynamic>> alumnosProm = [];
  List<Map<String, dynamic>> notas = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    materia = args['materia'];
    user = args['user'];
    _cargar();
  }

  void _cargar() async {
    if (user!['rol'] == 'profesor') {
      alumnosProm = await BaseDatos.instancia.obtenerAlumnosConNotasEnMateria(materia!['id']);
    } else if (user!['rol'] == 'alumno') {
      notas = await BaseDatos.instancia.obtenerNotasPorMateriaYAlumno(materia!['id'], user!['id']);
    } else {
      alumnosProm = await BaseDatos.instancia.obtenerAlumnosConNotasEnMateria(materia!['id']);
    }
    setState(() {});
  }

  void _irAgregarNotaParaAlumno(int idAlumno) {
    Navigator.pushNamed(context, '/nota_form', arguments: {'idMateria': materia!['id'], 'idAlumno': idAlumno, 'user': user}).then((_) => _cargar());
  }

  @override
  Widget build(BuildContext context) {
    final rol = user!['rol'];
    return Scaffold(
      appBar: AppBar(title: Text(materia!['nombre'])),
      floatingActionButton: rol == 'profesor'
          ? FloatingActionButton(
              onPressed: () {
                // abrir pantalla para seleccionar alumno y agregar nota
                _seleccionarAlumnoYAgregar();
              },
              child: Icon(Icons.add, color: AppColors.black),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (rol == 'alumno') ...[
              Text('Mis notas', style: TextStyle(color: AppColors.neonGreen, fontSize: 18)),
              SizedBox(height: 8),
              Expanded(
                child: notas.isEmpty
                    ? Center(child: Text('Aún no hay notas', style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                        itemCount: notas.length,
                        itemBuilder: (_, i) {
                          final n = notas[i];
                          return Card(
                            color: AppColors.black,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.neonGreen.withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(n['titulo'], style: TextStyle(color: Colors.white)),
                              subtitle: Text('Nota: ${n['valor']} - ${n['fecha']}', style: TextStyle(color: Colors.white70)),
                            ),
                          );
                        },
                      ),
              ),
            ] else ...[
              Text('Alumnos / Promedio', style: TextStyle(color: AppColors.neonGreen, fontSize: 18)),
              SizedBox(height: 8),
              Expanded(
                child: alumnosProm.isEmpty
                    ? Center(child: Text('No hay alumnos o notas', style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                        itemCount: alumnosProm.length,
                        itemBuilder: (_, i) {
                          final a = alumnosProm[i];
                          final prom = a['promedio'] == null ? 0.0 : (a['promedio'] as num).toDouble();
                          return Card(
                            color: AppColors.black,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.neonGreen.withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(backgroundImage: NetworkImage(a['foto'] ?? 'https://i.pravatar.cc/150?img=15')),
                              title: Text(a['nombre'], style: TextStyle(color: Colors.white)),
                              subtitle: Text('Promedio: ${prom.toStringAsFixed(2)}', style: TextStyle(color: Colors.white70)),
                              trailing: IconButton(
                                icon: Icon(Icons.add_circle, color: AppColors.neonGreen),
                                onPressed: () => _irAgregarNotaParaAlumno(a['id']),
                              ),
                              onTap: () {
                                // ver historial de notas del alumno en esta materia
                                Navigator.push(context, MaterialPageRoute(builder: (_) => _AlumnoNotasPage(idAlumno: a['id'], idMateria: materia!['id'])));
                              },
                            ),
                          );
                        },
                      ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _seleccionarAlumnoYAgregar() async {
    final alumnos = await BaseDatos.instancia.listarUsuariosPorRol('alumno');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Seleccionar alumno'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: alumnos.length,
            itemBuilder: (_, i) {
              final a = alumnos[i];
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(a['foto'] ?? 'https://i.pravatar.cc/150?img=15')),
                title: Text(a['nombre']),
                onTap: () {
                  Navigator.pop(context);
                  _irAgregarNotaParaAlumno(a['id']);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AlumnoNotasPage extends StatefulWidget {
  final int idAlumno;
  final int idMateria;
  _AlumnoNotasPage({required this.idAlumno, required this.idMateria});
  @override
  __AlumnoNotasPageState createState() => __AlumnoNotasPageState();
}

class __AlumnoNotasPageState extends State<_AlumnoNotasPage> {
  List<Map<String, dynamic>> notas = [];
  Map<String, dynamic>? alumno;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() async {
    notas = await BaseDatos.instancia.obtenerNotasPorMateriaYAlumno(widget.idMateria, widget.idAlumno);
    alumno = await BaseDatos.instancia.obtenerUsuarioPorId(widget.idAlumno);
    setState(() {});
  }

  void _editNota(Map<String, dynamic> nota) {
    Navigator.pushNamed(context, '/nota_form', arguments: {'nota': nota}).then((_) => _cargar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(alumno != null ? '${alumno!['nombre']}' : 'Notas'),
      ),
      body: ListView.builder(
        itemCount: notas.length,
        itemBuilder: (_, i) {
          final n = notas[i];
          return Card(
            color: AppColors.black,
            child: ListTile(
              title: Text(n['titulo'], style: TextStyle(color: Colors.white)),
              subtitle: Text('Nota: ${n['valor']} - ${n['fecha']}', style: TextStyle(color: Colors.white70)),
              trailing: IconButton(icon: Icon(Icons.edit, color: AppColors.neonGreen), onPressed: () => _editNota(n)),
            ),
          );
        },
      ),
    );
  }
}
