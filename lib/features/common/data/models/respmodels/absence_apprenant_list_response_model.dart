import 'package:geschool/features/common/data/models/basemodels/absence_apprenant_model.dart';
import 'package:geschool/features/common/data/models/basemodels/type_absences_model.dart';

class AbsenceApprenantListResponseModel {
  String status;
  String message;
  dynamic isAdmin;
  String typeRenvoie;
  Information information;

  AbsenceApprenantListResponseModel({
    this.status,
    this.message,
    this.isAdmin,
    this.typeRenvoie,
    this.information,
  });

  AbsenceApprenantListResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<AbsenceApprenantModel> infos;
  List<TypesAbsencesApprenant> typesAbsences;

  Information({
    this.infos,
    this.typesAbsences,
  });

  Information.fromJson(Map<String, dynamic> json) {
    this.infos = json["infos"] == null
        ? null
        : (json["infos"] as List)
            .map((e) => AbsenceApprenantModel.fromJson(e))
            .toList();
    this.typesAbsences = json["types_absences"] == null
        ? null
        : (json["types_absences"] as List)
            .map((e) => TypesAbsencesApprenant.fromJson(e))
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
