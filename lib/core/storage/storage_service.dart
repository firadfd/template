import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final GetStorage _box = GetStorage();
  
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiryKey = 'expires_in';

  static const String _themeKey = 'theme_mode';
  static const String _langKey = 'lang_code';

  static const String _onboardedKey = 'has_onboarded';

  Future<void> saveTheme(String theme) async {
    await _box.write(_themeKey, theme);
  }

  bool hasOnboarded() {
    return _box.read<bool>(_onboardedKey) ?? false;
  }

  Future<void> setOnboarded() async {
    await _box.write(_onboardedKey, true);
  }

  String? getTheme() {
    return _box.read<String>(_themeKey);
  }

  Future<void> saveLanguage(String lang) async {
    await _box.write(_langKey, lang);
  }

  String? getLanguage() {
    return _box.read<String>(_langKey);
  }

  Future<void> saveTokens({required String accessToken, required String refreshToken, required int expiresIn}) async {
    await _box.write(_accessTokenKey, accessToken);
    await _box.write(_refreshTokenKey, refreshToken);
    // Add expiry timestamp based on current time + expires in
    final expiryTime = DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
    await _box.write(_expiryKey, expiryTime);
  }

  String? getAccessToken() {
    return _box.read<String>(_accessTokenKey);
  }

  String? getRefreshToken() {
    return _box.read<String>(_refreshTokenKey);
  }

  bool isAccessTokenExpired() {
    final expiry = _box.read<int>(_expiryKey);
    if (expiry == null) return true;
    return DateTime.now().millisecondsSinceEpoch > expiry;
  }

  Future<void> clearAuth() async {
    await _box.remove(_accessTokenKey);
    await _box.remove(_refreshTokenKey);
    await _box.remove(_expiryKey);
  }

  Future<void> clearAll() async {
    await _box.erase();
  }
}
