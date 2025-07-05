
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_channel_model.dart';
//Purpose: This class handles the network requests to fetch data from the news API.
// fetchHeadlinesNewsApi: This method builds the API URL using the category and API key,
// then makes a GET request to fetch the data. If successful, it decodes the JSON response
// and converts it into a NewsChannelHeadlinesModel. If the request fails, it throws an error.
class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchHeadlinesNewsApi(String category) async {
    final apiKey = 'xxx'; //  put ur API key
    final url = 'https://newsapi.org/v2/top-headlines?sources=$category&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return NewsChannelHeadlinesModel.fromJson(data);
    } else {
      throw Exception('Failed to load news');
    }
  }
}
