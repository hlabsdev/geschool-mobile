class PermissionApprenantModel {
  String id;
  String iduser;
  String idannee;
  String keypermission;
  String datedemandepermission;
  String motifpermission;
  String datedebutpermission;
  String heuredebutpermission;
  String datefinpermission;
  String heurefinpermission;
  String isdemande;
  String status;
  String createdAt;
  String updatedAt;
  String createBy;
  String updatedBy;
  String idcentre;
  String keyapprenant;
  String nom;
  String prenoms;
  String authKey;
  String idCenter;
  String denominationCenter;

  PermissionApprenantModel({
    this.id,
    this.iduser,
    this.idannee,
    this.keypermission,
    this.datedemandepermission,
    this.motifpermission,
    this.datedebutpermission,
    this.heuredebutpermission,
    this.datefinpermission,
    this.heurefinpermission,
    this.isdemande,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createBy,
    this.updatedBy,
    this.idcentre,
    this.keyapprenant,
    this.nom,
    this.prenoms,
    this.authKey,
    this.idCenter,
    this.denominationCenter,
  });

  PermissionApprenantModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.iduser = json["iduser"];
    this.idannee = json["idannee"];
    this.keypermission = json["keypermission"];
    this.datedemandepermission = json["datedemandepermission"];
    this.motifpermission = json["motifpermission"];
    this.datedebutpermission = json["datedebutpermission"];
    this.heuredebutpermission = json["heuredebutpermission"];
    this.datefinpermission = json["datefinpermission"];
    this.heurefinpermission = json["heurefinpermission"];
    this.isdemande = json["isdemande"];
    this.status = json["status"];
    this.createdAt = json["created_at"];
    this.updatedAt = json["updated_at"];
    this.createBy = json["create_by"];
    this.updatedBy = json["updated_by"];
    this.idcentre = json["idcentre"];
    this.keyapprenant = json["keyapprenant"];
    this.nom = json["nom"];
    this.prenoms = json["prenoms"];
    this.authKey = json["auth_key"];
    this.idCenter = json["id_center"];
    this.denominationCenter = json["denomination_center"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["iduser"] = this.iduser;
    data["idannee"] = this.idannee;
    data["keypermission"] = this.keypermission;
    data["datedemandepermission"] = this.datedemandepermission;
    data["motifpermission"] = this.motifpermission;
    data["datedebutpermission"] = this.datedebutpermission;
    data["heuredebutpermission"] = this.heuredebutpermission;
    data["datefinpermission"] = this.datefinpermission;
    data["heurefinpermission"] = this.heurefinpermission;
    data["isdemande"] = this.isdemande;
    data["status"] = this.status;
    data["created_at"] = this.createdAt;
    data["updated_at"] = this.updatedAt;
    data["create_by"] = this.createBy;
    data["updated_by"] = this.updatedBy;
    data["idcentre"] = this.idcentre;
    data["keyapprenant"] = this.keyapprenant;
    data["nom"] = this.nom;
    data["prenoms"] = this.prenoms;
    data["auth_key"] = this.authKey;
    data["id_center"] = this.idCenter;
    data["denomination_center"] = this.denominationCenter;
    return data;
  }
}
