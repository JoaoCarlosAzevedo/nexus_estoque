import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nexus_estoque/core/http/config.dart';
import 'package:nexus_estoque/core/http/dio_config.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/core/http/http_provider.dart';
import 'package:nexus_estoque/features/auth/model/user_model.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref));

class AuthRepository {
  final Ref _ref;
  //late Dio dio;
  final options = DioConfig.dioBaseOption;
  final _storage = const FlutterSecureStorage();

  AuthRepository(this._ref) {
    //dio = Dio(options);
  }

  Future<Either<Failure, UserModel>> auth(
      String username, String password) async {
    final String url = await Config.baseURL;
    late dynamic response;
    final dio = _ref.read(httpProvider).dioInstance;
    try {
      response = await dio.post('$url/api/oauth2/v1/token', queryParameters: {
        'username': username,
        'password': password,
        'grant_type': "password"
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        final user = UserModel.fromMap(response.data);

        await _storage.write(key: 'access_token', value: user.accessToken);
        await _storage.write(key: 'refresh_token', value: user.refreshToken);

        Map<String, dynamic> decodedToken = JwtDecoder.decode(user.accessToken);
        final String userId = decodedToken['userid'];

        final data = await getUser(userId);

        return data.fold((l) {
          return Left(l);
        }, (r) {
          final List<String> menus = List<String>.from(r['menus'] as List);
          user.id = userId;
          user.userName = r['nome'];
          user.displayName = r['nome'];
          user.title = r['cargo'];
          user.menus = menus;

          return Right(user);
        });
      }
      return const Left(Failure("Server Error!", ErrorType.exception));
    } on DioException catch (e) {
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
    final dio = _ref.read(httpProvider).dioInstance;
    final String url = await Config.baseURL;
    try {
      response = await dio.get('$url/filial/$userId');

      if (response.statusCode != 200) {
        return const Left(Failure("Server Error!", ErrorType.exception));
      }

      return Right({
        'nome': response.data['nome'],
        'cargo': response.data['cargo'],
        'menus': response.data['menu'] ?? []
      });
    } on DioException catch (e) {
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
