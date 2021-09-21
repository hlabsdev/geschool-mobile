import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:geschool/allTranslations.dart';
import 'package:geschool/core/error/Failure.dart';
import 'package:geschool/core/error/exception.dart';
import 'package:geschool/core/network/network_info.dart';
import 'package:geschool/core/utils/data_constantes_utils.dart';
import 'package:geschool/core/utils/preference.dart';
import 'package:geschool/features/common/data/datasources/remote/api.dart';
import 'package:geschool/features/common/data/dto/add_abs_dto.dart';
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

class ApiRepository implements Api {
  Dio dio;
  final NetworkInfo networkInfo =
      new NetworkInfoImpl(new DataConnectionChecker());
  String defaultServer =
      UserPreferences().defaultServer == allTranslations.text('local')
          ? json.decode(UserPreferences().localServer)
          : json.decode(UserPreferences().onlineServer);

  ApiRepository() {
    // or new Dio with a BaseOptions instance.
    BaseOptions options = new BaseOptions(
        // baseUrl: "$SERVER_URL",
        baseUrl: defaultServer,
        receiveDataWhenStatusError: true,
        connectTimeout: 20 * 1000, // 20 seconds,
        receiveTimeout: 20 * 1000 // 20 seconds
        );
    dio = new Dio(options);
  }

