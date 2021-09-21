class MenuListModel {
  String status;
  String message;
  List<MenuItem> information;

  MenuListModel({this.status, this.message, this.information});

  MenuListModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.information = json["information"] == null
        ? null
        : (json["information"] as List)
            .map((e) => MenuItem.fromJson(e))
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

class MenuItem {
  String libFonction;
  String logo;

  MenuItem({this.libFonction, this.logo});

  MenuItem.fromJson(Map<String, dynamic> json) {
    this.libFonction = json["lib_fonction"];
    this.logo = json["logo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lib_fonction"] = this.libFonction;
    data["logo"] = this.logo;
    return data;
  }
}
