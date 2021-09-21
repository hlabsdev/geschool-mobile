

import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/domain/entities/local_alert_entity.dart';
import 'package:geschool/helpers/base_repository.dart';
import 'package:geschool/helpers/database_helper.dart';
import 'package:geschool/helpers/helpers_utils.dart';

class LocalAlertRepository extends BaseRepository<LocalAlertEntity, int> {
  LocalAlertRepository() : super(TABLE_NAME_ALERT);

  @override
  LocalAlertEntity getEntity() {
    return new LocalAlertEntity();
  }


  Future<List<LocalAlertRepository>> existAlert(String valeur) async {
    var dbClient = await DatabaseHelper.database;
    final sql = '''SELECT * FROM $TABLE_NAME_ALERT where $keyPublicite="$valeur"''';
    final data = await dbClient.rawQuery(sql);

    return List.generate(data.length, (i) {
      return getEntity().fromDatabase(data[i]);
    });
  }

  Future<List<LocalAlertRepository>> allAlert() async {
    int dateExpire= FunctionUtils.nowExpire(0);

    var dbClient = await DatabaseHelper.database;
    final sql = '''SELECT * FROM $TABLE_NAME_ALERT where $etatPublicite="1"  and $timePublicite>=$dateExpire  order by $idPublicite desc ''';
    final data = await dbClient.rawQuery(sql);

    return List.generate(data.length, (i) {
      return getEntity().fromDatabase(data[i]);
    });
  }


}