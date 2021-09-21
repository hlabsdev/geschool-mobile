class InfoAbsence {
  String idApprenant;
  String idcentre;
  String typeAbsence;
  String heureFinRetard;

  InfoAbsence(
      {this.idApprenant, this.idcentre, this.typeAbsence, this.heureFinRetard});

  InfoAbsence.fromJson(Map<String, dynamic> json) {
    this.idApprenant = json["idApprenant"];
    this.idcentre = json["idcentre"];
    this.typeAbsence = json["type_absence"];
    this.heureFinRetard = json["heure_fin_retard"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["idApprenant"] = this.idApprenant;
    data["idcentre"] = this.idcentre;
    data["type_absence"] = this.typeAbsence;
    data["heure_fin_retard"] = this.heureFinRetard;
    return data;
  }
}
