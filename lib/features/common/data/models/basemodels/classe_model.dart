class ClasseModel {
  String key;
  int idcentre;
  int idspecialite;
  int idtypeformation;
  String libelle;
  int position;
  int status;
  int apiId;

  ClasseModel();

  ClasseModel.create({
    this.key,
    this.idcentre,
    this.idspecialite,
    this.idtypeformation,
    this.libelle,
    this.position,
    this.status,
    this.apiId,
  });

  @override
  factory ClasseModel.fromJson(Map<String, dynamic> json) {
    return ClasseModel.create(
      key: json['key'],
      idcentre: json['idcentre'],
      idspecialite: json['idspecialite'],
      idtypeformation: json['idtypeformation'],
      libelle: json['libelle'],
      position: json['position'],
      status: json['status'],
      apiId: json['apiId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'idcentre': idcentre,
      'idspecialite': idspecialite,
      'idtypeformation': idtypeformation,
      'libelle': libelle,
      'position': position,
      'status': status,
      'apiId': apiId,
    };
  }
}
