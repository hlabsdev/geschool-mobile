class ChangeMdpDto {
  String accessToken;
  String uIdentifiant;
  String newPassword;
  String oldPassword;
  String registrationId;

  ChangeMdpDto();

  ChangeMdpDto.create({
    this.accessToken,
    this.uIdentifiant,
    this.newPassword,
    this.oldPassword,
    this.registrationId,
  });

  @override
  factory ChangeMdpDto.fromJson(Map<String, dynamic> json) {
    return ChangeMdpDto.create(
      accessToken: json['acces_token'],
      uIdentifiant: json['u_identifiant'],
      newPassword: json['new_information'],
      oldPassword: json['old_information'],
      registrationId: json['registration_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'u_identifiant': uIdentifiant,
      'new_information': newPassword,
      'old_information': oldPassword,
      'registration_id': registrationId,
    };
  }
}
