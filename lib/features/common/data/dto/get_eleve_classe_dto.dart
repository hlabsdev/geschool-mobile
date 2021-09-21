class GetEleveClasseDto {
  String accessToken;
  String uIdentifiant;
  String cIdentifiant;
  String registrationId;

  GetEleveClasseDto({
    this.accessToken,
    this.uIdentifiant,
    this.cIdentifiant,
    this.registrationId,
  });

  GetEleveClasseDto.fromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.uIdentifiant = json["u_identifiant"];
    this.cIdentifiant = json["c_identifiant"];
    this.registrationId = json["registration_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["u_identifiant"] = this.uIdentifiant;
    data["c_identifiant"] = this.cIdentifiant;
    data["registration_id"] = this.registrationId;
    return data;
  }
}
