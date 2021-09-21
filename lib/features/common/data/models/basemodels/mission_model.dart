class MissionModel {
  String keymission;
  String motif;
  int isMe;
  String datedepart;
  String lieumission;
  String itineraireretenu;
  String dateretourprob;
  String nameCentre;
  int idCenter;
  List<DetailsModel> details;

  MissionModel({
    this.keymission,
    this.motif,
    this.isMe,
    this.idCenter,
    this.datedepart,
    this.lieumission,
    this.itineraireretenu,
    this.dateretourprob,
    this.nameCentre,
    this.details,
  });

  MissionModel.fromJson(Map<String, dynamic> json) {
    this.keymission = json["keymission"];
    this.motif = json["motif"];
    this.isMe = json["isMe"];
    this.idCenter = json["id_center"];
    this.datedepart = json["datedepart"];
    this.lieumission = json["lieumission"];
    this.itineraireretenu = json["itineraireretenu"];
    this.dateretourprob = json["dateretourprob"];
    this.nameCentre = json["name_centre"];
    this.details = json["details"] == null
        ? null
        : (json["details"] as List)
            .map((e) => DetailsModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["keymission"] = this.keymission;
    data["motif"] = this.motif;
    data["isMe"] = this.isMe;
    data["id_center"] = this.idCenter;
    data["datedepart"] = this.datedepart;
    data["lieumission"] = this.lieumission;
    data["itineraireretenu"] = this.itineraireretenu;
    data["dateretourprob"] = this.dateretourprob;
    data["name_centre"] = this.nameCentre;
    if (this.details != null)
      data["details"] = this.details.map((e) => e.toJson()).toList();
    return data;
  }
}

class DetailsModel {
  String keydetailmission;
  String namePersonnel;
  String frais;
  String contactabsence;
  String dateretoureffmission;

  DetailsModel({
    this.keydetailmission,
    this.namePersonnel,
    this.frais,
    this.contactabsence,
    this.dateretoureffmission,
  });

  DetailsModel.fromJson(Map<String, dynamic> json) {
    this.keydetailmission = json["keydetailmission"];
    this.namePersonnel = json["name_personnel"];
    this.frais = json["frais"];
    this.contactabsence = json["contactabsence"];
    this.dateretoureffmission = json["dateretoureffmission"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["keydetailmission"] = this.keydetailmission;
    data["name_personnel"] = this.namePersonnel;
    data["frais"] = this.frais;
    data["contactabsence"] = this.contactabsence;
    data["dateretoureffmission"] = this.dateretoureffmission;
    return data;
  }
}
