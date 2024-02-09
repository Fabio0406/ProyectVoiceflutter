import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final List<Map<String, dynamic>> mensajes;

  const AppBody({
    Key? key,
    this.mensajes = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, i) {
        var obj = mensajes[mensajes.length - 1 - i];
        Message message = obj['message'];
        bool isUserMessage = obj['isUserMessage'] ?? false;
        return Row(
          mainAxisAlignment:
              isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: isUserMessage ? MainAxisSize.min : MainAxisSize.max,
          children: [
            contenedordemensajes(
              message: message,
              isUserMessage: isUserMessage,
            ),
          ],
        );
      },
      separatorBuilder: (_, i) => Container(height: 10),
      itemCount: mensajes.length,
      reverse: true,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
    );
  }
}

// ignore: camel_case_types
class contenedordemensajes extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const contenedordemensajes({
    Key? key,
    required this.message,
    this.isUserMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: LayoutBuilder(
        builder: (context, constrains) {
          switch (message.type) {            
            case MessageType.text:
            default:
              return Container(
                decoration: BoxDecoration(
                  color: isUserMessage
                      ? const Color.fromARGB(157, 129, 26, 26)
                      : const Color.fromARGB(255, 54, 52, 48),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: !isUserMessage
                    ? const EdgeInsets.all(20)
                    : const EdgeInsets.all(10),
                child: Text(
                  message.text?.text?[0] ?? '',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

