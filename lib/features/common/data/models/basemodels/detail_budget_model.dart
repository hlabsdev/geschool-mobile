class DetailBudgetModel {
  String dateOperation;
  String natureFondLibelle;
  String natureFondKey;
  String montantOperation;
  String nomPrenom;
  String description;
  String modedon;

  DetailBudgetModel({
    this.dateOperation,
    this.natureFondLibelle,
    this.natureFondKey,
    this.montantOperation,
    this.nomPrenom,
    this.description,
    this.modedon,
  });

  DetailBudgetModel.fromJson(Map<String, dynamic> json) {
    this.dateOperation = json["date_operation"];
    this.natureFondLibelle = json["nature_fond_libelle"];
    this.natureFondKey = json["nature_fond_key"];
    this.montantOperation = json["montant_operation"];
    this.nomPrenom = json["nom_prenom"];
    this.description = json["description"];
    this.modedon = json["modedon"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["date_operation"] = this.dateOperation;
    data["nature_fond_libelle"] = this.natureFondLibelle;
    data["nature_fond_key"] = this.natureFondKey;
    data["montant_operation"] = this.montantOperation;
    data["nom_prenom"] = this.nomPrenom;
    data["description"] = this.description;
    data["modedon"] = this.modedon;
    return data;
  }
}
