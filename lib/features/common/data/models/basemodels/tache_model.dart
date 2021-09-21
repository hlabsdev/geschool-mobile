class TacheModel {
  String nameUser;
  String keyUser;
  int isMe;
  String keyPersonnel;
  String descriptionTache;
  String dateTache;
  String dateRappelTache;
  String keyTache;
  String rapportTache;
  int idCentre;
  String centre;

  TacheModel({
    this.nameUser,
    this.keyUser,
    this.isMe,
    this.keyPersonnel,
    this.descriptionTache,
    this.dateTache,
    this.dateRappelTache,
    this.keyTache,
    this.rapportTache,
    this.idCentre,
    this.centre,
  });

  TacheModel.fromJson(Map<String, dynamic> json) {
    this.nameUser = json["name_user"];
    this.keyUser = json["key_user"];
    this.isMe = json["isMe"];
    this.keyPersonnel = json["key_personnel"];
    this.descriptionTache = json["description_tache"];
    this.dateTache = json["date_tache"];
    this.dateRappelTache = json["date_rappel_tache"];
    this.keyTache = json["key_tache"];
    this.rapportTache = json["rapport_tache"];
    this.idCentre = json["id_centre"];
    this.centre = json["centre"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name_user"] = this.nameUser;
    data["isMe"] = this.isMe;
    data["key_user"] = this.keyUser;
    data["key_personnel"] = this.keyPersonnel;
    data["description_tache"] = this.descriptionTache;
    data["date_tache"] = this.dateTache;
    data["date_rappel_tache"] = this.dateRappelTache;
    data["key_tache"] = this.keyTache;
    data["rapport_tache"] = this.rapportTache;
    data["id_centre"] = this.idCentre;
    data["centre"] = this.centre;
    return data;
  }
}
