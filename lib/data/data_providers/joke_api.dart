import 'package:http/http.dart' as http;

class JokeApi {
  String uri = 'https://v2.jokeapi.dev/joke/Any?blacklistFlags=explicit';
  
  http.Response response;

  Future<http.Response> getJoke(List<String> filters) async {
    /// Add the query parameters to uri
    /// to apply filtering
    if (filters.isNotEmpty) {
      filters.map((flag) => uri + ',$flag');
    }

    try {
      response = await http.get(Uri.parse(uri + '&type=single'));
      return response;
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return null;
    }
  }
}
