class BulletinListResponseModel {
  String status;
  String message;
  List<ApprenantBulletin> information;

  BulletinListResponseModel({
    this.status,
    this.message,
    this.information,
  });

  BulletinListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.information = json["information"] == null
        ? null
        : (json["information"] as List)
            .map((e) => ApprenantBulletin.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    if (this.information != null)
      data["information"] = this.information.map((e) => e.toJson()).toList();
    return data;
  }
}

class ApprenantBulletin {
  String nom;
  String classe;
  List<BulletinParDecoupage> decoupages;

  ApprenantBulletin({
    this.nom,
    this.classe,
    this.decoupages,
  });

  ApprenantBulletin.fromJson(Map<String, dynamic> json) {
    this.nom = json["nom"];
    this.classe = json["classe"];
    this.decoupages = json["decoupages"] == null
        ? null
        : (json["decoupages"] as List)
            .map((e) => BulletinParDecoupage.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["nom"] = this.nom;
    if (this.decoupages != null)
      data["decoupages"] = this.decoupages.map((e) => e.toJson()).toList();
    return data;
  }
}

class BulletinParDecoupage {
  int iddecoupage;
  String libelledecoupage;
  String keydecoupage;
  Datas datas;

  BulletinParDecoupage({
    this.iddecoupage,
    this.libelledecoupage,
    this.keydecoupage,
    this.datas,
  });

