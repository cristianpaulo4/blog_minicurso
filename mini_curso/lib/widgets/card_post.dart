import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CardPost extends StatelessWidget {
  final String texto;
  final Function()? onEdit;
  final Function()? onDelete;
  CardPost({Key? key, required this.texto, this.onEdit, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(texto),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: onEdit,
                child: const Text('Editar'),
              ),
              TextButton(
                onPressed: onDelete,
                child: const Text('Deletar'),
                style: ButtonStyle(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
