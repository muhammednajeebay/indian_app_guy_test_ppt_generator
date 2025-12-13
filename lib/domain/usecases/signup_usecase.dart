import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<Failure, User>> call(SignupParams params) async {
    return await repository.signup(params.email, params.password);
  }
}

class SignupParams extends Equatable {
  final String email;
  final String password;

  const SignupParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
