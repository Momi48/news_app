import 'package:google_maps_project/models/category_news_model.dart';
import 'package:google_maps_project/models/new_channel_headlines_model.dart';
import 'package:google_maps_project/repositary/news_repositary.dart';

class NewsViewModel {
  final repo = NewsRepositary();

  Future<NewsChannelsHeadLinesModel> fetchNewsChannelHeadLinesAPI(
      String channel) async {
    final response = await repo.fetchNewsChannelHeadLinesAPI(channel);
    return response;
  }

  Future<CatergoryNewsModel> fetchCatergoriesAPI(String category) async {
    final response = await repo.fetchCatergoriesAPI(category);
    return response;
  }
}
