import '../../core/status/data_state_type.dart';

class ApiDataState<T> {
  T? data;
  DataStateType? type;
  String? message;

  ApiDataState.data({this.data}) : type = DataStateType.data;

  ApiDataState.error({this.message}) : type = DataStateType.error;

  ApiDataState.loading() : type = DataStateType.loading;

  ApiDataState.idle() : type = DataStateType.idle;
}
