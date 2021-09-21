import 'package:geschool/features/common/data/models/basemodels/absence_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';

class AbsencePersonnelListResponseModel {
  String status;
  String message;
  int isAdmin;
  String typeRenvoie;
  Information information;

  AbsencePersonnelListResponseModel({
    this.status,
    this.message,
    this.isAdmin,
    this.typeRenvoie,
    this.information,
  });

  AbsencePersonnelListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.isAdmin = json["is_admin"];
    this.typeRenvoie = json["type_renvoie"];
    this.information = json["information"] == null
        ? null
        : Information.fromJson(json["information"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    data["is_admin"] = this.isAdmin;
    data["type_renvoie"] = this.typeRenvoie;
    if (this.information != null)
      data["information"] = this.information.toJson();
    return data;
  }
}

class Information {
  List<AbsenceModel> infos;
  List<TypesAbsencesPersonnel> typesAbsences;

  Information({this.infos, this.typesAbsences});

  Information.fromJson(Map<String, dynamic> json) {
    this.infos = json["infos"] == null
        ? null
        : (json["infos"] as List).map((e) => AbsenceModel.fromJson(e)).toList();
    this.typesAbsences = json["types_absences"] == null
        ? null
        : (json["types_absences"] as List)
            .map((e) => TypesAbsencesPersonnel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.infos != null)
      data["infos"] = this.infos.map((e) => e.toJson()).toList();
    if (this.typesAbsences != null)
      data["types_absences"] =
          this.typesAbsences.map((e) => e.toJson()).toList();
    return data;
  }
}
