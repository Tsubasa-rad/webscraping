// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse(
        "https://www.city.kumamoto.jp/hpkiji/pub/List.aspx?c_id=5&class_set_id=2&class_id=61");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('span > a')
        .map((element) => element.innerHtml.trim())
        .toList();

    final process = html
        .querySelectorAll('span > a')
        .map((element) =>
            'https://www.city.kumamoto.jp/${element.attributes['href']}')
        .toList();

    print('count: ${titles.length}');
    setState(() {
      articles = List.generate(
        titles.length,
        (index) =>
            Article(url: process[index], title: titles[index], urlImage: ''),
      );
    });
    // for (final title in titles) {
    //   debugPrint(title);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];

            return ListTile(
              title: Text(article.title),
              subtitle: Text(article.url),
            );
          },
        ));
  }
}

class Article {
  final String url, title, urlImage;

  const Article({
    required this.url,
    required this.title,
    required this.urlImage,
  });
}
