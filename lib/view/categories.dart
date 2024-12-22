import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'news_details_screen.dart'; // Import the NewsDetailScreen

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final format = DateFormat('MMM dd, yyyy');
  String categoryName = 'General';
  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  List articles = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchNews(categoryName);
  }

  Future<void> fetchNews(String category) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final apiKey = '7d13f756de7e421380d66c4d877d811a'; // Replace with your News API key
    final url = Uri.parse('https://newsapi.org/v2/top-headlines?category=$category&apiKey=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['articles'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load news';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        categoryName = categoriesList[index];
                        fetchNews(categoryName);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            color: categoryName == categoriesList[index]
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                              child: Text(
                                categoriesList[index],
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            if (isLoading)
              Center(
                child: SpinKitCircle(
                  size: 50,
                  color: Colors.blue,
                ),
              )
            else if (errorMessage.isNotEmpty)
              Text(errorMessage)
            else
              Expanded(
                child: ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime =
                      DateTime.parse(articles[index]['publishedAt']);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(
                                  newsImage: articles[index]['urlToImage'] ?? '',
                                  newsTitle: articles[index]['title'] ?? '',
                                  newsDate: articles[index]['publishedAt'] ?? '',
                                  newsAuthor: articles[index]['author'] ?? 'Unknown',
                                  newsDesc: articles[index]['description'] ?? '',
                                  newsContent: articles[index]['content'] ?? '',
                                  newsSource: articles[index]['source']['name'] ?? 'Unknown',
                                ),
                              ),

                            );
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                 //imageUrl: articles[index].urlToImage.toString(),
                                    imageUrl: articles[index]['urlToImage'] ?? '',
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) => Container(
                                    child: Center(
                                      child: SpinKitCircle(
                                        size: 50,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline,
                                          color: Colors.red),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        articles[index]['title'] ?? '',
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              articles[index]['source']['name']
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )
          ],
        ),
      ),
    );
  }
}