  BulletinParDecoupage.fromJson(Map<String, dynamic> json) {
    this.iddecoupage = json["iddecoupage"];
    this.libelledecoupage = json["libelledecoupage"];
    this.keydecoupage = json["keydecoupage"];
    this.datas = json["datas"] == null ? null : Datas.fromJson(json["datas"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["iddecoupage"] = this.iddecoupage;
    data["libelledecoupage"] = this.libelledecoupage;
    data["keydecoupage"] = this.keydecoupage;
    if (this.datas != null) data["datas"] = this.datas.toJson();
    return data;
  }
}

class Datas {
  String status;
  CentreInfo centreInfo;
  Bulletin bulletin;

  Datas({
    this.status,
    this.centreInfo,
    this.bulletin,
  });

  Datas.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.centreInfo = json["other_info"] == null
        ? null
        : CentreInfo.fromJson(json["other_info"]);
    this.bulletin =
        json["bulletin"] == null ? null : Bulletin.fromJson(json["bulletin"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    if (this.centreInfo != null) data["other_info"] = this.centreInfo.toJson();
    if (this.bulletin != null) data["bulletin"] = this.bulletin.toJson();
    return data;
  }
}

class Bulletin {
  String id;
  String idcentre;
  String keyBulletin;
  String iduser;
  String idannee;
  String idclasse;
  String iddecoupage;
  String idDirecteur;
  String idTitulaire;
  String note;
  String moyenne;
  String coefficient;
  String appreciation;
  String honneur;
  String rang;
  String absence;
  String punition;
  String retard;
  String moyenneForte;
  String moyenneFaible;
  String categorieResultat;
  dynamic endBulletin;
  String endRang;
  String situation;
  String status;
  String createdAt;
  String updatedAt;
  String createBy;
  String updatedBy;
  String nom;
  String prenoms;
  String libelleanneescolaire;
  String libelle;
  String ordre;
  String libelleclasse;
  String libellespecialite;
  String matricule;

  Bulletin({
    this.id,
    this.idcentre,
    this.keyBulletin,
    this.iduser,
    this.idannee,
    this.idclasse,
    this.iddecoupage,
    this.idDirecteur,
    this.idTitulaire,
    this.note,
    this.moyenne,
    this.coefficient,
    this.appreciation,
    this.honneur,
    this.rang,
    this.absence,
    this.punition,
    this.retard,
    this.moyenneForte,
    this.moyenneFaible,
    this.categorieResultat,
    this.endBulletin,
    this.endRang,
    this.situation,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createBy,
    this.updatedBy,
    this.nom,
    this.prenoms,
    this.libelleanneescolaire,
    this.libelle,
    this.ordre,
    this.libelleclasse,
    this.libellespecialite,
    this.matricule,
  });

  Bulletin.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.idcentre = json["idcentre"];
    this.keyBulletin = json["key_bulletin"];
    this.iduser = json["iduser"];
    this.idannee = json["idannee"];
    this.idclasse = json["idclasse"];
    this.iddecoupage = json["iddecoupage"];
    this.idDirecteur = json["id_directeur"];
    this.idTitulaire = json["id_titulaire"];
    this.note = json["note"];
    this.moyenne = json["moyenne"];
    this.coefficient = json["coefficient"];
    this.appreciation = json["appreciation"];
    this.honneur = json["honneur"];
    this.rang = json["rang"];
    this.absence = json["absence"];
    this.punition = json["punition"];
    this.retard = json["retard"];
    this.moyenneForte = json["moyenne_forte"];
    this.moyenneFaible = json["moyenne_faible"];
    this.categorieResultat = json["categorie_resultat"];
    this.endBulletin = json["end_bulletin"];
    this.endRang = json["end_rang"];
    this.situation = json["situation"];
    this.status = json["status"];
    this.createdAt = json["created_at"];
    this.updatedAt = json["updated_at"];
    this.createBy = json["create_by"];
    this.updatedBy = json["updated_by"];
    this.nom = json["nom"];
    this.prenoms = json["prenoms"];
    this.libelleanneescolaire = json["libelleanneescolaire"];
    this.libelle = json["libelle"];
    this.ordre = json["ordre"];
    this.libelleclasse = json["libelleclasse"];
    this.libellespecialite = json["libellespecialite"];
    this.matricule = json["matricule"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["idcentre"] = this.idcentre;
    data["key_bulletin"] = this.keyBulletin;
    data["iduser"] = this.iduser;
    data["idannee"] = this.idannee;
    data["idclasse"] = this.idclasse;
    data["iddecoupage"] = this.iddecoupage;
    data["id_directeur"] = this.idDirecteur;
    data["id_titulaire"] = this.idTitulaire;
    data["note"] = this.note;
    data["moyenne"] = this.moyenne;
    data["coefficient"] = this.coefficient;
    data["appreciation"] = this.appreciation;
    data["honneur"] = this.honneur;
    data["rang"] = this.rang;
    data["absence"] = this.absence;
    data["punition"] = this.punition;
    data["retard"] = this.retard;
    data["moyenne_forte"] = this.moyenneForte;
    data["moyenne_faible"] = this.moyenneFaible;
    data["categorie_resultat"] = this.categorieResultat;
    data["end_bulletin"] = this.endBulletin;
    data["end_rang"] = this.endRang;
    data["situation"] = this.situation;
    data["status"] = this.status;
    data["created_at"] = this.createdAt;
    data["updated_at"] = this.updatedAt;
    data["create_by"] = this.createBy;
    data["updated_by"] = this.updatedBy;
    data["nom"] = this.nom;
    data["prenoms"] = this.prenoms;
    data["libelleanneescolaire"] = this.libelleanneescolaire;
    data["libelle"] = this.libelle;
    data["ordre"] = this.ordre;
    data["libelleclasse"] = this.libelleclasse;
    data["libellespecialite"] = this.libellespecialite;
    data["matricule"] = this.matricule;
    return data;
  }
}

class CentreInfo {
  String inspectionCenter;
  String nomCenter;
  String localiteCenter;
  String lienlogo;
  int effectif;
  int nouveau;
  String prefecture;
  String titulaire;
  String directeur;

  CentreInfo({
    this.inspectionCenter,
    this.nomCenter,
    this.localiteCenter,
    this.lienlogo,
    this.effectif,
    this.nouveau,
    this.prefecture,
    this.titulaire,
    this.directeur,
  });

  CentreInfo.fromJson(Map<String, dynamic> json) {
    this.inspectionCenter = json["inspection_center"];
    this.nomCenter = json["nom_center"];
    this.localiteCenter = json["localite_center"];
    this.lienlogo = json["lienlogo"];
    this.effectif = json["effectif"];
    this.nouveau = json["nouveau"];
    this.prefecture = json["prefecture"];
    this.titulaire = json["titulaire"];
    this.directeur = json["directeur"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["inspection_center"] = this.inspectionCenter;
    data["nom_center"] = this.nomCenter;
    data["localite_center"] = this.localiteCenter;
    data["lienlogo"] = this.lienlogo;
    data["effectif"] = this.effectif;
    data["nouveau"] = this.nouveau;
    data["prefecture"] = this.prefecture;
    data["titulaire"] = this.titulaire;
    data["directeur"] = this.directeur;
    return data;
  }
}
