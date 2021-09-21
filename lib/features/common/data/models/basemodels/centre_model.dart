class Centres {
  int key;
  String value;

  Centres({this.key, this.value});

  Centres.fromJson(Map<String, dynamic> json) {
    this.key = json["key"];
    this.value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["key"] = this.key;
    data["value"] = this.value;
    return data;
  }
}
/*  */

class CentreModel {
  int idCenter;
  String keyCenter;
  String denominationCenter;
  String localiteCenter;
  String region;
  String prefecture;
  String nomcourt;
  String codecentre;
  String telephonecentre;
  String emailcentre;
  String sitewebcentre;
  String reseausociauxcentre;
  String inspection;
  String lienlogo;
  dynamic coordonnegpsx;
  dynamic coordonnegpsy;

  CentreModel({
    this.idCenter,
    this.keyCenter,
    this.denominationCenter,
    this.localiteCenter,
    this.region,
    this.prefecture,
    this.nomcourt,
    this.codecentre,
    this.telephonecentre,
    this.emailcentre,
    this.sitewebcentre,
    this.reseausociauxcentre,
    this.inspection,
    this.lienlogo,
    this.coordonnegpsx,
    this.coordonnegpsy,
  });

  CentreModel.fromJson(Map<String, dynamic> json) {
    this.idCenter = json["id_center"];
    this.keyCenter = json["key_center"];
    this.denominationCenter = json["denomination_center"];
    this.localiteCenter = json["localite_center"];
    this.region = json["region"];
    this.prefecture = json["prefecture"];
    this.nomcourt = json["nomcourt"];
    this.codecentre = json["codecentre"];
    this.telephonecentre = json["telephonecentre"];
    this.emailcentre = json["emailcentre"];
    this.sitewebcentre = json["sitewebcentre"];
    this.reseausociauxcentre = json["reseausociauxcentre"];
    this.inspection = json["inspection"];
    this.lienlogo = json["lienlogo"];
    this.coordonnegpsx = json["coordonnegpsx"];
    this.coordonnegpsy = json["coordonnegpsy"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id_center"] = this.idCenter;
    data["key_center"] = this.keyCenter;
    data["denomination_center"] = this.denominationCenter;
    data["localite_center"] = this.localiteCenter;
    data["region"] = this.region;
    data["prefecture"] = this.prefecture;
    data["nomcourt"] = this.nomcourt;
    data["codecentre"] = this.codecentre;
    data["telephonecentre"] = this.telephonecentre;
    data["emailcentre"] = this.emailcentre;
    data["sitewebcentre"] = this.sitewebcentre;
    data["reseausociauxcentre"] = this.reseausociauxcentre;
    data["inspection"] = this.inspection;
    data["lienlogo"] = this.lienlogo;
    data["coordonnegpsx"] = this.coordonnegpsx;
    data["coordonnegpsy"] = this.coordonnegpsy;
    return data;
  }
}
