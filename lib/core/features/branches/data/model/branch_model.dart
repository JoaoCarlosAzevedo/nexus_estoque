import 'dart:convert';

class Branch {
  String branchCode;
  String branchName;
  String groupCode;
  String groupName;
  String logo;
  bool isSelected;
  Branch({
    required this.branchCode,
    required this.branchName,
    required this.groupCode,
    required this.groupName,
    required this.logo,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'codFilial': branchCode,
      'descFilial': branchName,
      'codGrupo': groupCode,
      'descGrupo': groupName,
      'logo': logo,
    };
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) => Branch.fromMap(json.decode(source));

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      branchCode: map['codFilial'] ?? '',
      branchName: map['descFilial'] ?? '',
      groupCode: map['codGrupo'] ?? '',
      groupName: map['descGrupo'] ?? '',
      logo: map['logo'] ?? '',
    );
  }
}



/* 
"codFilial": "01",
"descFilial": "MATRIZ / AM",
"codGrupo": "01",
"descGrupo": "SPM DISTRIBUIDORA",
"logo": "iVBORw0KGg

*/ 