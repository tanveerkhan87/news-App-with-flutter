import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prime_news/models/news_channel_model.dart';
import 'package:prime_news/view_model/news_view_model.dart';

import 'categories.dart';

// Enum for news sources
enum FilterList { bbcNews, aryNews, abcnews, reuters, cnn, alJazeera }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = "bbc-news"; // Default category
  final format = DateFormat("MMMM dd, yyyy");
  NewsViewModel newsViewModel = NewsViewModel();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesScreen()))  ;        },
          icon: Image.asset("images/menubig.webp", width: 55, height: 55),
        ),
        title: Text(
          "Prime News",
          style: GoogleFonts.abhayaLibre(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: FilterList.bbcNews,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              switch (item) {
                case FilterList.bbcNews:
                  category = "bbc-news";
                  break;
                case FilterList.aryNews:
                  category = "ary-news";
                  break;
                case FilterList.abcnews:
                  category = "abc-news";
                  break;
                case FilterList.reuters:
                  category = "reuters";
                  break;
                case FilterList.cnn:
                  category = "cnn";
                  break;
                case FilterList.alJazeera:
                  category = "al-jazeera-english";
                  break;
              }
              setState(() {}); // Refresh the state to fetch new data
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text("BBC News"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text("ARY News"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.alJazeera,
                child: Text("Al Jazeera"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.abcnews,
                child: Text("Abc News"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.cnn,
                child: Text("CNN"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.reuters,
                child: Text("Reuters"),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            width: width * .55,
            height: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchHeadlinesNewsApi(category),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 33,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null ||
                    snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child: Text('No data available'),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: height * 0.6,
                              width: width * .9,
                              padding: EdgeInsets.symmetric(horizontal: height * .02),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(child: spinkit2),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  height: height * .22,
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width * 0.7,
                                        child: Text(
                                          snapshot.data!.articles![index].title.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: width *0.7,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index].source!.name.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                            ),

                                            Text(format.format(datetime)),
                                          ],

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.cyan,
  size: 58,
);
