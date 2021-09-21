class SpecialiteModel {
  String key;
  int idcentre;
  int idsection;
  String libelle;
  int position;
  int status;
  int apiId;

  SpecialiteModel();

  SpecialiteModel.create({
    this.key,
    this.idcentre,
    this.idsection,
    this.libelle,
    this.position,
    this.status,
    this.apiId,
  });

  @override
  factory SpecialiteModel.fromJson(Map<String, dynamic> json) {
    return SpecialiteModel.create(
      key: json['key'],
      idcentre: json['idcentre'],
      idsection: json['idsection'],
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
      'idsection': idsection,
      'libelle': libelle,
      'position': position,
      'status': status,
      'apiId': apiId,
    };
  }
}
