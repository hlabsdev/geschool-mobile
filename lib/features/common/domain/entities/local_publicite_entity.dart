import 'package:geschool/helpers/base_entity.dart';

class LocalPubliciteEntity extends BaseEntity {
  int idPublicite;
  String keyPublicite;
  String titrePublicite;
  String descriptionPublicite;
  String photoPublicite;
  String datefinPublicite;
  int etat;
  int mobileTime;

  LocalPubliciteEntity();

  LocalPubliciteEntity.create(
      {this.idPublicite,
      this.keyPublicite,
      this.titrePublicite,
      this.descriptionPublicite,
      this.photoPublicite,
      this.datefinPublicite,
      this.etat,
      this.mobileTime});

  @override
  fromDatabase(Map<String, dynamic> json) {
    return LocalPubliciteEntity.create(
      idPublicite: json['id'],
      keyPublicite: json['key_publicite'],
      titrePublicite: json['titre_publicite'],
      descriptionPublicite: json['description_publicite'],
      photoPublicite: json['photo_publicite'],
      datefinPublicite: json['datefin_publicite'],
      etat: json['etat'],
      mobileTime: json['mobile_time'],
    );
  }

  @override
  factory LocalPubliciteEntity.fromJson(Map<String, dynamic> json) {
    return LocalPubliciteEntity.create(
      idPublicite: json['id'],
      keyPublicite: json['key_publicite'],
      titrePublicite: json['titre_publicite'],
      descriptionPublicite: json['description_publicite'],
      photoPublicite: json['photo_publicite'],
      datefinPublicite: json['datefin_publicite'],
      etat: json['etat'],
      mobileTime: json['mobile_time'],
    );
  }

  @override
  Map<String, dynamic> toDatabase() {
    return {
      'key_publicite': keyPublicite,
      'titre_publicite': titrePublicite,
      'description_publicite': descriptionPublicite,
      'photo_publicite': photoPublicite,
      'datefin_publicite': datefinPublicite,
      'etat': etat,
      'mobile_time': mobileTime,
    };
  }
}
