import 'package:geschool/helpers/base_entity.dart';

class LocalAlertEntity extends BaseEntity {
  int idAlert;
  String keyAlert;

  LocalAlertEntity();

  LocalAlertEntity.create({
    this.idAlert,
    this.keyAlert,
  });

  @override
  fromDatabase(Map<String, dynamic> json) {
    return LocalAlertEntity.create(
      idAlert: json['id'],
      keyAlert: json['keyAlert'],
    );
  }

  @override
  factory LocalAlertEntity.fromJson(Map<String, dynamic> json) {
    return LocalAlertEntity.create(
      idAlert: json['id'],
      keyAlert: json['key_publicite'],
    );
  }

  @override
  Map<String, dynamic> toDatabase() {
    return {
      'key_publicite': keyAlert,
    };
  }
}
