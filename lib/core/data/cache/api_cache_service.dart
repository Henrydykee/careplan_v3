/// A simple in-memory cache with TTL (time-to-live) support.
///
/// Usage:
///   final cache = ApiCacheService();
///   cache.put('k10_history', data, ttl: Duration(minutes: 5));
///   final cached = cache.get<List<Item>>('k10_history');
///   cache.invalidate('k10_history');          // single key
///   cache.invalidateGroup('assessment');       // all keys starting with prefix
class ApiCacheService {
  static final ApiCacheService instance = ApiCacheService._internal();
  factory ApiCacheService() => instance;
  ApiCacheService._internal();

  final Map<String, _CacheEntry> _store = {};

  /// Default TTL for cached items.
  static const Duration defaultTTL = Duration(minutes: 5);

  // ── Cache keys (centralised to avoid typos) ──────────────────────────
  static const String k10History = 'assessment:k10_history';
  static const String asrsHistory = 'assessment:asrs_history';
  static const String goalsHistory = 'assessment:goals_history';
  static const String stressorsHistory = 'assessment:stressors_history';

  // ── Read / Write ─────────────────────────────────────────────────────

  /// Store [value] under [key]. Overwrites any previous entry.
  void put<T>(String key, T value, {Duration ttl = defaultTTL}) {
    _store[key] = _CacheEntry(
      data: value,
      expiry: DateTime.now().add(ttl),
    );
  }

  /// Retrieve a cached value. Returns `null` if missing or expired.
  T? get<T>(String key) {
    final entry = _store[key];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.expiry)) {
      _store.remove(key);
      return null;
    }
    return entry.data as T;
  }

  /// Whether a non-expired entry exists for [key].
  bool has(String key) => get(key) != null;

  // ── Invalidation ─────────────────────────────────────────────────────

  /// Remove a single cached entry.
  void invalidate(String key) => _store.remove(key);

  /// Remove all entries whose key starts with [prefix].
  /// e.g. `invalidateGroup('assessment')` clears k10, asrs, goals, stressors.
  void invalidateGroup(String prefix) {
    _store.removeWhere((key, _) => key.startsWith(prefix));
  }

  /// Remove every cached entry.
  void clearAll() => _store.clear();
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;

  _CacheEntry({required this.data, required this.expiry});
}
