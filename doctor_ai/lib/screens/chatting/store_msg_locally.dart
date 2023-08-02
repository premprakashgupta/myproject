import 'package:doctor_ai/providers/chatting_provider.dart';
import 'package:doctor_ai/providers/msg_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreMsgLocally extends StatelessWidget {
  StoreMsgLocally({super.key});
  final MsgStore _msgStore = MsgStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await _msgStore.storeChatMessageLocally(
                    {"type": "user"}, "OCarg7NGW8M1Adgh5RHmwTEk3FA3");
              },
              child: Text("add"),
            ),
            ElevatedButton(
              onPressed: () async {
                var res = await _msgStore
                    .loadChatsForReceiver("OCarg7NGW8M1Adgh5RHmwTEk3FA3");
                print(res);
              },
              child: Text("get"),
            ),
          ],
        ),
      ),
    );
  }
}
