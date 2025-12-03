class Nota {
  int? id;
  int idMateria;
  String titulo;
  double valor;
  String fecha;

  Nota({
    this.id,
    required this.idMateria,
    required this.titulo,
    required this.valor,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idMateria': idMateria,
      'titulo': titulo,
      'valor': valor,
      'fecha': fecha,
    };
  }

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'],
      idMateria: map['idMateria'],
      titulo: map['titulo'],
      valor: map['valor'],
      fecha: map['fecha'],
    );
  }
}
