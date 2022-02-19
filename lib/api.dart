import 'package:http/http.dart' as http;

Future getData(Uri url) async {
  http.Response response = await http.get(url);
  return response.body; 
}
