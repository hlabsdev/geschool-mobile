class ApprenantEvalDto {
  String accessToken;
  String uIdentifiant;
  String eIdentifiant;
  String registrationId;

  ApprenantEvalDto();

  ApprenantEvalDto.create({
    this.accessToken,
    this.uIdentifiant,
    this.eIdentifiant,
    this.registrationId,
  });

  @override
  factory ApprenantEvalDto.fromJson(Map<String, dynamic> json) {
    return ApprenantEvalDto.create(
      accessToken: json['acces_token'],
      uIdentifiant: json['u_identifiant'],
      eIdentifiant: json['e_identifiant'],
      registrationId: json['registration_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'u_identifiant': uIdentifiant,
      'e_identifiant': eIdentifiant,
      'registration_id': registrationId,
    };
  }
}
