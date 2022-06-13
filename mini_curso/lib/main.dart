import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:mini_curso/model/post_model.dart';
import 'package:mini_curso/post_page.dart';
import 'package:mini_curso/widgets/card_post.dart';

const String url = "https://appgestor.herokuapp.com/v1/graphql";
HasuraConnect hasuraConnect = HasuraConnect(url);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: MyHomePage(),
      routes: {
        "post_page": (context) {
          var result = ModalRoute.of(context)?.settings.arguments;
          Post? post = result == null? null : result as Post;
          return PostPage(
            post: post,
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String queryPost = """
    query MyQuery {
      post {
        id
        texto
      }
    }
  """;

  Future<PostModel> getAllPost() async {
    var result = await hasuraConnect.query(queryPost);
    return PostModel.fromJson(result);
  }

  Future<bool> delete(int id) async {
    String document = """
      mutation MyMutation {
        delete_post(where: {id: {_eq: $id }}) {
          affected_rows
        }
      }  
    """;

    try {
      await hasuraConnect.mutation(document);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Blog"),
      ),
      body: FutureBuilder<PostModel>(
          future: getAllPost(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data!.data!.post!.length,
              itemBuilder: (context, i) {
                var post = snapshot.data!.data!.post!.elementAt(i);
                return CardPost(
                  texto: post.texto!,
                  onEdit: () async {
                    await Navigator.pushNamed(
                      context,
                      "post_page",
                      arguments: post,
                    );
                    setState(() {});
                  },
                  onDelete: () async {
                    await delete(post.id!);
                    setState(() {
                      
                    });
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Adicinar"),
        icon: const Icon(CupertinoIcons.add),
        onPressed: () async {
          var isSend = await Navigator.pushNamed(context, "post_page");
          if (isSend != null) {
            setState(() {});
          }
        },
      ),
    );
  }
}
