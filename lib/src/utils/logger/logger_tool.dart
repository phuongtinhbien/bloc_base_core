import 'package:logger/logger.dart';

class LogTool {
  static final LogTool _singleton = LogTool._internal();

  factory LogTool() {
    return _singleton;
  }

  late final _output;
  late final _logger;

  LogTool._internal();

  void init({LogFilter? filter, required LogOutput output}) {
    _output = output;
    _logger = Logger(
        output: _output,
        filter: filter,
        printer: PrettyPrinter(
          methodCount: 0,
          colors: false,
          printTime: true,

          // lineLength: 80
        ));
  }

  /// Log a message at level [Level.verbose].
  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  /// Log a message at level [Level.debug].
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  /// Log a message at level [Level.warning].
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  /// Log a message at level [Level.error].
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  /// Log a message at level [Level.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error, stackTrace);
  }
}

class Log {
  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    LogTool().v(message, error, stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    LogTool().d(message, error, stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    LogTool().i(message, error, stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    LogTool().w(message, error, stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    LogTool().e(message, error, stackTrace);
  }

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    LogTool().wtf(message, error, stackTrace);
  }
}
