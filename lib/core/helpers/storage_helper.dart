import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static StorageHelper? _instance;
  static SharedPreferences? _preferences;

  static StorageHelper get instance {
    _instance ??= StorageHelper._internal();
    return _instance!;
  }

  StorageHelper._internal();

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Ensure preferences are initialized
  Future<SharedPreferences> get _prefs async {
    if (_preferences == null) {
      await init();
    }
    return _preferences!;
  }

  // String operations
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final prefs = await _prefs;
    return prefs.setString(key, value);
  }

  // Int operations
  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    final prefs = await _prefs;
    return prefs.setInt(key, value);
  }

  // Double operations
  Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) async {
    final prefs = await _prefs;
    return prefs.setDouble(key, value);
  }

  // Bool operations
  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    final prefs = await _prefs;
    return prefs.setBool(key, value);
  }

  // List<String> operations
  Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    return prefs.setStringList(key, value);
  }

  // Remove operations
  Future<bool> remove(String key) async {
    final prefs = await _prefs;
    return prefs.remove(key);
  }

  // Clear all data
  Future<bool> clear() async {
    final prefs = await _prefs;
    return prefs.clear();
  }

  // Check if key exists
  Future<bool> containsKey(String key) async {
    final prefs = await _prefs;
    return prefs.containsKey(key);
  }

  // Get all keys
  Future<Set<String>> getKeys() async {
    final prefs = await _prefs;
    return prefs.getKeys();
  }

  // Reload preferences
  Future<void> reload() async {
    final prefs = await _prefs;
    await prefs.reload();
  }

  // Helper methods for common operations

  // Save user session data
  Future<bool> saveUserSession({
    required String token,
    required String userId,
    String? userEmail,
    String? userName,
  }) async {
    try {
      await setString('auth_token', token);
      await setString('user_id', userId);
      if (userEmail != null) await setString('user_email', userEmail);
      if (userName != null) await setString('user_name', userName);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Clear user session data
  Future<bool> clearUserSession() async {
    try {
      await remove('auth_token');
      await remove('user_id');
      await remove('user_email');
      await remove('user_name');
      await remove('user_data');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    final token = await getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Get auth token
  Future<String?> getAuthToken() async {
    return await getString('auth_token');
  }

  // Save app settings
  Future<bool> saveAppSettings({
    String? language,
    String? theme,
    bool? notificationsEnabled,
    bool? locationEnabled,
  }) async {
    try {
      if (language != null) await setString('app_language', language);
      if (theme != null) await setString('app_theme', theme);
      if (notificationsEnabled != null) {
        await setBool('notifications_enabled', notificationsEnabled);
      }
      if (locationEnabled != null) {
        await setBool('location_enabled', locationEnabled);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get app settings
  Future<Map<String, dynamic>> getAppSettings() async {
    return {
      'language': await getString('app_language') ?? 'en',
      'theme': await getString('app_theme') ?? 'system',
      'notifications_enabled': await getBool('notifications_enabled') ?? true,
      'location_enabled': await getBool('location_enabled') ?? false,
    };
  }

  // Save search history
  Future<bool> addToSearchHistory(String query) async {
    try {
      final history = await getStringList('search_history') ?? [];

      // Remove if already exists to avoid duplicates
      history.remove(query);

      // Add to beginning
      history.insert(0, query);

      // Keep only last 20 searches
      if (history.length > 20) {
        history.removeRange(20, history.length);
      }

      return await setStringList('search_history', history);
    } catch (e) {
      return false;
    }
  }

  // Get search history
  Future<List<String>> getSearchHistory() async {
    return await getStringList('search_history') ?? [];
  }

  // Clear search history
  Future<bool> clearSearchHistory() async {
    return await remove('search_history');
  }

  // Save recently viewed products
  Future<bool> addToRecentlyViewed(String productId) async {
    try {
      final recent = await getStringList('recently_viewed') ?? [];

      // Remove if already exists
      recent.remove(productId);

      // Add to beginning
      recent.insert(0, productId);

      // Keep only last 50 products
      if (recent.length > 50) {
        recent.removeRange(50, recent.length);
      }

      return await setStringList('recently_viewed', recent);
    } catch (e) {
      return false;
    }
  }

  // Get recently viewed products
  Future<List<String>> getRecentlyViewed() async {
    return await getStringList('recently_viewed') ?? [];
  }

  // Clear recently viewed
  Future<bool> clearRecentlyViewed() async {
    return await remove('recently_viewed');
  }
}
