class AddNoteDto {
  String accessToken;
  String uIdentifiant;
  String idCenter;
  String eIdentifiant;
  String aIdentifiant;
  String infoNote;

  AddNoteDto({
    this.accessToken,
    this.uIdentifiant,
    this.idCenter,
    this.eIdentifiant,
    this.aIdentifiant,
    this.infoNote,
  });

  AddNoteDto.fromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.uIdentifiant = json["u_identifiant"];
    this.idCenter = json["id_center"];
    this.eIdentifiant = json["e_identifiant"];
    this.aIdentifiant = json["a_identifiant"];
    this.infoNote = json["info_note"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["u_identifiant"] = this.uIdentifiant;
    data["id_center"] = this.idCenter;
    data["e_identifiant"] = this.eIdentifiant;
    data["a_identifiant"] = this.aIdentifiant;
    data["info_note"] = this.infoNote;
    return data;
  }
}

class InfoNote {
  String note;
  String iduser;

  InfoNote({
    this.note,
    this.iduser,
  });

  InfoNote.fromJson(Map<String, dynamic> json) {
    this.note = json["note"];
    this.iduser = json["iduser"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["note"] = this.note;
    data["iduser"] = this.iduser;
    return data;
  }
}
