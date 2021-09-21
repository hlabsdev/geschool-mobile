class ApprenantEvalResponseModel {
  String status;
  String message;
  List<ApprenantEval> information;

  ApprenantEvalResponseModel({
    this.status,
    this.message,
    this.information,
  });

  ApprenantEvalResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.information = json["information"] == null
        ? null
        : (json["information"] as List)
            .map((e) => ApprenantEval.fromJson(e))
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

class ApprenantEval {
  int id;
  String nom;
  int note;

  ApprenantEval({
    this.id,
    this.nom,
    this.note,
  });

  ApprenantEval.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.nom = json["nom"];
    this.note = json["note"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["nom"] = this.nom;
    data["note"] = this.note;
    return data;
  }
}