  Future<Dio> getApiClient() async {
    var accesToken = "SzrQt6TazKv2ayDHqs754qvvAvD";
    dio.interceptors.clear();
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // Do something before request is sent
      options.headers["Authorization"] = "Bearersend_message " + accesToken;
      return options;
    }, onResponse: (Response response) {
      // Do something with response data
      return response; // continue
    }, onError: (DioError error) async {
      // Do something with response error
      if (error.response.statusCode == 403) {
        dio.interceptors.requestLock.lock();
        dio.interceptors.responseLock.lock();
        RequestOptions options = error.response.request;
        //refresh acces_token
        //acces_token = await user.getIdToken(refresh: true);

        options.headers["Authorization"] = "Bearer " + accesToken;

        dio.interceptors.requestLock.unlock();
        dio.interceptors.responseLock.unlock();
        return dio.request(options.path, options: options);
      } else {
        return error;
      }
    }));
    //dio.options.baseUrl = baseUrl;
    return dio;
  }

  @override
  Future<Either<Failure, AppResponseModel>> signin(
      ConnectionDto connectionDto) async {
    if (await networkInfo.isConnected) {
      try {
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        connectionDto.accessToken = accesToken;
        FormData formData = new FormData.fromMap(connectionDto.toJson());
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.LOGIN_SERVER_URL.toString())
            .toString();
        var response = await dio.post(finalUrl, data: formData);
        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AppResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppResponseModel>> register(
      InscriptionDto inscriptionDto) async {
    if (await networkInfo.isConnected) {
      try {
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        inscriptionDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(inscriptionDto.toJson());

        var response = await dio
            .post(DataConstantesUtils.INSCRIPTION_SERVER_URL, data: formData);

        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AppResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppResponseModel>> confirmRegistration(
      ConnectionDto connectionDto) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AppResponseModel>> forgetPassword(
      ResetPasswordDto forgetPasswordDto) async {
    if (await networkInfo.isConnected) {
      try {
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        forgetPasswordDto.accessToken = accesToken;
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.FORGET_PSSWD_SERVER_URL.toString())
            .toString();
        FormData formData = new FormData.fromMap(forgetPasswordDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AppResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppResponseModel>> resetPassword(
      ResetPasswordDto resetPasswordDto) async {
    if (await networkInfo.isConnected) {
      try {
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        resetPasswordDto.accessToken = accesToken;
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.RESET_PSSWD_SERVER_URL.toString())
            .toString();
        FormData formData = new FormData.fromMap(resetPasswordDto.toJson());

        var response = await dio.post(finalUrl, data: formData);
        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AppResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppResponseModel>> updatePassword(
      ChangeMdpDto changeMdpDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.UPDATE_PSSWD_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        changeMdpDto.accessToken = accesToken;
        FormData formData = new FormData.fromMap(changeMdpDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AppResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppResponseModel>> updateProfilPicture(
      InscriptionDto photoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        photoDto.accessToken = accesToken;
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.UPDATE_PROFIL_PIC_SERVER_URL.toString())
            .toString();

        Map<String, dynamic> fullInfo = photoDto.toJson();
        FormData formData = new FormData.fromMap(fullInfo);

        if (photoDto.photo.compareTo("0") != 0) {
          formData.files.addAll([
            MapEntry(
                "photo",
                MultipartFile.fromFileSync(
                    "./${photoDto.photo}" /*, filename: "photo.jpg"*/))
          ]);
        }
        var response = await dio.post(finalUrl, data: formData);

        var data = response.toString();

        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AppResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppResponseModel>> updateProfil(
      InscriptionDto inscriptionDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.UPDATE_PROFIL_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        inscriptionDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(inscriptionDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AppResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AppResponseModel>> getUserInfo(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.USER_INFO_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AppResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, MissionListResponseModel>> getMissions(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_MISSIONS_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;
        FormData formData = new FormData.fromMap(infoDto.toJson());
        var response = await dio.post(finalUrl, data: formData);
        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);

        return Right((MissionListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AbsencePersonnelListResponseModel>>
      getPersonnelAbsences(GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_ABSENCES_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;
        FormData formData = new FormData.fromMap(infoDto.toJson());
        var response = await dio.post(finalUrl, data: formData);
        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);

        return Right((AbsencePersonnelListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AbsenceApprenantListResponseModel>>
      getApprenantAbsences(GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_ABSENCES_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;
        FormData formData = new FormData.fromMap(infoDto.toJson());
        var response = await dio.post(finalUrl, data: formData);
        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);

        return Right((AbsenceApprenantListResponseModel.fromJson(responseMap)));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, TacheListResponseModel>> getTaches(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_TACHES_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;
        FormData formData = new FormData.fromMap(infoDto.toJson());
        var response = await dio.post(finalUrl, data: formData);
        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);

        return Right((TacheListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, PersonnelListResponseModel>> getPersonnels(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.TACHE_USERS_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;
        FormData formData = new FormData.fromMap(infoDto.toJson());
        var response = await dio.post(finalUrl, data: formData);
        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);

        return Right((PersonnelListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, TacheListResponseModel>> sendTache(
      TacheDto tacheDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.NEW_TACHE_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        tacheDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(tacheDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((TacheListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, NoteApprenantListResponseModel>> getStudentNotes(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_NOTES_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((NoteApprenantListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ApprenantEvalResponseModel>> getApprenantsEval(
      ApprenantEvalDto apprenantDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.APPRENANT_EVALS_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        apprenantDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(apprenantDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((ApprenantEvalResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, EvaluationListResponseModel>> getEvaluations(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.NOTES_EVALS_SERVER_URL.toString())
            .toString();
        print(finalUrl);
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((EvaluationListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, OkResponseModel>> sendNotes(
      AddNoteDto addNoteDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.NEW_NOTE_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        addNoteDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(addNoteDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((OkResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, AffectationListResponseModel>> getAffectations(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_AFFECTATIONS_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((AffectationListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CentreResponseModel>> getCentre(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.CENTRE_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((CentreResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, BulletinListResponseModel>> getBulletins(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_BULLETIN_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((BulletinListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ConduiteListResponseModel>> getConduites(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_CONDUITE_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((ConduiteListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, OkResponseModel>> getBulletinLink(
      GetBulletinLinkDto getBulletinLinkDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.BULLETIN_LINK_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        getBulletinLinkDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(getBulletinLinkDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((OkResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ClasseListResponseModel>> getClasses(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_CLASSES_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((ClasseListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ClasseEleveListResponseModel>> getApprenantsClasse(
      GetEleveClasseDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.APPRENANT_CLASSE_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((ClasseEleveListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, OkResponseModel>> sendAbsence(
      AddAbsDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.NEW_ABSENCE_APPRENANT_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((OkResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, MenuListModel>> getMenus(GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.MENU_LIST_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((MenuListModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, PermissionApprenantReponseModel>> getPerms(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_PERMISSIONS_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((PermissionApprenantReponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, PermissionApprenantReponseModel>> sendPerm(
      AddPermissionDto permDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.NEW_PERMISSION_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        permDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(permDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((PermissionApprenantReponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, OkResponseModel>> validatePerm(
      ValidatePermDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.VALIDATE_AFFECTATIONS_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;

        FormData formData = new FormData.fromMap(infoDto.toJson());

        var response = await dio.post(finalUrl, data: formData);

        var data = response.data;
        print(data);
        Map<String, dynamic> responseMap = jsonDecode(data);
        return Right((OkResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ApprenantListResponseModel>> getAprenants(
      GetInfoDto infoDto) async {
    if (await networkInfo.isConnected) {
      try {
        var finalUrl = (defaultServer.toString() +
                DataConstantesUtils.ALL_APPRENANTS_SERVER_URL.toString())
            .toString();
        var accesToken = DataConstantesUtils.SERVER_TOKEN;
        infoDto.accessToken = accesToken;
        FormData formData = new FormData.fromMap(infoDto.toJson());
        var response = await dio.post(finalUrl, data: formData);
        var data = response.data;
        Map<String, dynamic> responseMap = jsonDecode(data);

        return Right((ApprenantListResponseModel.fromJson(responseMap)));
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.CONNECT_TIMEOUT) {
          throw Exception(allTranslations.text('connection_timeout'));
        } else if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw Exception(allTranslations.text('receive_timeout'));
        } else if (ex.type == DioErrorType.RESPONSE) {
          throw Exception(allTranslations.text('server_incorrect'));
        }
        throw Exception(ex.message);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }
  /* End */
}
