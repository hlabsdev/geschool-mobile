import 'package:geschool/features/common/data/models/basemodels/affectation_model.dart';

class AffectationListResponseModel {
  String status;
  String message;
  int isAdmin;
  List<AffectationModel> information;

  AffectationListResponseModel({
    this.status,
    this.message,
    this.isAdmin,
    this.information,
  });

  AffectationListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.isAdmin = json["is_admin"];
    this.information = json["information"] == null
        ? null
        : (json["information"] as List)
            .map((e) => AffectationModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    data["is_admin"] = this.isAdmin;
    if (this.information != null)
      data["information"] = this.information.map((e) => e.toJson()).toList();
    return data;
  }
}
