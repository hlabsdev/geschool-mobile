import 'package:geschool/features/common/data/models/basemodels/menu_list_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';

class AppResponseModel {
  String status;
  String message;
  Information information;

  AppResponseModel({this.status, this.message, this.information});

  AppResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.information = json["information"] == null
        ? null
        : Information.fromJson(json["information"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    if (this.information != null)
      data["information"] = this.information.toJson();
    return data;
  }
}

class Information {
  UserModel user;
  List<MenuItem> menus;

  Information({this.user, this.menus});

  Information.fromJson(Map<String, dynamic> json) {
    this.user = json["user"] == null ? null : UserModel.fromJson(json["user"]);
    this.menus = json["menus"] == null
        ? null
        : (json["menus"] as List).map((e) => MenuItem.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) data["user"] = this.user.toJson();
    if (this.menus != null)
      data["menus"] = this.menus.map((e) => e.toJson()).toList();
    return data;
  }
}
