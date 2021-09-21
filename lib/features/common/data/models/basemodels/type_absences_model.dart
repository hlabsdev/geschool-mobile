class TypesAbsencesPersonnel {
  String key;
  String value;

  TypesAbsencesPersonnel({
    this.key,
    this.value,
  });

  TypesAbsencesPersonnel.fromJson(Map<String, dynamic> json) {
    this.key = json["key"];
    this.value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["key"] = this.key;
    data["value"] = this.value;
    return data;
  }
}

class TypesAbsencesApprenant {
  int key;
  String value;

  TypesAbsencesApprenant({
    this.key,
    this.value,
  });

  TypesAbsencesApprenant.fromJson(Map<String, dynamic> json) {
    this.key = json["key"];
    this.value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["key"] = this.key;
    data["value"] = this.value;
    return data;
  }
}
