class TacheDto {
  /// Cle de l'API du serveur
  String accessToken;

  /// authKey de l'utilisateur en cours
  String uIdentifiant;

  /// Id du centre
  int idCentre;

  /// Key du personnel concerne
  String pIdentifiant;

  ///Date et heure de rappel pour le concerne
  String description;

  ///Date et heure de la tahce
  String dateTache;
  String dateRappel;

  ///Rapport sur la tache
  String rapportTache;

  /// 1 pour l'ajout, 2 pour la modification
  int operation;

  /// key de la tache a modifier les
  String tacheKey;

  /// utilie pour reevoir les notifications
  String registrationId;

  TacheDto({
    this.accessToken,
    this.uIdentifiant,
    this.idCentre,
    this.pIdentifiant,
    this.description,
    this.dateTache,
    this.dateRappel,
    this.rapportTache,
    this.operation,
    this.tacheKey,
    this.registrationId,
  });

  TacheDto.fromJson(Map<String, dynamic> json) {
    this.accessToken = json["access_token"];
    this.uIdentifiant = json["u_identifiant"];
    this.idCentre = json["id_center"];
    this.pIdentifiant = json["p_identifiant"];
    this.description = json["description"];
    this.dateTache = json["date_tache"];
    this.dateRappel = json["date_rappel"];
    this.rapportTache = json["rapport_tache"];
    this.operation = json["operation"];
    this.tacheKey = json["tache_key"];
    this.registrationId = json["registration_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["u_identifiant"] = this.uIdentifiant;
    data["id_center"] = this.idCentre;
    data["p_identifiant"] = this.pIdentifiant;
    data["description"] = this.description;
    data["date_tache"] = this.dateTache;
    data["date_rappel"] = this.dateRappel;
    data["rapport_tache"] = this.rapportTache;
    data["operation"] = this.operation;
    data["tache_key"] = this.tacheKey;
    return data;
  }
}
