class ResetPasswordDto {
  String accessToken;
  String username;
  String typeField;
  String codeValidation;
  String password;
  String registrationId;

  ResetPasswordDto();

  ResetPasswordDto.create({
    this.accessToken,
    this.username,
    this.typeField,
    this.codeValidation,
    this.password,
    this.registrationId,
  });

  @override
  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) {
    return ResetPasswordDto.create(
      accessToken: json["access_token"],
      username: json["username"],
      typeField: json["type_field"],
      codeValidation: json["code_validation"],
      password: json["password"],
      registrationId: json["registration_id"],
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["access_token"] = accessToken;
    map["username"] = username;
    map["type_field"] = typeField;
    map["code_validation"] = codeValidation;
    map["password"] = password;
    map["registration_id"] = registrationId;
    return map;
  }
}
