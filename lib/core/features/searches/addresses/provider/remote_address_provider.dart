import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/model/address_model.dart';
import 'package:nexus_estoque/core/features/searches/addresses/data/repositories/address_repository.dart';

final remoteAddressProvider = FutureProvider<List<AddressModel>>((ref) async {
  final result = await ref.read(addressRepository).fetchAddress();
  return result;
});
