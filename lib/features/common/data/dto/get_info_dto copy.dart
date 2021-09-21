class GetBulletinLinkDto {
  String accessToken;
  String uIdentifiant;
  String bIdentifiant;
  String idCenter;
  String registrationId;

  GetBulletinLinkDto();

  GetBulletinLinkDto.create({
    this.accessToken,
    this.uIdentifiant,
    this.bIdentifiant,
    this.idCenter,
    this.registrationId,
  });

  @override
  factory GetBulletinLinkDto.fromJson(Map<String, dynamic> json) {
    return GetBulletinLinkDto.create(
      accessToken: json['acces_token'],
      uIdentifiant: json['u_identifiant'],
      bIdentifiant: json['b_identifiant'],
      idCenter: json['id_center'],
      registrationId: json['registration_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'u_identifiant': uIdentifiant,
      'b_identifiant': bIdentifiant,
      'id_center': idCenter,
      'registration_id': registrationId,
    };
  }
}
