class Nota {
  int? id;
  int idMateria;
  int idUsuario;
  String titulo;
  double valor;
  String fecha;

  Nota({this.id, required this.idMateria, required this.idUsuario, required this.titulo, required this.valor, required this.fecha});

  Map<String, dynamic> toMap() => {
    'id': id,
    'idMateria': idMateria,
    'idUsuario': idUsuario,
    'titulo': titulo,
    'valor': valor,
    'fecha': fecha,
  };

  factory Nota.fromMap(Map<String, dynamic> m) => Nota(
    id: m['id'],
    idMateria: m['idMateria'],
    idUsuario: m['idUsuario'],
    titulo: m['titulo'],
    valor: (m['valor'] as num).toDouble(),
    fecha: m['fecha'],
  );
}
