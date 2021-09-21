class ConduiteListResponseModel {
  String status;
  String message;
  List<DetailApprenantConduite> information;

  ConduiteListResponseModel({
    this.status,
    this.message,
    this.information,
  });

  ConduiteListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.information = json["information"] == null
        ? null
        : (json["information"] as List)
            .map((e) => DetailApprenantConduite.fromJson(e))
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

class DetailApprenantConduite {
  String nom;
  String anneeScolaireKey;
  Classe classe;
  List<Years> years;
  List<Decoupage> decoupage;
  Infos infos;

  DetailApprenantConduite({
    this.nom,
    this.anneeScolaireKey,
    this.classe,
    this.years,
    this.decoupage,
    this.infos,
  });

  DetailApprenantConduite.fromJson(Map<String, dynamic> json) {
    this.nom = json["nom"];
    this.anneeScolaireKey = json["annee_scolaire_key"];
    this.classe =
        json["classe"] == null ? null : Classe.fromJson(json["classe"]);
    this.years = json["years"] == null
        ? null
        : (json["years"] as List).map((e) => Years.fromJson(e)).toList();
    this.decoupage = json["decoupage"] == null
        ? null
        : (json["decoupage"] as List)
            .map((e) => Decoupage.fromJson(e))
            .toList();
    this.infos = json["infos"] == null ? null : Infos.fromJson(json["infos"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["nom"] = this.nom;
    data["annee_scolaire_key"] = this.anneeScolaireKey;
    if (this.classe != null) data["classe"] = this.classe.toJson();
    if (this.years != null)
      data["years"] = this.years.map((e) => e.toJson()).toList();
    if (this.decoupage != null)
      data["decoupage"] = this.decoupage.map((e) => e.toJson()).toList();
    if (this.infos != null) data["infos"] = this.infos.toJson();
    return data;
  }
}

class Infos {
  Absence absence;
  Punition punition;
  Retard retard;

  Infos({
    this.absence,
    this.punition,
    this.retard,
  });

  Infos.fromJson(Map<String, dynamic> json) {
    this.absence =
        json["absence"] == null ? null : Absence.fromJson(json["absence"]);
    this.punition =
        json["punition"] == null ? null : Punition.fromJson(json["punition"]);
    this.retard =
        json["retard"] == null ? null : Retard.fromJson(json["retard"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.absence != null) data["absence"] = this.absence.toJson();
    if (this.punition != null) data["punition"] = this.punition.toJson();
    if (this.retard != null) data["retard"] = this.retard.toJson();
    return data;
  }
}

class Retard {
  int valeur;
  String unite;
  List<AbsenceDataModel> datas;

  Retard({
    this.valeur,
    this.unite,
    this.datas,
  });

  Retard.fromJson(Map<String, dynamic> json) {
    this.valeur = json["valeur"];
    this.unite = json["unite"];
    this.datas = json["datas"] == null
        ? null
        : (json["datas"] as List)
            .map((e) => AbsenceDataModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["valeur"] = this.valeur;
    data["unite"] = this.unite;
    if (this.datas != null)
      data["datas"] = this.datas.map((e) => e.toJson()).toList();
    return data;
  }
}

class AbsenceDataModel {
  int id;
  int idclasse;
  int iduser;
  String keyabsenceapprenant;
  String dateabsencedebut;
  String dateabsencefin;
  String justification;
  int typeabsence;
  int status;
  int idcentre;
  int idannee;

  AbsenceDataModel({
    this.id,
    this.idclasse,
    this.iduser,
    this.keyabsenceapprenant,
    this.dateabsencedebut,
    this.dateabsencefin,
    this.justification,
    this.typeabsence,
    this.status,
    this.idcentre,
    this.idannee,
  });

  AbsenceDataModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.idclasse = json["idclasse"];
    this.iduser = json["iduser"];
    this.keyabsenceapprenant = json["keyabsenceapprenant"];
    this.dateabsencedebut = json["dateabsencedebut"];
    this.dateabsencefin = json["dateabsencefin"];
    this.justification = json["justification"];
    this.typeabsence = json["typeabsence"];
    this.status = json["status"];
    this.idcentre = json["idcentre"];
    this.idannee = json["idannee"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["idclasse"] = this.idclasse;
    data["iduser"] = this.iduser;
    data["keyabsenceapprenant"] = this.keyabsenceapprenant;
    data["dateabsencedebut"] = this.dateabsencedebut;
    data["dateabsencefin"] = this.dateabsencefin;
    data["justification"] = this.justification;
    data["typeabsence"] = this.typeabsence;
    data["status"] = this.status;
    data["idcentre"] = this.idcentre;
    data["idannee"] = this.idannee;
    return data;
  }
}

class Punition {
  int valeur;
  String unite;
  List<PunitionDataModel> datas;

  Punition({this.valeur, this.unite, this.datas});

  Punition.fromJson(Map<String, dynamic> json) {
    this.valeur = json["valeur"];
    this.unite = json["unite"];
    this.datas = json["datas"] == null
        ? null
        : (json["datas"] as List)
            .map((e) => PunitionDataModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["valeur"] = this.valeur;
    data["unite"] = this.unite;
    if (this.datas != null)
      data["datas"] = this.datas.map((e) => e.toJson()).toList();
    return data;
  }
}

class PunitionDataModel {
  int id;
  String keypunition;
  String motifpunition;
  String datepunition;
  String datefinpunition;
  int idannee;
  int status;
  int idcentre;

  PunitionDataModel(
      {this.id,
      this.keypunition,
      this.motifpunition,
      this.datepunition,
      this.datefinpunition,
      this.idannee,
      this.status,
      this.idcentre});

  PunitionDataModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.keypunition = json["keypunition"];
    this.motifpunition = json["motifpunition"];
    this.datepunition = json["datepunition"];
    this.datefinpunition = json["datefinpunition"];
    this.idannee = json["idannee"];
    this.status = json["status"];
    this.idcentre = json["idcentre"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["keypunition"] = this.keypunition;
    data["motifpunition"] = this.motifpunition;
    data["datepunition"] = this.datepunition;
    data["datefinpunition"] = this.datefinpunition;
    data["idannee"] = this.idannee;
    data["status"] = this.status;
    data["idcentre"] = this.idcentre;
    return data;
  }
}

class Absence {
  double valeur;
  String unite;
  List<AbsenceDataModel> datas;

  Absence({this.valeur, this.unite, this.datas});

  Absence.fromJson(Map<String, dynamic> json) {
    this.valeur = double.parse(json["valeur"].toString());
    this.unite = json["unite"];
    this.datas = json["datas"] == null
        ? null
        : (json["datas"] as List)
            .map((e) => AbsenceDataModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["valeur"] = this.valeur;
    data["unite"] = this.unite;
    if (this.datas != null)
      data["datas"] = this.datas.map((e) => e.toJson()).toList();
    return data;
  }
}

class Decoupage {
  String id;
  String idtypedecoupage;
  String idannee;
  String idcentre;
  String keydecoupage;
  String datedebutdecoupage;
  String datefindecoupage;
  String status;
  String libelle;

  Decoupage(
      {this.id,
      this.idtypedecoupage,
      this.idannee,
      this.idcentre,
      this.keydecoupage,
      this.datedebutdecoupage,
      this.datefindecoupage,
      this.status,
      this.libelle});

  Decoupage.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.idtypedecoupage = json["idtypedecoupage"];
    this.idannee = json["idannee"];
    this.idcentre = json["idcentre"];
    this.keydecoupage = json["keydecoupage"];
    this.datedebutdecoupage = json["datedebutdecoupage"];
    this.datefindecoupage = json["datefindecoupage"];
    this.status = json["status"];
    this.libelle = json["libelle"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["idtypedecoupage"] = this.idtypedecoupage;
    data["idannee"] = this.idannee;
    data["idcentre"] = this.idcentre;
    data["keydecoupage"] = this.keydecoupage;
    data["datedebutdecoupage"] = this.datedebutdecoupage;
    data["datefindecoupage"] = this.datefindecoupage;
    data["status"] = this.status;
    data["libelle"] = this.libelle;
    return data;
  }
}

class Years {
  int id;
  String libelleanneescolaire;
  String keyanneescolaire;
  int status;
  String datedebutannee;
  String datefinannee;
  int idcentre;

  Years(
      {this.id,
      this.libelleanneescolaire,
      this.keyanneescolaire,
      this.status,
      this.datedebutannee,
      this.datefinannee,
      this.idcentre});

  Years.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.libelleanneescolaire = json["libelleanneescolaire"];
    this.keyanneescolaire = json["keyanneescolaire"];
    this.status = json["status"];
    this.datedebutannee = json["datedebutannee"];
    this.datefinannee = json["datefinannee"];
    this.idcentre = json["idcentre"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["libelleanneescolaire"] = this.libelleanneescolaire;
    data["keyanneescolaire"] = this.keyanneescolaire;
    data["status"] = this.status;
    data["datedebutannee"] = this.datedebutannee;
    data["datefinannee"] = this.datefinannee;
    data["idcentre"] = this.idcentre;
    return data;
  }
}

class Classe {
  String libelleclasse;
  String libellespecialite;

  Classe({this.libelleclasse, this.libellespecialite});

  Classe.fromJson(Map<String, dynamic> json) {
    this.libelleclasse = json["libelleclasse"];
    this.libellespecialite = json["libellespecialite"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["libelleclasse"] = this.libelleclasse;
    data["libellespecialite"] = this.libellespecialite;
    return data;
  }
}
