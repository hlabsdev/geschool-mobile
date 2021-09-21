import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';

class PersonnelListResponseModel {
  String status;
  String message;
  Information information;

  PersonnelListResponseModel({
    this.status,
    this.message,
    this.information,
  });

  PersonnelListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.information = json["information"] == null
        ? null
        : Information.fromJson(json["information"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    if (this.information != null)
      data["information"] = this.information.toJson();
    return data;
  }
}

class Information {
  List<PersonnelTache> personnels;
  List<Centres> centres;

  Information({
    this.personnels,
    this.centres,
  });

  Information.fromJson(Map<String, dynamic> json) {
    this.personnels = json["personnels"] == null
        ? null
        : (json["personnels"] as List)
            .map((e) => PersonnelTache.fromJson(e))
            .toList();
    this.centres = json["centres"] == null
        ? null
        : (json["centres"] as List).map((e) => Centres.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.personnels != null)
      data["personnels"] = this.personnels.map((e) => e.toJson()).toList();
    if (this.centres != null)
      data["centres"] = this.centres.map((e) => e.toJson()).toList();
    return data;
  }
}

class PersonnelTache {
  String idpersonnel;
  String nom;
  String prenoms;
  List<String> idcenters;
  String keypersonnel;

  PersonnelTache({
    this.idpersonnel,
    this.nom,
    this.prenoms,
    this.idcenters,
    this.keypersonnel,
  });

  PersonnelTache.fromJson(Map<String, dynamic> json) {
    this.idpersonnel = json["idpersonnel"];
    this.nom = json["nom"];
    this.prenoms = json["prenoms"];
    this.idcenters =
        json["idcenters"] == null ? null : List<String>.from(json["idcenters"]);
    this.keypersonnel = json["keypersonnel"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["idpersonnel"] = this.idpersonnel;
    data["nom"] = this.nom;
    data["prenoms"] = this.prenoms;
    if (this.idcenters != null) data["idcenters"] = this.idcenters;
    data["keypersonnel"] = this.keypersonnel;
    return data;
  }
}
