import 'package:dartz/dartz.dart';
import 'package:geschool/core/error/Failure.dart';
import 'package:geschool/features/common/data/dto/add_abs_dto.dart';
import 'package:geschool/features/common/data/dto/add_budget_dto.dart';
import 'package:geschool/features/common/data/dto/add_note_dto.dart';
import 'package:geschool/features/common/data/dto/add_permission_dto.dart';
import 'package:geschool/features/common/data/dto/apprenant_eval_dto.dart';
import 'package:geschool/features/common/data/dto/change_mdp_dto.dart';
import 'package:geschool/features/common/data/dto/connection_dto.dart';
import 'package:geschool/features/common/data/dto/get_eleve_classe_dto.dart';
import 'package:geschool/features/common/data/dto/get_info_dto%20copy.dart';
import 'package:geschool/features/common/data/dto/get_info_dto.dart';
import 'package:geschool/features/common/data/dto/inscription_dto.dart';
import 'package:geschool/features/common/data/dto/reset_password_dto.dart';
import 'package:geschool/features/common/data/dto/tache_dto.dart';
import 'package:geschool/features/common/data/dto/validate_perm_dto.dart';
import 'package:geschool/features/common/data/models/basemodels/menu_list_model.dart';
import 'package:geschool/features/common/data/models/respmodels/absence_apprenant_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/absence_personnel_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/add_note_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/affectation_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/app_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/apprenant_eval_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/apprenant_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/budget_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/bulletin_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/centre_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/classe_eleve_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/classe_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/conduite_list_reponse_model.dart';
import 'package:geschool/features/common/data/models/respmodels/evaluation_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/mission_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/note_apprenant_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/permission_apprenant_reponse_model.dart';
import 'package:geschool/features/common/data/models/respmodels/personnel_list_response_model.dart';
import 'package:geschool/features/common/data/models/respmodels/tache_list_response_model.dart';

abstract class Api {
  /*Gestion des Registrations debut*/
  Future<Either<Failure, AppResponseModel>> signin(ConnectionDto connectionDto);

  Future<Either<Failure, AppResponseModel>> register(
      InscriptionDto inscriptionDto);

  Future<Either<Failure, AppResponseModel>> confirmRegistration(
      ConnectionDto connectionDto);

  Future<Either<Failure, AppResponseModel>> updatePassword(
      ChangeMdpDto changeMdpDto);

  Future<Either<Failure, AppResponseModel>> forgetPassword(
      ResetPasswordDto forgetPasswordDto);

  Future<Either<Failure, AppResponseModel>> resetPassword(
      ResetPasswordDto resetPasswordDto);

  Future<Either<Failure, AppResponseModel>> updateProfil(
      InscriptionDto inscriptionDto);

  Future<Either<Failure, AppResponseModel>> updateProfilPicture(
      InscriptionDto photoDto);

  Future<Either<Failure, AppResponseModel>> getUserInfo(GetInfoDto infoDto);

  /*Gestion des Registrations fin*/

/* List deb */
  Future<Either<Failure, MissionListResponseModel>> getMissions(
      GetInfoDto infoDto);

  Future<Either<Failure, AbsencePersonnelListResponseModel>>
      getPersonnelAbsences(GetInfoDto infoDto);

  Future<Either<Failure, AbsenceApprenantListResponseModel>>
      getApprenantAbsences(GetInfoDto infoDto);

  Future<Either<Failure, TacheListResponseModel>> getTaches(GetInfoDto infoDto);

  Future<Either<Failure, PersonnelListResponseModel>> getPersonnels(
      GetInfoDto infoDto);

  Future<Either<Failure, TacheListResponseModel>> sendTache(TacheDto tacheDto);

  Future<Either<Failure, NoteApprenantListResponseModel>> getStudentNotes(
      GetInfoDto infoDto);

  Future<Either<Failure, EvaluationListResponseModel>> getEvaluations(
      GetInfoDto infoDto);

  Future<Either<Failure, ApprenantEvalResponseModel>> getApprenantsEval(
      ApprenantEvalDto apprenantDto);

  Future<Either<Failure, OkResponseModel>> sendNotes(AddNoteDto addNoteDto);

  Future<Either<Failure, AffectationListResponseModel>> getAffectations(
      GetInfoDto infoDto);

  Future<Either<Failure, CentreResponseModel>> getCentre(GetInfoDto infoDto);

  Future<Either<Failure, ConduiteListResponseModel>> getConduites(
      GetInfoDto infoDto);

  Future<Either<Failure, BulletinListResponseModel>> getBulletins(
      GetInfoDto infoDto);

  Future<Either<Failure, OkResponseModel>> getBulletinLink(
      GetBulletinLinkDto getBulletinLinkDto);

  Future<Either<Failure, ClasseListResponseModel>> getClasses(
      GetInfoDto infoDto);

  Future<Either<Failure, ClasseEleveListResponseModel>> getApprenantsClasse(
      GetEleveClasseDto infoDto);

  Future<Either<Failure, OkResponseModel>> sendAbsence(AddAbsDto infoDto);

  Future<Either<Failure, MenuListModel>> getMenus(GetInfoDto infoDto);
/* Permission apprenant deb */
  Future<Either<Failure, PermissionApprenantReponseModel>> getPerms(
      GetInfoDto infoDto);
  Future<Either<Failure, PermissionApprenantReponseModel>> sendPerm(
      AddPermissionDto permDto);
  Future<Either<Failure, OkResponseModel>> validatePerm(
      ValidatePermDto infoDto);
  Future<Either<Failure, ApprenantListResponseModel>> getAprenants(
      GetInfoDto infoDto);
/* Permission apprenant end */

/* Budget deb */
  Future<Either<Failure, BudgetListResponseModel>> getBudgets(
      GetInfoDto infoDto);
  Future<Either<Failure, OkResponseModel>> sendBudget(AddBudgetDto infoDto);
  Future<Either<Failure, BudgetListResponseModel>> validateBudget(
      GetInfoDto infoDto);
/* Budget end */

/* End */
}
