// import 'dart:convert';

class CentreDto {
  String accessToken;
  String denomination;
  String localite;
  int smsDisponible;
  String prefecture;
  String nomcourt;
  String telephone;
  String email;
  String siteweb;
  String reseausociaux;
  String inspection;
  String lienlogo;
  double latitude;
  double longitude;

  CentreDto();

  CentreDto.create({
    this.accessToken,
    this.denomination,
    this.localite,
    this.smsDisponible,
    this.prefecture,
    this.nomcourt,
    this.telephone,
    this.email,
    this.siteweb,
    this.reseausociaux,
    this.inspection,
    this.lienlogo,
    this.latitude,
    this.longitude,
  });

  @override
  factory CentreDto.fromJson(Map<String, dynamic> json) {
    return CentreDto.create(
      accessToken: json['access_token'],
      denomination: json['denomination'],
      localite: json['localite'],
      smsDisponible: json['sms_disponible'],
      prefecture: json['prefecture'],
      nomcourt: json['nomcourt'],
      telephone: json['telephone'],
      email: json['email'],
      siteweb: json['siteweb'],
      reseausociaux: json['reseausociaux'],
      inspection: json['inspection'],
      lienlogo: json['lienlogo'],
      latitude: double.parse("${json['latitude']}"),
      longitude: double.parse("${json['longitude']}"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'denomination': denomination,
      'localite': localite,
      'smsDisponible': smsDisponible,
      'prefecture': prefecture,
      'nomcourt': nomcourt,
      'telephone': telephone,
      'email': email,
      'siteweb': siteweb,
      'reseausociaux': reseausociaux,
      'inspection': inspection,
      'lienlogo': lienlogo,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String toGetMap() {
    return "access-token=$accessToken&denomination=$denomination&localite=$localite&sms_disponible=$smsDisponible&prefecture=$prefecture&nomcourt=$nomcourt&telephone=$telephone&email=$email&siteweb=$siteweb&reseausociaux=$reseausociaux&inspection=$inspection&lienlogo=$lienlogo&latitude=$latitude&longitude=$longitude";
  }
}
