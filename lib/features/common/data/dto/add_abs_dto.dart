class AddAbsDto {
  String accessToken;
  String uIdentifiant;
  String cIdentifiant;
  String heureDebut;
  String heureFin;
  String jsonAbsence;
  String registrationId;

  AddAbsDto({
    this.accessToken,
    this.uIdentifiant,
    this.cIdentifiant,
    this.heureDebut,
    this.heureFin,
    this.jsonAbsence,
    this.registrationId,
  });

  AddAbsDto.fromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.uIdentifiant = json["u_identifiant"];
    this.cIdentifiant = json["c_identifiant"];
    this.heureDebut = json["heure_debut"];
    this.heureFin = json["heure_fin"];
    this.jsonAbsence = json["json_absence"];
    this.registrationId = json["registration_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["u_identifiant"] = this.uIdentifiant;
    data["c_identifiant"] = this.cIdentifiant;
    data["heure_debut"] = this.heureDebut;
    data["heure_fin"] = this.heureFin;
    data["json_absence"] = this.jsonAbsence;
    data["registration_id"] = this.registrationId;
    return data;
  }
}
