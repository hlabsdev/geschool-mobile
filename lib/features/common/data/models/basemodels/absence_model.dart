class AbsenceModel {
  int id;
  String keytypeabsence;
  String designationtypeabsence;
  int autoriseAbsence;
  String nameUser;
  int isMe;
  String keyabsence;
  int idCenter;
  String datedemandeabsence;
  String motifabsence;
  String datedebutabsence;
  String heuredebutabsence;
  String datefinabsence;
  String heurefinabsence;
  String coordonneesabsence;
  String lieudestinantionabsence;
  int heurearattraper;
  int status;
  int createdAt;

  AbsenceModel({
    this.id,
    this.keytypeabsence,
    this.designationtypeabsence,
    this.autoriseAbsence,
    this.nameUser,
    this.idCenter,
    this.isMe,
    this.keyabsence,
    this.datedemandeabsence,
    this.motifabsence,
    this.datedebutabsence,
    this.heuredebutabsence,
    this.datefinabsence,
    this.heurefinabsence,
    this.coordonneesabsence,
    this.lieudestinantionabsence,
    this.heurearattraper,
    this.status,
    this.createdAt,
  });

  AbsenceModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.keytypeabsence = json["keytypeabsence"];
    this.designationtypeabsence = json["designationtypeabsence"];
    this.autoriseAbsence = json["autorise_absence"];
    this.nameUser = json["name_user"];
    this.idCenter = json["id_center"];
    this.isMe = json["isMe"];
    this.keyabsence = json["keyabsence"];
    this.datedemandeabsence = json["datedemandeabsence"];
    this.motifabsence = json["motifabsence"];
    this.datedebutabsence = json["datedebutabsence"];
    this.heuredebutabsence = json["heuredebutabsence"];
    this.datefinabsence = json["datefinabsence"];
    this.heurefinabsence = json["heurefinabsence"];
    this.coordonneesabsence = json["coordonneesabsence"];
    this.lieudestinantionabsence = json["lieudestinantionabsence"];
    this.heurearattraper = json["heurearattraper"];
    this.status = json["status"];
    this.createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["keytypeabsence"] = this.keytypeabsence;
    data["designationtypeabsence"] = this.designationtypeabsence;
    data["autorise_absence"] = this.autoriseAbsence;
    data["name_user"] = this.nameUser;
    data["id_center"] = this.idCenter;
    data["isMe"] = this.isMe;
    data["keyabsence"] = this.keyabsence;
    data["datedemandeabsence"] = this.datedemandeabsence;
    data["motifabsence"] = this.motifabsence;
    data["datedebutabsence"] = this.datedebutabsence;
    data["heuredebutabsence"] = this.heuredebutabsence;
    data["datefinabsence"] = this.datefinabsence;
    data["heurefinabsence"] = this.heurefinabsence;
    data["coordonneesabsence"] = this.coordonneesabsence;
    data["lieudestinantionabsence"] = this.lieudestinantionabsence;
    data["heurearattraper"] = this.heurearattraper;
    data["status"] = this.status;
    data["created_at"] = this.createdAt;
    return data;
  }
}
