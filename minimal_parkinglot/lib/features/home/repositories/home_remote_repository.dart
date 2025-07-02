import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:minimal_parkinglot/core/constants/server.dart';
import 'package:minimal_parkinglot/features/auth/model/failure_message.dart';
import 'package:minimal_parkinglot/features/home/model/parkinglot_model.dart';
import 'package:minimal_parkinglot/features/home/model/vehicle_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_remote_repository.g.dart';

@riverpod
HomeRemoteRepository homeRemoteRepository(Ref ref) {
  return HomeRemoteRepository();
}

class HomeRemoteRepository {
  // This class will handle the remote logic for the home feature.
  // For example, it could interact with an API to fetch parking lot data.

  // Currently, this class is empty and can be expanded later as needed.
  Future<Either<FailureMessage, List<ParkinglotModel>>> fetchParkingLots({
    required accessToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.baseUrl}/parkingLot/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final parkingLotsData =
            (jsonDecode(response.body) as Map<String, dynamic>)['data'];
        final List<ParkinglotModel> parkingLots =
            (parkingLotsData as List)
                .map(
                  (data) =>
                      ParkinglotModel.fromMap(data as Map<String, dynamic>),
                )
                .toList();
        return Right(parkingLots);
      } else {
        return Left(FailureMessage('Failed to fetch parking lots'));
      }
    } catch (e) {
      return Left(FailureMessage(e.toString()));
    }
  }

  Future<Either<FailureMessage, VehicleModel>> addNewVehicle({
    required accessToken,
    required File checkInImages,
    // ignore: non_constant_identifier_names
    required String license_plate,
    required String parkingLotId,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${ServerConstants.baseUrl}/parkingLot/$parkingLotId/newVehicle',
        ),
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath(
            'checkInImages',
            checkInImages.path,
          ),
        ])
        ..fields['license_plate'] = license_plate
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $accessToken',
        });

      final response = await request.send();

      if (response.statusCode == 201) {
        final resBodyMap =
            jsonDecode(await response.stream.bytesToString())
                as Map<String, dynamic>;
        print(resBodyMap['data']);
        return Right(VehicleModel.fromMap(resBodyMap['data']));
      } else {
        return Left(FailureMessage(await response.stream.bytesToString()));
      }
    } catch (e) {
      print(e.toString());
      return Left(FailureMessage(e.toString()));
    }
  }

  Future<Either<FailureMessage, VehicleModel>> getVehicleByNFC({
    required nfcCardId,
    required accessToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.baseUrl}/parkingLot/nfc/$nfcCardId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode != 200) {
        final errorReponse = jsonDecode(response.body) as Map<String, dynamic>;
        print('errorResponse: $errorReponse');
        return Left(FailureMessage(errorReponse['message']));
      } else {
        final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
        print(resBodyMap['data']);
        final vehicle = VehicleModel.fromMap(resBodyMap['data']);
        return Right(vehicle);
      }
    } catch (e) {
      print(e.toString());
      return Left(FailureMessage(e.toString()));
    }
  }

  Future<Either<FailureMessage, void>> deleteVehicle({
    required String accessToken,
    required int vehicleId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${ServerConstants.baseUrl}/parkingLot/deleteVehicle/$vehicleId',
        ),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return const Right(null); // Thành công, không cần trả về gì
      } else {
        return Left(FailureMessage(jsonDecode(response.body)['message']));
      }
    } catch (e) {
      return Left(FailureMessage(e.toString()));
    }
  }

  Future<Either<FailureMessage, void>> checkOutVehicle({
    required String accessToken,
    required String nfcCardId,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ServerConstants.baseUrl}/parkingLot/checkout/$nfcCardId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        print('Đã Checkout Thành công');
        return const Right(null); // Thành công, không cần trả về gì
      } else {
        return Left(FailureMessage(jsonDecode(response.body)['message']));
      }
    } catch (e) {
      return Left(FailureMessage(e.toString()));
    }
  }
}
