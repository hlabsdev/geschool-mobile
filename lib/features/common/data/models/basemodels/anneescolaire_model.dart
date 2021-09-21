class AnneeScolaireModel {
  String keyAnnee;
  String libelleAnnee;

  AnneeScolaireModel({
    this.keyAnnee,
    this.libelleAnnee,
  });

  AnneeScolaireModel.fromJson(Map<String, dynamic> json) {
    this.keyAnnee = json["key_annee"];
    this.libelleAnnee = json["libelle_annee"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["key_annee"] = this.keyAnnee;
    data["libelle_annee"] = this.libelleAnnee;
    return data;
  }
}
