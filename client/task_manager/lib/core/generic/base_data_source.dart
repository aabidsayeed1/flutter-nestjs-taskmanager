import 'package:dartz/dartz.dart';
import 'package:http/http.dart';


abstract class BaseDataSource<T> {
  Future<Either<Response, T>> dataSourceMethod(dynamic data);
}
