class NoteModel {
  String key;
  int idsuer;
  int idevaluation;
  String note;
  int status;
  int apiId;

  NoteModel();

  NoteModel.create({
    this.key,
    this.idsuer,
    this.idevaluation,
    this.note,
    this.status,
    this.apiId,
  });

  @override
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel.create(
      key: json['key'],
      idsuer: json['idsuer'],
      idevaluation: json['idevaluation'],
      note: json['note'],
      status: json['status'],
      apiId: json['apiId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'idsuer': idsuer,
      'idevaluation': idevaluation,
      'note': note,
      'status': status,
      'apiId': apiId,
    };
  }
}
