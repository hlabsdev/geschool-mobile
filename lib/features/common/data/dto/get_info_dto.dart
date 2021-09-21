class GetInfoDto {
  String accessToken;
  String uIdentifiant;
  String registrationId;

  GetInfoDto();

  GetInfoDto.create({
    this.accessToken,
    this.uIdentifiant,
    this.registrationId,
  });

  @override
  factory GetInfoDto.fromJson(Map<String, dynamic> json) {
    return GetInfoDto.create(
      accessToken: json['acces_token'],
      uIdentifiant: json['u_identifiant'],
      registrationId: json['registration_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'u_identifiant': uIdentifiant,
      'registration_id': registrationId,
    };
  }
}
