import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:parcial_api/models/ApiParcial.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(ParcialApi());
}

class ParcialApi extends StatefulWidget {
  ParcialApi({Key? key}) : super(key: key);

  @override
  _ParcialApiState createState() => _ParcialApiState();
}

class _ParcialApiState extends State<ParcialApi> {
  @override
  late Future<List<ApiParcial>> _contentList;

  Future<List<ApiParcial>> _getContent() async {
    String body;
    final responsive = await http
        .get(Uri.parse("https://utecclass.000webhostapp.com/post.php"));
    List<ApiParcial> contentList = [];
    if (responsive.statusCode == 200) {
      print(responsive.body);
      body = utf8.decode(responsive.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData);
      for (var item in jsonData) {
        contentList.add(ApiParcial(item["id"], item["title"], item["status"],
            item["content"], item["user_id"]));
      }
      return contentList;
    } else {
      throw Exception("Errpr trying o connect to Parcial Api!");
    }
  }

  void initState() {
    super.initState();
    _contentList = _getContent();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Parcial",
      color: Color(0xFFdde0e3),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Parcial Api"),
          backgroundColor: Colors.blue[800],
          leading: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/ico/arrow.svg',
              width: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: ajustContent(),
      ),
    );
  }

  List<Widget> _contentLists(data) {
    List<Widget> contentList = [];
    for (var contents in data) {
      contentList.add(Card(
        elevation: 5,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/ico/online-test.svg',
                      width: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      contents.content,
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      contents.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
          ],
        ),
      ));
    }
    return contentList;
  }

  Widget futureContent() {
    return FutureBuilder(
      future: _contentList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _contentLists(snapshot.data),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Error");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget ajustContent() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade100, Colors.blue.shade900])),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: futureContent(),
      ),
    );
  }
}
