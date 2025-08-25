class PickingMonitorModel {
  final int recno;
  final String acao;
  final String chave;
  final String data;
  final String usuario;
  final String codUser;
  final List<PickingInitiatedModel> iniciados;

  PickingMonitorModel({
    required this.recno,
    required this.acao,
    required this.chave,
    required this.data,
    required this.usuario,
    required this.codUser,
    required this.iniciados,
  });

  factory PickingMonitorModel.fromJson(Map<String, dynamic> json) {
    return PickingMonitorModel(
      recno: json['recno'] ?? 0,
      acao: json['acao'] ?? '',
      chave: json['chave'] ?? '',
      data: json['data'] ?? '',
      usuario: json['usuario'] ?? '',
      codUser: json['codUser'] ?? '',
      iniciados: (json['iniciados'] as List<dynamic>?)
              ?.map((item) => PickingInitiatedModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recno': recno,
      'acao': acao,
      'chave': chave,
      'data': data,
      'usuario': usuario,
      'codUser': codUser,
      'iniciados': iniciados.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'PickingMonitorModel(recno: $recno, acao: $acao, chave: $chave, data: $data, usuario: $usuario, codUser: $codUser, iniciados: $iniciados)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickingMonitorModel &&
        other.recno == recno &&
        other.acao == acao &&
        other.chave == chave &&
        other.data == data &&
        other.usuario == usuario &&
        other.codUser == codUser &&
        other.iniciados == iniciados;
  }

  @override
  int get hashCode {
    return recno.hashCode ^
        acao.hashCode ^
        chave.hashCode ^
        data.hashCode ^
        usuario.hashCode ^
        codUser.hashCode ^
        iniciados.hashCode;
  }
}

class PickingInitiatedModel {
  final int recno;
  final String acao;
  final String chave;
  final String data;
  final String usuario;
  final String codUser;

  PickingInitiatedModel({
    required this.recno,
    required this.acao,
    required this.chave,
    required this.data,
    required this.usuario,
    required this.codUser,
  });

  factory PickingInitiatedModel.fromJson(Map<String, dynamic> json) {
    return PickingInitiatedModel(
      recno: json['recno'] ?? 0,
      acao: json['acao'] ?? '',
      chave: json['chave'] ?? '',
      data: json['data'] ?? '',
      usuario: json['usuario'] ?? '',
      codUser: json['codUser'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recno': recno,
      'acao': acao,
      'chave': chave,
      'data': data,
      'usuario': usuario,
      'codUser': codUser,
    };
  }

  @override
  String toString() {
    return 'PickingInitiatedModel(recno: $recno, acao: $acao, chave: $chave, data: $data, usuario: $usuario, codUser: $codUser)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickingInitiatedModel &&
        other.recno == recno &&
        other.acao == acao &&
        other.chave == chave &&
        other.data == data &&
        other.usuario == usuario &&
        other.codUser == codUser;
  }

  @override
  int get hashCode {
    return recno.hashCode ^
        acao.hashCode ^
        chave.hashCode ^
        data.hashCode ^
        usuario.hashCode ^
        codUser.hashCode;
  }
}
