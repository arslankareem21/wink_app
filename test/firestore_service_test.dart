import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wink_app/presentation/provider/get_profile_providers.dart';

void main() {
  test('returns null for an empty user id before any Firestore access', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    AsyncValue<DocumentSnapshot?>? latestValue;
    container.listen<AsyncValue<DocumentSnapshot?>>(userDataProvider(''), (_, next) {
      latestValue = next;
    });

    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(latestValue, isNotNull);
    expect(latestValue!.hasValue, isTrue);
    expect(latestValue!.value, isNull);
  });
}
