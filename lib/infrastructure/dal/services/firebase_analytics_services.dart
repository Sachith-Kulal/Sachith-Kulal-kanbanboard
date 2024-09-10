import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart';

import '../../../domain/core/status/request_type.dart';

class FirebaseAnalyticsServices {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Request Event Log
  static apiRequestLogEvent({
    String? url,
    Map<String, String>? headers,
    dynamic queryParameters,
    RequestType? requestType,
  }) {
    analytics.logEvent(name: 'Api_call', parameters: {
      'url': url.toString(),
      'headers': headers.toString(),
      'queryParameters': queryParameters.toString(),
      'requestType': requestType.toString(),
      'state': 'request'
    });
  }

  // Response Event Log
  static apiResponseLogEvent({
    String? url,
    Map<String, String>? headers,
    dynamic queryParameters,
    RequestType? requestType,
    Response? response,
  }) {
    analytics.logEvent(name: 'Api_call', parameters: {
      'url': url as Object,
      'headers': headers.toString(),
      'queryParameters': queryParameters.toString(),
      'requestType': requestType.toString(),
      'Response': response.toString(),
      'state': 'response'
    });
  }

  // Error Event Log
  static apiErrorLogEvent({
    String? url,
    Map<String, String>? headers,
    dynamic queryParameters,
    RequestType? requestType,
    String? error,
  }) {
    analytics.logEvent(name: 'Api_call', parameters: <String, Object>{
      'url': url as Object,
      'headers': headers.toString(),
      'queryParameters': queryParameters.toString(),
      'requestType': requestType.toString(),
      'Error': error as Object,
      'state': 'error'
    });
  }
}
