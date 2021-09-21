class NoteApprenantListResponseModel {
  String status;
  String message;
  int isAdmin;
  String typeRenvoie;
  Information information;

  NoteApprenantListResponseModel({
    this.status,
    this.message,
    this.isAdmin,
    this.typeRenvoie,
    this.information,
  });

  NoteApprenantListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.isAdmin = json["is_admin"];
    this.typeRenvoie = json["type_renvoie"];
    this.information = json["information"] == null
        ? null
        : Information.fromJson(json["information"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    data["is_admin"] = this.isAdmin;
    data["type_renvoie"] = this.typeRenvoie;
    if (this.information != null)
      data["information"] = this.information.toJson();
    return data;
  }
}

class Information {
  List<NoteApprenantModel> infos;

  Information({this.infos});

  Information.fromJson(Map<String, dynamic> json) {
    this.infos = json["infos"] == null
        ? null
        : (json["infos"] as List)
            .map((e) => NoteApprenantModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.infos != null)
      data["infos"] = this.infos.map((e) => e.toJson()).toList();
    return data;
  }
}

class NoteApprenantModel {
  String nameUser;
  String note;
  String evaluation;
  String dateEvaluation;
  String matiere;
  String idclasse;
  String keynote;
  String decoupage;
  String idannee;
  String centre;

  NoteApprenantModel({
    this.nameUser,
    this.note,
    this.evaluation,
    this.dateEvaluation,
    this.matiere,
    this.idclasse,
    this.keynote,
    this.decoupage,
    this.idannee,
    this.centre,
  });

  NoteApprenantModel.fromJson(Map<String, dynamic> json) {
    this.nameUser = json["name_user"];
    this.note = json["note"];
    this.evaluation = json["evaluation"];
    this.dateEvaluation = json["date_evaluation"];
    this.matiere = json["matiere"];
    this.idclasse = json["idclasse"];
    this.keynote = json["keynote"];
    this.decoupage = json["decoupage"];
    this.idannee = json["idannee"];
    this.centre = json["centre"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name_user"] = this.nameUser;
    data["note"] = this.note;
    data["evaluation"] = this.evaluation;
    data["date_evaluation"] = this.dateEvaluation;
    data["matiere"] = this.matiere;
    data["idclasse"] = this.idclasse;
    data["keynote"] = this.keynote;
    data["decoupage"] = this.decoupage;
    data["idannee"] = this.idannee;
    data["centre"] = this.centre;
    return data;
  }
}
