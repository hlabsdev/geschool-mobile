class EvaluationModel {
  String keyEvaluation;
  String dateEvaluation;
  String decoupage;
  String typeEvaluation;
  String matiere;
  String classe;
  int idcenter;

  EvaluationModel({
    this.keyEvaluation,
    this.dateEvaluation,
    this.decoupage,
    this.typeEvaluation,
    this.matiere,
    this.classe,
    this.idcenter,
  });

  EvaluationModel.fromJson(Map<String, dynamic> json) {
    this.keyEvaluation = json["key_evaluation"];
    this.dateEvaluation = json["date_evaluation"];
    this.decoupage = json["decoupage"];
    this.typeEvaluation = json["type_evaluation"];
    this.matiere = json["matiere"];
    this.classe = json["classe"];
    this.idcenter = json["idcenter"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["key_evaluation"] = this.keyEvaluation;
    data["date_evaluation"] = this.dateEvaluation;
    data["decoupage"] = this.decoupage;
    data["type_evaluation"] = this.typeEvaluation;
    data["matiere"] = this.matiere;
    data["classe"] = this.classe;
    data["idcenter"] = this.idcenter;
    return data;
  }
}
