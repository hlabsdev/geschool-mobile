class AbsenceApprenantModel {
  int id;
  String nameUser;
  String keyabsenceapprenant;
  String dateabsencedebut;
  String dateabsencefin;
  String justification;
  String typeabsence;
  int status;
  String anneeScolaire;
  String centre;
  String classe;

  AbsenceApprenantModel({
    this.id,
    this.nameUser,
    this.keyabsenceapprenant,
    this.dateabsencedebut,
    this.dateabsencefin,
    this.justification,
    this.typeabsence,
    this.status,
    this.anneeScolaire,
    this.centre,
    this.classe,
  });

  AbsenceApprenantModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.nameUser = json["name_user"];
    this.keyabsenceapprenant = json["keyabsenceapprenant"];
    this.dateabsencedebut = json["dateabsencedebut"];
    this.dateabsencefin = json["dateabsencefin"];
    this.justification = json["justification"];
    this.typeabsence = json["typeabsence"];
    this.status = json["status"];
    this.anneeScolaire = json["annee_scolaire"];
    this.centre = json["centre"];
    this.classe = json["classe"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name_user"] = this.nameUser;
    data["keyabsenceapprenant"] = this.keyabsenceapprenant;
    data["dateabsencedebut"] = this.dateabsencedebut;
    data["dateabsencefin"] = this.dateabsencefin;
    data["justification"] = this.justification;
    data["typeabsence"] = this.typeabsence;
    data["status"] = this.status;
    data["annee_scolaire"] = this.anneeScolaire;
    data["centre"] = this.centre;
    data["classe"] = this.classe;
    return data;
  }
}
