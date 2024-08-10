import 'dart:convert';

import 'package:google_maps_project/models/category_news_model.dart';
import 'package:google_maps_project/models/new_channel_headlines_model.dart';
import 'package:http/http.dart' as http;

class NewsRepositary {
  Future<NewsChannelsHeadLinesModel> fetchNewsChannelHeadLinesAPI(
      String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=9d7253d5ea15447d898edf983ff020aa';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return NewsChannelsHeadLinesModel.fromJson(body);
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      throw Exception('Error');
    }
  }

  Future<CatergoryNewsModel> fetchCatergoriesAPI(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=$category&apiKey=9d7253d5ea15447d898edf983ff020aa';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print('Body is $body');
      return CatergoryNewsModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }
}
