class UserModel {
  int typeUser;
  String profilName;
  int isProf;
  String nom;
  String prenoms;
  String photo;
  String username;
  String authKey;
  String email;
  List<String> idcenters;
  String datenaissance;
  String telephoneuser;
  String adresseuser;

  UserModel({
    this.typeUser,
    this.profilName,
    this.isProf,
    this.nom,
    this.prenoms,
    this.photo,
    this.username,
    this.authKey,
    this.email,
    this.idcenters,
    this.datenaissance,
    this.telephoneuser,
    this.adresseuser,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    this.typeUser = json["type_user"];
    this.profilName = json["profil_name"];
    this.isProf = json["is_prof"];
    this.nom = json["nom"];
    this.prenoms = json["prenoms"];
    this.photo = json["photo"];
    this.username = json["username"];
    this.authKey = json["auth_key"];
    this.email = json["email"];
    this.idcenters =
        json["idcenters"] == null ? null : List<String>.from(json["idcenters"]);
    this.datenaissance = json["datenaissance"];
    this.telephoneuser = json["telephoneuser"];
    this.adresseuser = json["adresseuser"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["type_user"] = this.typeUser;
    data["profil_name"] = this.profilName;
    data["is_prof"] = this.isProf;
    data["nom"] = this.nom;
    data["prenoms"] = this.prenoms;
    data["photo"] = this.photo;
    data["username"] = this.username;
    data["auth_key"] = this.authKey;
    data["email"] = this.email;
    if (this.idcenters != null) data["idcenters"] = this.idcenters;
    data["datenaissance"] = this.datenaissance;
    data["telephoneuser"] = this.telephoneuser;
    data["adresseuser"] = this.adresseuser;
    return data;
  }
}
