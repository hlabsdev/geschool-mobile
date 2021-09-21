class AddPermissionDto {
  String accessToken;
  String uIdentifiant;
  String idCenter;
  String operation;
  String permissionKey;
  String motif;
  String dateDebut;
  String dateFin;
  String heureDebut;
  String heureFin;
  String keyApprenant;
  String dateDemande;
  String demande;
  String registrationId;

  AddPermissionDto({
    this.accessToken,
    this.uIdentifiant,
    this.idCenter,
    this.operation,
    this.permissionKey,
    this.motif,
    this.dateDebut,
    this.dateFin,
    this.heureDebut,
    this.heureFin,
    this.keyApprenant,
    this.dateDemande,
    this.demande,
    this.registrationId,
  });

  AddPermissionDto.fromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.uIdentifiant = json["u_identifiant"];
    this.idCenter = json["id_center"];
    this.operation = json["operation"];
    this.permissionKey = json["permission_key"];
    this.motif = json["motif"];
    this.dateDebut = json["date_debut"];
    this.dateFin = json["date_fin"];
    this.heureDebut = json["heure_debut"];
    this.heureFin = json["heure_fin"];
    this.keyApprenant = json["key_apprenant"];
    this.dateDemande = json["date_demande"];
    this.demande = json["demande"];
    this.registrationId = json["registration_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["u_identifiant"] = this.uIdentifiant;
    data["id_center"] = this.idCenter;
    data["operation"] = this.operation;
    data["permission_key"] = this.permissionKey;
    data["motif"] = this.motif;
    data["date_debut"] = this.dateDebut;
    data["date_fin"] = this.dateFin;
    data["heure_debut"] = this.heureDebut;
    data["heure_fin"] = this.heureFin;
    data["key_apprenant"] = this.keyApprenant;
    data["date_demande"] = this.dateDemande;
    data["demande"] = this.demande;
    data["registration_id"] = this.registrationId;
    return data;
  }
}
