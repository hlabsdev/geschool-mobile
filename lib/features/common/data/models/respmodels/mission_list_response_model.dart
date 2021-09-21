import 'package:geschool/features/common/data/models/basemodels/mission_model.dart';

class MissionListResponseModel {
  String status;
  String message;
  int isAdmin;
  List<MissionModel> information;

  MissionListResponseModel({this.status, this.message, this.information});

  MissionListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.isAdmin = json["is_admin"];
    this.information = json["information"] == null
        ? null
        : (json["information"] as List)
            .map((e) => MissionModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    data["is_iadmin"] = this.isAdmin;
    if (this.information != null)
      data["information"] = this.information.map((e) => e.toJson()).toList();
    return data;
  }
}
