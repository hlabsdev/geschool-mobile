import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';

class CentreResponseModel {
  String status;
  String message;
  List<CentreModel> information;

  CentreResponseModel({
    this.status,
    this.message,
    this.information,
  });

  CentreResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.information = json["information"] == null
        ? null
        : (json["information"] as List)
            .map((e) => CentreModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    if (this.information != null)
      data["information"] = this.information.map((e) => e.toJson()).toList();
    return data;
  }
}
