

import 'package:geschool/features/common/data/function_utils.dart';
// import 'package:geschool/features/common/domain/entities/local_compagnon_entity.dart';
// import 'package:geschool/features/common/domain/entities/local_company_entity.dart';
import 'package:geschool/features/common/domain/entities/local_publicite_entity.dart';
import 'package:geschool/helpers/base_repository.dart';
import 'package:geschool/helpers/database_helper.dart';
import 'package:geschool/helpers/helpers_utils.dart';

class LocalPubliciteRepository extends BaseRepository<LocalPubliciteEntity, int> {
  LocalPubliciteRepository() : super(TABLE_NAME_PUBLICITE);

  @override
  LocalPubliciteEntity getEntity() {
    return new LocalPubliciteEntity();
  }


  Future<List<LocalPubliciteEntity>> existPublicite(String valeur) async {
    var dbClient = await DatabaseHelper.database;
    final sql = '''SELECT * FROM $TABLE_NAME_PUBLICITE where $keyPublicite="$valeur"''';
    final data = await dbClient.rawQuery(sql);

    return List.generate(data.length, (i) {
      return getEntity().fromDatabase(data[i]);
    });
  }

  Future<List<LocalPubliciteEntity>> allPublicite() async {
    int dateExpire= FunctionUtils.nowExpire(0);

    var dbClient = await DatabaseHelper.database;
    final sql = '''SELECT * FROM $TABLE_NAME_PUBLICITE where $etatPublicite="1"  and $timePublicite>=$dateExpire  order by $idPublicite desc ''';
    final data = await dbClient.rawQuery(sql);

    return List.generate(data.length, (i) {
      return getEntity().fromDatabase(data[i]);
    });
  }


}