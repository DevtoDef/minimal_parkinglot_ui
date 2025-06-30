import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:minimal_parkinglot/core/constants/server.dart';
import 'package:minimal_parkinglot/features/auth/model/failure_message.dart';
import 'package:minimal_parkinglot/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  // This class will handle the remote authentication logic.
  // For example, it could interact with an API to log in or register users.

  Future<Either<FailureMessage, UserModel>> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username':
              username, // Assuming username is the same as email for simplicity
          'password': password,
        }),
      );
      if (response.statusCode == 201) {
        final userDataMap =
            (jsonDecode(response.body) as Map<String, dynamic>)['data'];
        final user = UserModel.fromMap(userDataMap);
        return Right(user);
      } else {
        final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return Left(FailureMessage(errorResponse['message']));
      }
    } catch (e) {
      return Left(FailureMessage(e.toString()));
    }
  }

  Future<Either<FailureMessage, UserModel>> login({
    // Implement login logic here
    required String password,
    required String username,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        final userDataMap =
            (jsonDecode(response.body) as Map<String, dynamic>)['data'];
        final user = UserModel.fromMap(userDataMap);
        return Right(user);
      } else {
        final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return Left(FailureMessage(errorResponse['message']));
      }
    } catch (e) {
      return Left(FailureMessage(e.toString()));
    }
  }

  Future<Either<FailureMessage, UserModel>> getCurrentUserData(
    String accessToken,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.baseUrl}/auth/currentUser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final userDataMap =
            (jsonDecode(response.body) as Map<String, dynamic>)['data'];
        final user = UserModel.fromMap(userDataMap);
        final userWithToken = user.copyWith(accessToken: accessToken);
        return Right(userWithToken);
      } else {
        final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
        print('Error: ${errorResponse['message']}');
        return Left(FailureMessage(errorResponse['message']));
      }
    } catch (e) {
      return Left(FailureMessage(e.toString()));
    }
  }

  Future<void> logout() async {
    // Implement logout logic here
  }
}
