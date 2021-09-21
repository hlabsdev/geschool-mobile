class SalleModel {
  String key;
  int idcentre;
  String libelle;
  int nbreplacemaxi;
  int status;
  int apiId;

  SalleModel();

  SalleModel.create({
    this.key,
    this.idcentre,
    this.libelle,
    this.nbreplacemaxi,
    this.status,
    this.apiId,
  });

  @override
  factory SalleModel.fromJson(Map<String, dynamic> json) {
    return SalleModel.create(
      key: json['key'],
      idcentre: json['idcentre'],
      libelle: json['libelle'],
      nbreplacemaxi: json['nbreplacemaxi'],
      status: json['status'],
      apiId: json['apiId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'idcentre': idcentre,
      'libelle': libelle,
      'nbreplacemaxi': nbreplacemaxi,
      'status': status,
      'apiId': apiId,
    };
  }
}
