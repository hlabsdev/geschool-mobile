class ClasseListResponseModel {
  String status;
  String message;
  Information information;

  ClasseListResponseModel({
    this.status,
    this.message,
    this.information,
  });

  ClasseListResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<Specialites> specialites;
  List<Classes> classes;

  Information({
    this.specialites,
    this.classes,
  });

  Information.fromJson(Map<String, dynamic> json) {
    this.specialites = json["specialites"] == null
        ? null
        : (json["specialites"] as List)
            .map((e) => Specialites.fromJson(e))
            .toList();
    this.classes = json["classes"] == null
        ? null
        : (json["classes"] as List).map((e) => Classes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.specialites != null)
      data["specialites"] = this.specialites.map((e) => e.toJson()).toList();
    if (this.classes != null)
      data["classes"] = this.classes.map((e) => e.toJson()).toList();
    return data;
  }
}

class Classes {
  String idclasse;
  String keyclasse;
  String libelleclasse;
  String keyspecialite;
  String centre;

  Classes({
    this.idclasse,
    this.keyclasse,
    this.libelleclasse,
    this.keyspecialite,
    this.centre,
  });

  Classes.fromJson(Map<String, dynamic> json) {
    this.idclasse = json["idclasse"];
    this.keyclasse = json["keyclasse"];
    this.libelleclasse = json["libelleclasse"];
    this.keyspecialite = json["keyspecialite"];
    this.centre = json["centre"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["idclasse"] = this.idclasse;
    data["keyclasse"] = this.keyclasse;
    data["libelleclasse"] = this.libelleclasse;
    data["keyspecialite"] = this.keyspecialite;
    data["centre"] = this.centre;
    return data;
  }
}

class Specialites {
  String id;
  String libellespecialite;
  String keyspecialite;
  String idcentre;

  Specialites({
    this.id,
    this.libellespecialite,
    this.keyspecialite,
    this.idcentre,
  });

  Specialites.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.libellespecialite = json["libellespecialite"];
    this.keyspecialite = json["keyspecialite"];
    this.idcentre = json["idcentre"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["libellespecialite"] = this.libellespecialite;
    data["keyspecialite"] = this.keyspecialite;
    data["idcentre"] = this.idcentre;
    return data;
  }
}
