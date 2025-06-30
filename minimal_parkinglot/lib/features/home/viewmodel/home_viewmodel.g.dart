// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchParkingLotsHash() => r'2b1b5c9ea7557b589eddd19df8493ca5c54fed07';

/// See also [fetchParkingLots].
@ProviderFor(fetchParkingLots)
final fetchParkingLotsProvider =
    AutoDisposeFutureProvider<List<ParkinglotModel>>.internal(
      fetchParkingLots,
      name: r'fetchParkingLotsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$fetchParkingLotsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchParkingLotsRef =
    AutoDisposeFutureProviderRef<List<ParkinglotModel>>;
String _$getVehicleByNFCHash() => r'ddf93bcf1aa0314a22d174b4b91d4e24e7638e56';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getVehicleByNFC].
@ProviderFor(getVehicleByNFC)
const getVehicleByNFCProvider = GetVehicleByNFCFamily();

/// See also [getVehicleByNFC].
class GetVehicleByNFCFamily extends Family<AsyncValue<VehicleModel>> {
  /// See also [getVehicleByNFC].
  const GetVehicleByNFCFamily();

  /// See also [getVehicleByNFC].
  GetVehicleByNFCProvider call(String nfcCardId) {
    return GetVehicleByNFCProvider(nfcCardId);
  }

  @override
  GetVehicleByNFCProvider getProviderOverride(
    covariant GetVehicleByNFCProvider provider,
  ) {
    return call(provider.nfcCardId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getVehicleByNFCProvider';
}

/// See also [getVehicleByNFC].
class GetVehicleByNFCProvider extends AutoDisposeFutureProvider<VehicleModel> {
  /// See also [getVehicleByNFC].
  GetVehicleByNFCProvider(String nfcCardId)
    : this._internal(
        (ref) => getVehicleByNFC(ref as GetVehicleByNFCRef, nfcCardId),
        from: getVehicleByNFCProvider,
        name: r'getVehicleByNFCProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$getVehicleByNFCHash,
        dependencies: GetVehicleByNFCFamily._dependencies,
        allTransitiveDependencies:
            GetVehicleByNFCFamily._allTransitiveDependencies,
        nfcCardId: nfcCardId,
      );

  GetVehicleByNFCProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nfcCardId,
  }) : super.internal();

  final String nfcCardId;

  @override
  Override overrideWith(
    FutureOr<VehicleModel> Function(GetVehicleByNFCRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetVehicleByNFCProvider._internal(
        (ref) => create(ref as GetVehicleByNFCRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nfcCardId: nfcCardId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<VehicleModel> createElement() {
    return _GetVehicleByNFCProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetVehicleByNFCProvider && other.nfcCardId == nfcCardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nfcCardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetVehicleByNFCRef on AutoDisposeFutureProviderRef<VehicleModel> {
  /// The parameter `nfcCardId` of this provider.
  String get nfcCardId;
}

class _GetVehicleByNFCProviderElement
    extends AutoDisposeFutureProviderElement<VehicleModel>
    with GetVehicleByNFCRef {
  _GetVehicleByNFCProviderElement(super.provider);

  @override
  String get nfcCardId => (origin as GetVehicleByNFCProvider).nfcCardId;
}

String _$homeViewmodelHash() => r'3f30611699648ff66cd619dbd3c13f241d30fdc5';

/// See also [HomeViewmodel].
@ProviderFor(HomeViewmodel)
final homeViewmodelProvider = AutoDisposeNotifierProvider<
  HomeViewmodel,
  AsyncValue<VehicleModel>?
>.internal(
  HomeViewmodel.new,
  name: r'homeViewmodelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homeViewmodelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewmodel = AutoDisposeNotifier<AsyncValue<VehicleModel>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
