class AffectationModel {
  int id;
  String nom;
  String centre;
  int isMe;
  String dateDebut;
  String dateFin;

  AffectationModel({
    this.id,
    this.nom,
    this.isMe,
    this.centre,
    this.dateDebut,
    this.dateFin,
  });

  AffectationModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.nom = json["nom"];
    this.isMe = json["isMe"];
    this.centre = json["centre"];
    this.dateDebut = json["date_debut"];
    this.dateFin = json["date_fin"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["nom"] = this.nom;
    data["isMe"] = this.isMe;
    data["centre"] = this.centre;
    data["date_debut"] = this.dateDebut;
    data["date_fin"] = this.dateFin;
    return data;
  }
}
