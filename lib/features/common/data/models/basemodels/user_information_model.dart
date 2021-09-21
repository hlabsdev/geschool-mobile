class UserInformationModel {
  String key;
  String authkey;
  String idcentre;
  String defaultCentre;
  String nom;
  String prenoms;
  String username;
  String email;
  String telephoneuser;
  String photo;
  String datenaissance;
  String adresseuser;
  String typeuser;
  int status;
  // String status;

  UserInformationModel();

  UserInformationModel.create({
    this.key,
    this.authkey,
    this.idcentre,
    this.nom,
    this.prenoms,
    this.username,
    this.email,
    this.telephoneuser,
    this.photo,
    this.status,
    this.datenaissance,
    this.adresseuser,
    this.typeuser,
    this.defaultCentre,
  });

  @override
  factory UserInformationModel.fromJson(Map<String, dynamic> json) {
    return UserInformationModel.create(
      key: json['key'],
      authkey: json['auth_key'],
      idcentre: json['id_center'],
      nom: json['nom'],
      prenoms: json['prenoms'],
      username: json['username'],
      email: json['email'],
      telephoneuser: json['telephoneuser'],
      photo: json['photo'],
      adresseuser: json['adresseuser'],
      defaultCentre: json['default_center'].toString(),
      typeuser: json['type_user'],
      datenaissance: json['datenaissance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'auth_key': authkey,
      'id_center': idcentre,
      'default_center': defaultCentre,
      'nom': nom,
      'prenoms': prenoms,
      'username': username,
      'email': email,
      'telephoneuser': telephoneuser,
      'photo': photo,
      'adresseuser': adresseuser,
      'type_user': typeuser,
      'datenaissance': datenaissance,
    };
  }
}
