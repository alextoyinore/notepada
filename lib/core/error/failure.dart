import 'package:notepada/config/strings/strings.dart';

class Failure {
  final String message;
  Failure({this.message=AppStrings.internalServerError});
}