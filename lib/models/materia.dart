class Materia {
  int? id;
  String nombre;
  Materia({this.id, required this.nombre});
  factory Materia.fromMap(Map<String, dynamic> m) => Materia(id: m['id'], nombre: m['nombre']);
}
