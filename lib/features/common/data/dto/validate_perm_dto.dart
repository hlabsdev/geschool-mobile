class ValidatePermDto {
  String accessToken;
  String uIdentifiant;
  String idCenter;
  String operation;
  String permissionKey;
  String registrationId;

  ValidatePermDto({
    this.accessToken,
    this.uIdentifiant,
    this.idCenter,
    this.operation,
    this.permissionKey,
    this.registrationId,
  });

  ValidatePermDto.fromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.uIdentifiant = json["u_identifiant"];
    this.idCenter = json["id_center"];
    this.operation = json["operation"];
    this.permissionKey = json["permission_key"];
    this.registrationId = json["registration_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["u_identifiant"] = this.uIdentifiant;
    data["id_center"] = this.idCenter;
    data["operation"] = this.operation;
    data["permission_key"] = this.permissionKey;
    data["registration_id"] = this.registrationId;
    return data;
  }
}
