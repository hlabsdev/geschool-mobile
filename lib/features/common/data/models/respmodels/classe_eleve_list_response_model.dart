class ClasseEleveListResponseModel {
  String status;
  String message;
  Information information;

  ClasseEleveListResponseModel({
    this.status,
    this.message,
    this.information,
  });

  ClasseEleveListResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<TypesAbsences> typesAbsences;
  List<Eleves> eleves;

  Information({
    this.typesAbsences,
    this.eleves,
  });

  Information.fromJson(Map<String, dynamic> json) {
    this.typesAbsences = json["types_absences"] == null
        ? null
        : (json["types_absences"] as List)
            .map((e) => TypesAbsences.fromJson(e))
            .toList();
    this.eleves = json["eleves"] == null
        ? null
        : (json["eleves"] as List).map((e) => Eleves.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.typesAbsences != null)
      data["types_absences"] =
          this.typesAbsences.map((e) => e.toJson()).toList();
    if (this.eleves != null)
      data["eleves"] = this.eleves.map((e) => e.toJson()).toList();
    return data;
  }
}

class Eleves {
  int id;
  String nom;
  String elevekey;
  String idcentre;

  Eleves({
    this.id,
    this.nom,
    this.elevekey,
    this.idcentre,
  });

  Eleves.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.nom = json["nom"];
    this.elevekey = json["elevekey"];
    this.idcentre = json["idcentre"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["nom"] = this.nom;
    data["elevekey"] = this.elevekey;
    data["idcentre"] = this.idcentre;
    return data;
  }
}

class TypesAbsences {
  int key;
  String value;

  TypesAbsences({
    this.key,
    this.value,
  });

  TypesAbsences.fromJson(Map<String, dynamic> json) {
    this.key = json["key"];
    this.value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["key"] = this.key;
    data["value"] = this.value;
    return data;
  }
}
