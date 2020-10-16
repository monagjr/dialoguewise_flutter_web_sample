import 'package:flutter/material.dart';
import 'package:dialogue_wise/dialogue_wise.dart';
import 'package:http/http.dart' as http;
import 'package:easy_web_view/easy_web_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'DialogueWise Flutter Web Demo';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map> _content;

  @override
  void initState() {
    super.initState();
    _content = getContent();
  }

  Future<Map> getContent() async {
    var request = new DialogueWiseRequest();
    request.slug = 'my-fab-food-store';
    request.apiKey = '82e2934400364fab877809bd9c40eefa91B93BAD81F7A1FC8FDF2DD1';
    request.emailHash = 'AzLAgRn7emIb+9UUgAmJQewbrk2oLaf5D8KYMG8tHro=';
    // Call the Dialogue Wise API
    var dialogueWiseService = new DialogueWiseService(new http.Client());
    Map res = await dialogueWiseService.getDialogue(request);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder(
              future: _content,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List dialogue = snapshot.data['dialogue'];
                  return ListView.separated(
                      padding: EdgeInsets.all(8.0),
                      itemCount: dialogue.length,
                      itemBuilder: (context, index) {
                        Map item = dialogue[index];
                        return Row(
                          children: [
                            Image.network(
                              item['dish-photo'],
                              fit: BoxFit.fill,
                              width: 300,
                              height: 300,
                            ),
                            Expanded(
                                child: ListTile(
                              title: Text(item['dish-name']),
                              subtitle: SizedBox(
                                  child: EasyWebView(
                                    src: item['long-description'],
                                    isHtml: true,
                                    onLoaded: () {},
                                    key: ValueKey(index),
                                    convertToWidgets: true,
                                  ),
                                  height: 150),
                              isThreeLine: true,
                            ))
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider());
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              })),
    );
  }
}
