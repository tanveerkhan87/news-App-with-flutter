import '../repository/news_repository.dart';
import '../models/news_channel_model.dart';
//Purpose: This class serves as a bridge between the UI (HomeScreen) and the data source (NewsRepository).
// fetchHeadlinesNewsApi: This method takes a news category (like "bbc-news")
// and uses the NewsRepository to fetch news articles. It returns a NewsChannelHeadlinesModel
// that contains the fetched data.
class NewsViewModel {
  final NewsRepository newsRepository = NewsRepository();//from next screen source

  Future<NewsChannelHeadlinesModel> fetchHeadlinesNewsApi(String category) async {
    return await newsRepository.fetchHeadlinesNewsApi(category);
  }
}
