class InscriptionDto {
  String accessToken;
  String uIdentifiant;
  String username;
  String nom;
  String prenoms;
  String telephone;
  String email;
  String adresse;
  String dateNaissance;
  String photo;
  String registrationId;

  InscriptionDto();

  InscriptionDto.create({
    this.accessToken,
    this.uIdentifiant,
    this.username,
    this.nom,
    this.prenoms,
    this.telephone,
    this.email,
    this.adresse,
    this.dateNaissance,
    this.photo,
    this.registrationId,
  });

  @override
  factory InscriptionDto.fromJson(Map<String, dynamic> json) {
    return InscriptionDto.create(
      accessToken: json['access_token'],
      uIdentifiant: json['u_identifiant'],
      username: json['username'],
      nom: json['nom'],
      prenoms: json['prenoms'],
      telephone: json['telephone'],
      email: json['email'],
      adresse: json['adresse'],
      dateNaissance: json['date_naissance'],
      photo: json['photo'],
      registrationId: json['registration_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'u_identifiant': uIdentifiant,
      'username': username,
      'nom': nom,
      'prenoms': prenoms,
      'telephone': telephone,
      'email': email,
      'adresse': adresse,
      'date_naissance': dateNaissance,
      'photo': photo,
      'registration_id': registrationId,
    };
  }
}
