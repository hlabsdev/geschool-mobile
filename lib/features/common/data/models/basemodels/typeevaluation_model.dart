class TypeEvaluationModel {
  String key;
  int idcentre;
  String libelle;
  int status;
  int apiId;

  TypeEvaluationModel();

  TypeEvaluationModel.create({
    this.key,
    this.idcentre,
    this.libelle,
    this.status,
    this.apiId,
  });

  @override
  factory TypeEvaluationModel.fromJson(Map<String, dynamic> json) {
    return TypeEvaluationModel.create(
      key: json['key'],
      idcentre: json['idcentre'],
      libelle: json['libelle'],
      status: json['status'],
      apiId: json['apiId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'idcentre': idcentre,
      'libelle': libelle,
      'status': status,
      'apiId': apiId,
    };
  }
}
