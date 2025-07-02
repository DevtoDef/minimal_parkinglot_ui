import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:minimal_parkinglot/core/providers/current_user_provider.dart';
import 'package:minimal_parkinglot/features/home/model/parkinglot_model.dart';
import 'package:minimal_parkinglot/features/home/model/vehicle_model.dart';
import 'package:minimal_parkinglot/features/home/repositories/home_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<ParkinglotModel>> fetchParkingLots(Ref ref) async {
  final accessToken = ref.watch(
    currentUserNotifierProvider.select((user) => user!.accessToken),
  );
  final result = await ref
      .watch(homeRemoteRepositoryProvider)
      .fetchParkingLots(accessToken: accessToken);
  return switch (result) {
    Left(value: final l) => throw Exception(l.message),
    Right(value: final r) => r,
  };
}

@riverpod
Future<VehicleModel> getVehicleByNFC(Ref ref, String nfcCardId) async {
  final accessToken = ref.watch(
    currentUserNotifierProvider.select((user) => user!.accessToken),
  );

  final result = await ref
      .watch(homeRemoteRepositoryProvider)
      .getVehicleByNFC(nfcCardId: nfcCardId, accessToken: accessToken);
  return switch (result) {
    Left(value: final l) => throw Exception(l.message),
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRemoteRepository _homeRemoteRepository;
  @override
  AsyncValue<VehicleModel>? build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    return null;
  }

  Future<void> addNewVehicle({
    required File checkInImages,
    // ignore: non_constant_identifier_names
    required String license_plate,
    required String parkingLotId,
  }) async {
    state = const AsyncLoading();
    final accessToken = ref.read(currentUserNotifierProvider)!.accessToken;
    final result = await _homeRemoteRepository.addNewVehicle(
      accessToken: accessToken,
      checkInImages: checkInImages,
      license_plate: license_plate,
      parkingLotId: parkingLotId,
    );
    state = switch (result) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
  }

  Future<void> cancelCheckIn({required int vehicleId}) async {
    final accessToken = ref.read(currentUserNotifierProvider)!.accessToken;
    await _homeRemoteRepository.deleteVehicle(
      accessToken: accessToken,
      vehicleId: vehicleId,
    );
    // Không cần thay đổi state ở đây, vì đây là một hành động nền
  }
}
