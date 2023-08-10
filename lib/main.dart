import 'package:exactus_task2/Views/login.dart';
import 'package:flutter/material.dart';
import 'api_helper/api_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'my news',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginForm(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> news;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      news = NewsAPI.fetchNews();
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter News',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available.'));
          } else {
            final List<dynamic> newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> newsData = newsList[index];
                return BlogTile(
                  title: newsData['title'],
                  desc: newsData['description'],
                  imageUrl: newsData['urlToImage'] != null
                      ? newsData['urlToImage']
                      : null,
                  // onTap: () {
                  //   // Open article URL in browser or WebView
                  // },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc;
  const BlogTile(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            SizedBox(height: 10),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(desc)
          ],
        ),
      ),
    );
  }
}
