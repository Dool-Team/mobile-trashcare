import 'dart:convert';

import 'package:flutter/material.dart';

class chatbot extends StatelessWidget {
  const chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
}
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  List<Map<String, dynamic>> _botResponses = [];

  @override
  void initState() {
    super.initState();
    // Load JSON data
    loadBotResponses();
  }

  Future<void> loadBotResponses() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/bot_responses.json');
    setState(() {
      _botResponses = json.decode(data);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(text: text, isBot: false);
    setState(() {
      _messages.insert(0, message);
    });
    // Find a response based on user input
    String response = getBotResponse(text);
    ChatMessage botMessage = ChatMessage(text: response, isBot: true);
    setState(() {
      _messages.insert(0, botMessage);
    });
  }

  String getBotResponse(String userMessage) {
    // Your logic to get a response based on user input from loaded JSON data
    // For example, let's assume the bot_responses.json contains a list of responses
    // based on keywords.
    for (var entry in _botResponses) {
      if (entry.containsKey(userMessage.toLowerCase())) {
        return entry[userMessage.toLowerCase()];
      }
    }
    return "Maaf, saya tidak mengerti.";
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: const Color.fromRGBO(78, 96, 76, 1)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Ketik pesan Anda'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _handleSubmitted(_textController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isBot;

  ChatMessage({required this.text, this.isBot = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isBot
              ? Container(
                  margin: EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    // Widget atau gambar yang ingin ditampilkan untuk chatbot
                    backgroundImage: AssetImage('images/logo.png'),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    // Widget atau gambar yang ingin ditampilkan untuk pengguna
                    backgroundImage: AssetImage('images/profil.png'),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isBot ? 'TrashCare' : 'User',
                    style: Theme.of(context).textTheme.subtitle1),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(text),

                ),
              ],
            ),
          ),
        ],
    ),
  );
  }
}