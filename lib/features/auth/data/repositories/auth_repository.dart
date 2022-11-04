import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nexus_estoque/core/constants/config.dart';
import 'package:nexus_estoque/core/constants/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/auth/model/user_model.dart';

class AuthRepository {
  late Dio dio;
  final String url = Config.baseURL!;
  final options = DioConfig.dioBaseOption;

  AuthRepository() {
    dio = Dio(options);
  }

  Future<Either<Failure, User>> auth(String username, String password) async {
    late dynamic response;
    try {
      response = await dio.post('$url/api/oauth2/v1/token', queryParameters: {
        'username': username,
        'password': password,
        'grant_type': "password"
      });

      if (response.statusCode == 201) {
        final user = User.fromMap(response.data);

        Map<String, dynamic> decodedToken = JwtDecoder.decode(user.accessToken);

        final String userId = decodedToken['userid'];

        final data = await getUser(userId);

        return data.fold((l) {
          return Left(l);
        }, (r) {
          user.id = userId;
          user.userName = r['userName'];
          user.displayName = r['displayName'];
          return Right(user);
        });
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    } on DioError catch (e) {
      log('auth ${e.type.name}');

      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }

      if (e.type.name == "receiveTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }

      if (e.response?.statusCode == 401) {
        return const Left(
            Failure('Usuário ou senha inválido.', ErrorType.validation));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getUser(String userId) async {
    late dynamic response;
    try {
      response = await dio.get('$url/api/framework/v1/users/$userId');

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      return Right({
        'userName': response.data['userName'],
        'displayName': response.data['displayName']
      });
    } on DioError catch (e) {
      log('getUser ${e.type.name}');
      if (e.type.name == "connectTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      if (e.type.name == "receiveTimeout") {
        return const Left(Failure("Tempo Excedido", ErrorType.timeout));
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    }
  }
}
