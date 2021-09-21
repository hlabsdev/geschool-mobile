import 'package:geschool/features/common/data/models/basemodels/anneescolaire_model.dart';
import 'package:geschool/features/common/data/models/basemodels/centre_model.dart';
import 'package:geschool/features/common/data/models/basemodels/evaluation_model.dart';

class EvaluationListResponseModel {
  String status;
  String message;
  Information information;

  EvaluationListResponseModel({
    this.status,
    this.message,
    this.information,
  });

  EvaluationListResponseModel.fromJson(Map<String, dynamic> json) {
    this.status = json["status"];
    this.message = json["message"];
    this.information = json["information"] == null
        ? null
        : Information.fromJson(json["information"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["message"] = this.message;
    if (this.information != null)
      data["information"] = this.information.toJson();
    return data;
  }
}

class Information {
  List<Centres> centres;
  List<EvaluationModel> evaluations;
  List<AnneeScolaireModel> anneeScolaires;

  Information({this.centres, this.evaluations, this.anneeScolaires});

  Information.fromJson(Map<String, dynamic> json) {
    this.centres = json["centres"] == null
        ? null
        : (json["centres"] as List).map((e) => Centres.fromJson(e)).toList();
    this.evaluations = json["evaluations"] == null
        ? null
        : (json["evaluations"] as List)
            .map((e) => EvaluationModel.fromJson(e))
            .toList();
    this.anneeScolaires = json["annee_scolaires"] == null
        ? null
        : (json["annee_scolaires"] as List)
            .map((e) => AnneeScolaireModel.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.centres != null)
      data["centres"] = this.centres.map((e) => e.toJson()).toList();
    if (this.evaluations != null)
      data["evaluations"] = this.evaluations.map((e) => e.toJson()).toList();
    if (this.anneeScolaires != null)
      data["annee_scolaires"] =
          this.anneeScolaires.map((e) => e.toJson()).toList();
    return data;
  }
}
