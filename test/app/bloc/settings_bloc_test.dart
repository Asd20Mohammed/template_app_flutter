// Validates that settings bloc persists and emits updates correctly.
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/src/core/constants/app_constants.dart';
import 'package:template_app/src/features/settings/domain/repositories/settings_repository.dart';
import 'package:template_app/src/features/settings/domain/usecases/settings_usecases.dart';
import 'package:template_app/src/features/settings/presentation/bloc/settings_bloc.dart';

class _FakeSettingsRepository implements SettingsRepository {
  final Map<String, Object> _storage = {};

  @override
  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    return _storage[key] as bool? ?? defaultValue;
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> readString(String key) async {
    return _storage[key] as String?;
  }

  @override
  Future<void> writeString(String key, String value) async {
    _storage[key] = value;
  }
}

void main() {
  group('SettingsBloc', () {
    late _FakeSettingsRepository repository;
    late SettingsBloc bloc;

    setUp(() {
      repository = _FakeSettingsRepository();
      bloc = SettingsBloc(
        readBoolSettingUseCase: ReadBoolSettingUseCase(repository),
        writeBoolSettingUseCase: WriteBoolSettingUseCase(repository),
        readStringSettingUseCase: ReadStringSettingUseCase(repository),
        writeStringSettingUseCase: WriteStringSettingUseCase(repository),
      );
    });

    blocTest<SettingsBloc, SettingsState>(
      'loads stored values on initialization',
      build: () => bloc,
      act: (bloc) async {
        await repository.writeBool(
          AppConstants.notificationPreferenceKey,
          false,
        );
        await repository.writeString(AppConstants.localePreferenceKey, 'ar');
        bloc.add(const SettingsInitialized());
      },
      expect: () => [
        const SettingsState(
          notificationsEnabled: false,
          localeCode: 'ar',
          textScale: 1.0,
          layoutScale: 1.0,
        ),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'updates locale when changed',
      build: () => bloc,
      act: (bloc) => bloc.add(const SettingsLocaleChanged('ar')),
      expect: () => [
        const SettingsState(
          notificationsEnabled: true,
          localeCode: 'ar',
          textScale: 1.0,
          layoutScale: 1.0,
        ),
      ],
    );
  });
}
