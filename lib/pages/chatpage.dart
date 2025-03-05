import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _chatMessages =
      []; // To store chat messages as maps
  String _responseMessage = ""; // To store the response from Gemini

  // Method to send chat messages to Gemini API
  Future<void> sendChatMessage(String message) async {
    String apiKey = 'AIzaSyCxbFB6l71d3H_ocYt6dpxx4ZVcxiBDUDA';
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final msg = '''
    You are a carbon footprint calculator. 
    
    Here is a database of items along with their carbon footprint emission types (EmType). Each item has an emission value and is associated with an EmType, which describes how the emissions are measured (e.g., by quantity, distance, etc.).

EmType examples:
1. Purchase: measured by quantity (item(s)).
2. Transport: measured by distance (km(s)).
3. Meal: measured by quantity (meal(s)).
4. Streaming: measured by duration (hour(s)).
5. Fashion: measured by quantity (item(s)).
6. Food: measured by quantity (g).

Here is a list of items and their emissions:

**Purchase Items:**
- SmartPhone: 80
- Laptop: 210
- Tablet: 87
- Computer: 588
- Television: 500
- Electric Car: 8800
- Hybrid Car: 6500

**Transport Items:**
- Train: 0.084 (per km)
- Car: 38.55 (per km)
- Bus: 15.45 (per km)
- Plane: 453.77 (per km)
- MotorBike: 16.2 (per km)

**Meal Items:**
- High Meat: 2.16 (per meal)
- Medium Meat: 1.69 (per meal)
- Vegan: 0.867 (per meal)

**Fashion Items:**
- Coat: 51 (per item)
- Dress: 54.33 (per item)
- T-Shirt: 7.67 (per item)

**Food Items:**
- Meat: 3.5 (per g)
- Coffee: 0.628 (per g)
- Chocolate: 0.974 (per g)
- Milk: 0.38 (per g)

**Streaming Items:**
- Audio-MP3: 0.033 (per hour)
- Video-Full HD: 0.135 (per hour)

    Based on the following user statement, provide a note about the item name,value,EmType,measuerdby,metric used. If the item is not listed in the database,
     create a new item with a reasonable emission value and assign it an appropriate EmType from the list:
    "$message"
    ''';

    final content = Content.text(msg);
    final response = await model.generateContent([content]);

    setState(() {
      _responseMessage = response.text ?? " ";
      _chatMessages.add({'sender': 'user', 'message': message});
      _chatMessages.add({'sender': 'bot', 'message': _responseMessage});
    });
  }

  // Example of chat sending function
  void _onSendChat() {
    String message = _chatController.text.trim();
    if (message.isNotEmpty) {
      sendChatMessage(message);
      _chatController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Chat with Carbon Calculator"),
        backgroundColor: Colors.green[300],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final msg = _chatMessages[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: msg['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: msg['sender'] == 'user'
                            ? Colors.green[200] // Light green for user messages
                            : Colors.grey[200], // Light grey for bot messages
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        msg['message'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _onSendChat,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
