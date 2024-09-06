import 'package:http/http.dart';

class ExceptionThrower {
  final String error;

  const ExceptionThrower({required this.error});

  Future<void> CheckForException(Response response, {expectedStatusCode = 200, additionalStatusCode = 200}) async{
    if (response.statusCode != expectedStatusCode && response.statusCode != additionalStatusCode) {
      throw Exception("$error mit Statuscode = ${response.statusCode} means ${response.reasonPhrase}");
    }
  }
}
