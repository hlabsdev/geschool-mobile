class PersonnelModel {
  String key;
  int idsuer;
  int idcentre;
  int iddiplome;
  int idtypepersonnel;
  String indicegrade;
  String matricule;
  String dateembauche;
  String section;
  String autrecompetence;
  int status;
  int apiId;

  PersonnelModel();

  PersonnelModel.create({
    this.key,
    this.idsuer,
    this.idcentre,
    this.iddiplome,
    this.idtypepersonnel,
    this.indicegrade,
    this.matricule,
    this.dateembauche,
    this.section,
    this.autrecompetence,
    this.status,
    this.apiId,
  });

  @override
  factory PersonnelModel.fromJson(Map<String, dynamic> json) {
    return PersonnelModel.create(
      key: json['key'],
      idsuer: json['idsuer'],
      idcentre: json['idcentre'],
      iddiplome: json['iddiplome'],
      idtypepersonnel: json['idtypepersonnel'],
      indicegrade: json['indicegrade'],
      matricule: json['matricule'],
      dateembauche: json['dateembauche'],
      section: json['section'],
      autrecompetence: json['autrecompetence'],
      status: json['status'],
      apiId: json['apiId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'idsuer': idsuer,
      'idcentre': idcentre,
      'iddiplome': iddiplome,
      'idtypepersonnel': idtypepersonnel,
      'indicegrade': indicegrade,
      'matricule': matricule,
      'dateembauche': dateembauche,
      'section': section,
      'autrecompetence': autrecompetence,
      'status': status,
      'apiId': apiId,
    };
  }
}
