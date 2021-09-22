import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/detail_budget_model.dart';

class BudgetListResponseModel {
  String status;
  String message;
  int isAdmin;
  Information information;

  BudgetListResponseModel({
    this.status,
    this.message,
    this.isAdmin,
    this.information,
  });

  BudgetListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.isAdmin = json["is_admin"];
    this.information = json["information"] == null
        ? null
        : Information.fromJson(json["information"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    data["is_admin"] = this.isAdmin;
    if (this.information != null)
      data["information"] = this.information.toJson();
    return data;
  }
}

class Information {
  List<AllDatas> allDatas;
  List<NatureDons> natureDons;
  List<ModePaiement> modePaiement;
  List<CentreModel> centers;

  Information(
      {this.allDatas, this.natureDons, this.modePaiement, this.centers});

  Information.fromJson(Map<String, dynamic> json) {
    this.allDatas = json["all_datas"] == null
        ? null
        : (json["all_datas"] as List).map((e) => AllDatas.fromJson(e)).toList();
    this.natureDons = json["nature_dons"] == null
        ? null
        : (json["nature_dons"] as List)
            .map((e) => NatureDons.fromJson(e))
            .toList();
    this.modePaiement = json["mode_paiement"] == null
        ? null
        : (json["mode_paiement"] as List)
            .map((e) => ModePaiement.fromJson(e))
            .toList();
    this.centers = json["centers"] == null
        ? null
        : (json["centers"] as List)
            .map((e) => CentreModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allDatas != null)
      data["all_datas"] = this.allDatas.map((e) => e.toJson()).toList();
    if (this.natureDons != null)
      data["nature_dons"] = this.natureDons.map((e) => e.toJson()).toList();
    if (this.modePaiement != null)
      data["mode_paiement"] = this.modePaiement.map((e) => e.toJson()).toList();
    if (this.centers != null)
      data["centers"] = this.centers.map((e) => e.toJson()).toList();
    return data;
  }
}

class ModePaiement {
  int id;
  String libelle;

  ModePaiement({
    this.id,
    this.libelle,
  });

  ModePaiement.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.libelle = json["libelle"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["libelle"] = this.libelle;
    return data;
  }
}

class NatureDons {
  int id;
  String libelle;
  String keynaturebudget;

  NatureDons({
    this.id,
    this.libelle,
    this.keynaturebudget,
  });

  NatureDons.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.libelle = json["libelle"];
    this.keynaturebudget = json["keynaturebudget"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["libelle"] = this.libelle;
    data["keynaturebudget"] = this.keynaturebudget;
    return data;
  }
}

class AllDatas {
  String keyCenter;
  String centreName;
  int budgetRecu;
  int budgetPrevision;
  List<DetailBudgetModel> datas;

  AllDatas({
    this.keyCenter,
    this.centreName,
    this.budgetRecu,
    this.budgetPrevision,
    this.datas,
  });

  AllDatas.fromJson(Map<String, dynamic> json) {
    this.keyCenter = json["key_center"];
    this.centreName = json["centre_name"];
    this.budgetRecu = json["budget_recu"];
    this.budgetPrevision = json["budget_prevision"];
    this.datas = json["datas"] == null
        ? null
        : (json["datas"] as List)
            .map((e) => DetailBudgetModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["key_center"] = this.keyCenter;
    data["centre_name"] = this.centreName;
    data["budget_recu"] = this.budgetRecu;
    data["budget_prevision"] = this.budgetPrevision;
    if (this.datas != null)
      data["datas"] = this.datas.map((e) => e.toJson()).toList();
    return data;
  }
}
