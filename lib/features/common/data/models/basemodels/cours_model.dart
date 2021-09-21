class CoursModel {
  String key;
  int idcentre;
  int idtypecours;
  String designation;
  int status;
  int apiId;

  CoursModel();

  CoursModel.create({
    this.key,
    this.idcentre,
    this.idtypecours,
    this.designation,
    this.status,
    this.apiId,
  });

  @override
  factory CoursModel.fromJson(Map<String, dynamic> json) {
    return CoursModel.create(
      key: json['key'],
      idcentre: json['idcentre'],
      idtypecours: json['idtypecours'],
      designation: json['designation'],
      status: json['status'],
      apiId: json['apiId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'idcentre': idcentre,
      'idtypecours': idtypecours,
      'designation': designation,
      'status': status,
      'apiId': apiId,
    };
  }
}
