class DepenseModel {
  String id;
  String idsection;
  String iduser;
  String keydepense;
  String datedemande;
  String motifdemande;
  String montantdepense;
  String datedepense;
  String description;
  String referencetransaction;
  String status;
  String createdAt;
  String updatedAt;
  String createBy;
  String updatedBy;
  String datetraitement;
  String idcentre;
  String motifsuppression;
  String idannee;
  String keypersonnel;
  String nom;
  String prenoms;
  String keysection;
  String designation;

  DepenseModel({
    this.id,
    this.idsection,
    this.iduser,
    this.keydepense,
    this.datedemande,
    this.motifdemande,
    this.montantdepense,
    this.datedepense,
    this.description,
    this.referencetransaction,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createBy,
    this.updatedBy,
    this.datetraitement,
    this.idcentre,
    this.motifsuppression,
    this.idannee,
    this.keypersonnel,
    this.nom,
    this.prenoms,
    this.keysection,
    this.designation,
  });

  DepenseModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.idsection = json["idsection"];
    this.iduser = json["iduser"];
    this.keydepense = json["keydepense"];
    this.datedemande = json["datedemande"];
    this.motifdemande = json["motifdemande"];
    this.montantdepense = json["montantdepense"];
    this.datedepense = json["datedepense"];
    this.description = json["description"];
    this.referencetransaction = json["referencetransaction"];
    this.status = json["status"];
    this.createdAt = json["created_at"];
    this.updatedAt = json["updated_at"];
    this.createBy = json["create_by"];
    this.updatedBy = json["updated_by"];
    this.datetraitement = json["datetraitement"];
    this.idcentre = json["idcentre"];
    this.motifsuppression = json["motifsuppression"];
    this.idannee = json["idannee"];
    this.keypersonnel = json["keypersonnel"];
    this.nom = json["nom"];
    this.prenoms = json["prenoms"];
    this.keysection = json["keysection"];
    this.designation = json["designation"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["idsection"] = this.idsection;
    data["iduser"] = this.iduser;
    data["keydepense"] = this.keydepense;
    data["datedemande"] = this.datedemande;
    data["motifdemande"] = this.motifdemande;
    data["montantdepense"] = this.montantdepense;
    data["datedepense"] = this.datedepense;
    data["description"] = this.description;
    data["referencetransaction"] = this.referencetransaction;
    data["status"] = this.status;
    data["created_at"] = this.createdAt;
    data["updated_at"] = this.updatedAt;
    data["create_by"] = this.createBy;
    data["updated_by"] = this.updatedBy;
    data["datetraitement"] = this.datetraitement;
    data["idcentre"] = this.idcentre;
    data["motifsuppression"] = this.motifsuppression;
    data["idannee"] = this.idannee;
    data["keypersonnel"] = this.keypersonnel;
    data["nom"] = this.nom;
    data["prenoms"] = this.prenoms;
    data["keysection"] = this.keysection;
    data["designation"] = this.designation;
    return data;
  }
}
