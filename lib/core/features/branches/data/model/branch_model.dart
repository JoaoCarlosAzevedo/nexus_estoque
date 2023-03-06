import 'dart:convert';

class Branch {
  String branchCode;
  String branchName;
  String groupCode;
  String groupName;
  String logo;
  Branch({
    required this.branchCode,
    required this.branchName,
    required this.groupCode,
    required this.groupName,
    required this.logo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codFilial': branchCode,
      'descFilial': branchName,
      'codGrupo': groupCode,
      'descGrupo': groupName,
      'logo': logo,
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      branchCode: map['codFilial'] as String,
      branchName: map['descFilial'] as String,
      groupCode: map['codGrupo'] as String,
      groupName: map['descGrupo'] as String,
      logo: map['logo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) =>
      Branch.fromMap(json.decode(source) as Map<String, dynamic>);
}



/* 
"codFilial": "01",
"descFilial": "MATRIZ / AM",
"codGrupo": "01",
"descGrupo": "SPM DISTRIBUIDORA",
"logo": "iVBORw0KGg

*/ 