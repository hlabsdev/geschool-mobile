/// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';

/// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
import 'package:geschool/core/error/Failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => null;
}
