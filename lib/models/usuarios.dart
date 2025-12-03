class Usuario {
  int? id;
  String nombre;
  String email;
  String password;
  String rol;
  String? foto;

  Usuario({this.id, required this.nombre, required this.email, required this.password, required this.rol, this.foto});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'password': password,
      'rol': rol,
      'foto': foto,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> m) => Usuario(
    id: m['id'],
    nombre: m['nombre'],
    email: m['email'],
    password: m['password'],
    rol: m['rol'],
    foto: m['foto'],
  );
}
  