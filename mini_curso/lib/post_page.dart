import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mini_curso/main.dart';
import 'package:mini_curso/model/post_model.dart';

class PostPage extends StatefulWidget {
  final Post? post;
  const PostPage({Key? key, this.post}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  var controller = TextEditingController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (widget.post != null) {
      controller.text = widget.post!.texto!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicione seu post"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: SizedBox(
              height: 250,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: "Digite..."),
                expands: true,
                maxLines: null,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: controller.text == ""
                    ? null
                    : () async {
                        late bool isSend;
                        if (widget.post!=null) {
                          isSend = await update(widget.post!.id!, controller.text);
                          
                        }else{
                          isSend = await sendPost(controller.text);

                        }                        
                        if (isSend) {
                          Navigator.pop(context, isSend);
                        }
                      },
                icon: const Icon(
                  Icons.send,
                ),
                label: const Text(
                  'Adicionar postagem',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> sendPost(String text) async {
    String documentMutation = """
      mutation MyMutation {
        insert_post(objects: {texto: "$text" }) {
          affected_rows
        }
      }
    """;

    try {
      await hasuraConnect.mutation(documentMutation);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(int id, String text) async {
    String document = """
      mutation MyMutation {
        update_post(where: {id: {_eq: $id }}, _set: {texto: "$text"}) {
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
}
