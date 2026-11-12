import 'dart:convert';

import 'package:logger/logger.dart';

/// Emits every log record as JSON, indented for terminal reading by default:
///
///     {
///       "timestamp": "2026-11-12T09:12:33.123Z",
///       "level": "info",
///       "message": "FCM initialized successfully"
///     }
///
/// Construct it with `pretty: false` for one compact record per line, which is
/// what log collectors (Crashlytics, Datadog, `adb logcat` pipelines) want.
class JsonLogPrinter extends LogPrinter {
  JsonLogPrinter({
    this.stackTraceBeginIndex = 0,
    this.errorMethodCount = 8,
    this.pretty = true,
  });

  /// Number of stack trace frames to skip from the top.
  final int stackTraceBeginIndex;

  /// Max number of stack trace frames included when an error is attached.
  final int errorMethodCount;

  /// When true (the default), the JSON is indented over multiple lines, which
  /// is what you want when reading logs in a terminal. Set it to false for
  /// one record per line, for a log collector to parse.
  final bool pretty;

  static const _levelNames = <Level, String>{
    Level.trace: 'trace',
    Level.debug: 'debug',
    Level.info: 'info',
    Level.warning: 'warning',
    Level.error: 'error',
    Level.fatal: 'fatal',
  };

  static final _deviceStackTraceRegex = RegExp(r'#[0-9]+\s+(.+) \((\S+)\)');
  static final _webStackTraceRegex = RegExp(r'^((packages|dart-sdk)/\S+/)');
  static final _browserStackTraceRegex =
      RegExp(r'^(?:package:)?(dart:\S+|\S+)');

  @override
  List<String> log(LogEvent event) {
    final record = <String, dynamic>{
      'timestamp': event.time.toUtc().toIso8601String(),
      'level': _levelNames[event.level] ?? event.level.name,
    };

    final message = event.message is Function ? event.message() : event.message;
    if (message is Map) {
      // Structured log: keep a flat message plus the full payload.
      record['message'] = message['message'] ?? message['msg'] ?? '';
      record['context'] = message;
    } else if (message is Iterable) {
      record['message'] = '';
      record['context'] = message.toList();
    } else {
      record['message'] = message is String ? message : message.toString();
    }

    final error = event.error;
    if (error != null) {
      record['error'] = error.toString();
      record['errorType'] = error.runtimeType.toString();
    }

    final stackTrace = event.stackTrace ??
        (error is Error ? error.stackTrace : null) ??
        (event.level.index >= Level.error.index ? StackTrace.current : null);
    if (stackTrace != null) {
      final frames = _formatStackTrace(stackTrace, errorMethodCount);
      if (frames != null && frames.isNotEmpty) record['stackTrace'] = frames;
    }

    final encoder = pretty
        ? const JsonEncoder.withIndent('  ', _toEncodable)
        : const JsonEncoder(_toEncodable);

    return encoder.convert(record).split('\n');
  }

  static Object? _toEncodable(Object? value) => value?.toString();

  List<String>? _formatStackTrace(StackTrace stackTrace, int maxFrames) {
    var lines = stackTrace.toString().split('\n');
    if (lines.length > stackTraceBeginIndex) {
      lines = lines.sublist(stackTraceBeginIndex);
    }

    final formatted = <String>[];
    for (final line in lines) {
      if (line.trim().isEmpty || _discardDeviceStacktraceLine(line) ||
          _discardWebStacktraceLine(line) ||
          _discardBrowserStacktraceLine(line)) {
        continue;
      }
      formatted.add(line.replaceFirst(RegExp(r'#\d+\s+'), '').trim());
      if (formatted.length >= maxFrames) break;
    }
    return formatted;
  }

  bool _discardDeviceStacktraceLine(String line) {
    final match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) return false;
    return match.group(2)!.startsWith('package:logger');
  }

  bool _discardWebStacktraceLine(String line) {
    final match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) return false;
    return match.group(1)!.startsWith('packages/logger');
  }

  bool _discardBrowserStacktraceLine(String line) {
    final match = _browserStackTraceRegex.matchAsPrefix(line);
    if (match == null) return false;
    return match.group(1)!.startsWith('package:logger');
  }
}

/// App-wide logger. All records are printed as JSON.
final logger = Logger(printer: JsonLogPrinter());
