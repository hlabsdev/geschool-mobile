class AddBudgetDto {
  String accessToken;
  String uIdentifiant;
  String cIdentifiant;
  String nIdentifiant;
  String montant;
  String description;
  String donnateur;
  String modePaiement;
  String datedetailbudget;
  String registrationId;

  AddBudgetDto({
    this.accessToken,
    this.uIdentifiant,
    this.cIdentifiant,
    this.nIdentifiant,
    this.montant,
    this.description,
    this.donnateur,
    this.modePaiement,
    this.datedetailbudget,
    this.registrationId,
  });

  AddBudgetDto.fromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.uIdentifiant = json["u_identifiant"];
    this.cIdentifiant = json["c_identifiant"];
    this.nIdentifiant = json["n_identifiant"];
    this.montant = json["montant"];
    this.description = json["description"];
    this.donnateur = json["donnateur"];
    this.modePaiement = json["mode_paiement"];
    this.datedetailbudget = json["datedetailbudget"];
    this.registrationId = json["registration_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["u_identifiant"] = this.uIdentifiant;
    data["c_identifiant"] = this.cIdentifiant;
    data["n_identifiant"] = this.nIdentifiant;
    data["montant"] = this.montant;
    data["description"] = this.description;
    data["donnateur"] = this.donnateur;
    data["mode_paiement"] = this.modePaiement;
    data["datedetailbudget"] = this.datedetailbudget;
    data["registration_id"] = this.registrationId;
    return data;
  }
}
