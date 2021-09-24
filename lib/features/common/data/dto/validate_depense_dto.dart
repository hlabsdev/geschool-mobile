class ValidateDepenseDto {
  String accessToken;
  String uIdentifiant;
  String cIdentifiant;
  String dIdentifiant;
  String operation;
  String registrationId;

  ValidateDepenseDto({
    this.accessToken,
    this.uIdentifiant,
    this.cIdentifiant,
    this.operation,
    this.registrationId,
  });

  ValidateDepenseDto.fromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.uIdentifiant = json["u_identifiant"];
    this.cIdentifiant = json["c_identifiant"];
    this.dIdentifiant = json["d_identifiant"];
    this.operation = json["operation"];
    this.registrationId = json["registration_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["u_identifiant"] = this.uIdentifiant;
    data["c_identifiant"] = this.cIdentifiant;
    data["d_identifiant"] = this.dIdentifiant;
    data["operation"] = this.operation;
    data["registration_id"] = this.registrationId;
    return data;
  }
}
