class ApprenantModel {
  String id;
  String keyinscription;
  String iduser;
  String idcentre;
  String idannee;
  String idclasse;
  String dateinscription;
  String status;
  String createdAt;
  dynamic updatedAt;
  String createBy;
  dynamic updatedBy;
  String nom;
  String prenoms;
  String photo;
  String username;
  String email;
  dynamic datenaissance;
  String telephoneuser;
  dynamic adresseuser;
  String keyapprenant;
  String matricule;
  String sexe;
  String lieunaissance;
  String keyclasse;
  String libelleclasse;
  String keyspecialite;
  String libellespecialite;
  String idCenter;
  String denominationCenter;

  ApprenantModel({
    this.id,
    this.keyinscription,
    this.iduser,
    this.idcentre,
    this.idannee,
    this.idclasse,
    this.dateinscription,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createBy,
    this.updatedBy,
    this.nom,
    this.prenoms,
    this.photo,
    this.username,
    this.email,
    this.datenaissance,
    this.telephoneuser,
    this.adresseuser,
    this.keyapprenant,
    this.matricule,
    this.sexe,
    this.lieunaissance,
    this.keyclasse,
    this.libelleclasse,
    this.keyspecialite,
    this.libellespecialite,
    this.idCenter,
    this.denominationCenter,
  });

  ApprenantModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.keyinscription = json["keyinscription"];
    this.iduser = json["iduser"];
    this.idcentre = json["idcentre"];
    this.idannee = json["idannee"];
    this.idclasse = json["idclasse"];
    this.dateinscription = json["dateinscription"];
    this.status = json["status"];
    this.createdAt = json["created_at"];
    this.updatedAt = json["updated_at"];
    this.createBy = json["create_by"];
    this.updatedBy = json["updated_by"];
    this.nom = json["nom"];
    this.prenoms = json["prenoms"];
    this.photo = json["photo"];
    this.username = json["username"];
    this.email = json["email"];
    this.datenaissance = json["datenaissance"];
    this.telephoneuser = json["telephoneuser"];
    this.adresseuser = json["adresseuser"];
    this.keyapprenant = json["keyapprenant"];
    this.matricule = json["matricule"];
    this.sexe = json["sexe"];
    this.lieunaissance = json["lieunaissance"];
    this.keyclasse = json["keyclasse"];
    this.libelleclasse = json["libelleclasse"];
    this.keyspecialite = json["keyspecialite"];
    this.libellespecialite = json["libellespecialite"];
    this.idCenter = json["id_center"];
    this.denominationCenter = json["denomination_center"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["keyinscription"] = this.keyinscription;
    data["iduser"] = this.iduser;
    data["idcentre"] = this.idcentre;
    data["idannee"] = this.idannee;
    data["idclasse"] = this.idclasse;
    data["dateinscription"] = this.dateinscription;
    data["status"] = this.status;
    data["created_at"] = this.createdAt;
    data["updated_at"] = this.updatedAt;
    data["create_by"] = this.createBy;
    data["updated_by"] = this.updatedBy;
    data["nom"] = this.nom;
    data["prenoms"] = this.prenoms;
    data["photo"] = this.photo;
    data["username"] = this.username;
    data["email"] = this.email;
    data["datenaissance"] = this.datenaissance;
    data["telephoneuser"] = this.telephoneuser;
    data["adresseuser"] = this.adresseuser;
    data["keyapprenant"] = this.keyapprenant;
    data["matricule"] = this.matricule;
    data["sexe"] = this.sexe;
    data["lieunaissance"] = this.lieunaissance;
    data["keyclasse"] = this.keyclasse;
    data["libelleclasse"] = this.libelleclasse;
    data["keyspecialite"] = this.keyspecialite;
    data["libellespecialite"] = this.libellespecialite;
    data["id_center"] = this.idCenter;
    data["denomination_center"] = this.denominationCenter;
    return data;
  }
}
