import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../domain/core/status/request_type.dart';
import '../../../domain/core/views/custom_snackbar_view.dart';
import '../daos/session_management.dart';
import 'api_exceptions.dart';
import 'firebase_analytics_services.dart';

class BaseClient {
  /// perform safe api request
  static safeApiCall(
    String url,
    RequestType requestType, {
    Map<String, String>? header,
    dynamic queryParameters,
    required Function(http.Response response) onSuccess,
    Function(ApiException)? onError,
  }) async {
    try {
      header = {
        if (header != null) ...header,
        'Authorization': 'Bearer ${await SessionManagement.getAccessToken()}'
      };
      FirebaseAnalyticsServices.apiRequestLogEvent(
        url: url,
        headers: header,
        queryParameters: queryParameters,
        requestType: requestType,
      );

      late http.Response response;
      Uri api = Uri.parse(url);
      switch (requestType) {
        case RequestType.get:
          response = await http.get(api, headers: header);
          break;
        case RequestType.post:
          response =
              await http.post(api, body: queryParameters, headers: header);
          break;
        case RequestType.put:
          break;
        default:
          break;
      }
      FirebaseAnalyticsServices.apiResponseLogEvent(
          url: url,
          headers: header,
          queryParameters: queryParameters,
          requestType: requestType,
          response: response);
      await onSuccess(response);
    } on http.ClientException catch (error) {
      FirebaseAnalyticsServices.apiErrorLogEvent(
          url: url,
          headers: header,
          queryParameters: queryParameters,
          requestType: requestType,
          error: error.message);
      _handleClientException(error: error, url: url, onError: onError);
    } on SocketException catch (e) {
      FirebaseAnalyticsServices.apiErrorLogEvent(
          url: url,
          headers: header,
          queryParameters: queryParameters,
          requestType: requestType,
          error: e.message);
      _handleSocketException(onError: onError, url: url);
      // No internet connection _handleSocketException(url: url, onError: onError);
    } on TimeoutException catch (e) {
      FirebaseAnalyticsServices.apiErrorLogEvent(
          url: url,
          headers: header,
          queryParameters: queryParameters,
          requestType: requestType,
          error: e.message);
      _handleTimeoutException(onError: onError, url: url);
      // Api call went out of time _handleTimeoutException(url: url, onError: onError);
    } catch (error) {
      FirebaseAnalyticsServices.apiErrorLogEvent(
          url: url,
          headers: header,
          queryParameters: queryParameters,
          requestType: requestType,
          error: error.toString());
      // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url, onError: onError, error: error);
    }
  }

  /// handle unexpected error
  static _handleUnexpectedException(
      {Function(ApiException)? onError,
      required String url,
      required Object error}) {
    if (onError != null) {
      onError(ApiException(
        message: error.toString(),
        url: url,
      ));
    } else {
      _handleError(error.toString());
    }
  }

  /// handle timeout exception
  static _handleTimeoutException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(ApiException(
        message: 'Server is not responding!',
        url: url,
      ));
    } else {
      _handleError('Server is not responding!');
    }
  }

  /// handle timeout exception
  static _handleSocketException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(ApiException(
        message: 'No internet connection!',
        url: url,
      ));
    } else {
      _handleError('No internet connection!');
    }
  }

  /// handle Client error
  static _handleClientException(
      {required http.ClientException error,
      Function(ApiException)? onError,
      required String url}) {
    // 404 error
    if (error.message == 'Not Found') {
      if (onError != null) {
        return onError(ApiException(
          message: 'Url not found',
          url: url,
          statusCode: 404,
        ));
      } else {
        return _handleError('Url not found');
      }
    }

    // no internet connection
    if (error.message.toLowerCase().contains('socket')) {
      if (onError != null) {
        return onError(ApiException(
          message: 'No internet connection!',
          url: url,
        ));
      } else {
        return _handleError('No internet connection!');
      }
    }

    // check if the error is 500 (server problem)
    if (error.message == 'Internal Server Error') {
      var exception = ApiException(
        message: 'Server error',
        url: url,
        statusCode: 500,
      );

      if (onError != null) {
        return onError(exception);
      } else {
        return handleApiError(exception);
      }
    }

    var exception = ApiException(url: url, message: error.message
        // response: error,
        // statusCode: error.response?.statusCode
        );
    if (onError != null) {
      return onError(exception);
    } else {
      return handleApiError(exception);
    }
  }

  /// handle error automaticly (if user didnt pass onError) method
  /// it will try to show the message from api if there is no message
  /// from api it will show the reason (the dio message)
  static handleApiError(ApiException apiException) {
    String msg = apiException.toString();
    CustomSnackBarView.showCustomErrorToast(message: msg);
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg) {
    CustomSnackBarView.showCustomErrorToast(message: msg);
  }
}
