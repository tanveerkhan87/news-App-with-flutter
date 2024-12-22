import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newsImage;
  final String newsTitle;
  final String newsDate;
  final String newsAuthor;
  final String newsDesc;
  final String newsContent;
  final String newsSource;

  NewsDetailScreen({
    required this.newsImage,
    required this.newsTitle,git
    required this.newsDate,
    required this.newsAuthor,
    required this.newsDesc,
    required this.newsContent,
    required this.newsSource,
  });

  final DateFormat format = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(newsDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[600],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                imageUrl: newsImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                Text(
                  newsTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        newsSource,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  newsDesc,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  newsContent,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
