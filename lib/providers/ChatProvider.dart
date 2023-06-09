// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:chatgpt/models/chatModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
List<String> localChatModel=[];
String jsonStringChatModel = "";
List<ChatModel> listChatModel = [];

String setLanguageSpeech = "en-US" ;

Future<void> getChatModel()  async {
  final prefs = await SharedPreferences.getInstance();
  localChatModel = prefs.getStringList('chats')?? [];
  if (localChatModel.isNotEmpty) {
    listChatModel = localChatModel
        .map((item) => ChatModel.fromJson(json.decode(item)))
        .toList();
  }
}
Future<void> deleteChatModel() async {
  final prefs = await SharedPreferences.getInstance();
  listChatModel=[];
  await prefs.setStringList('chats', []);


}
class ChatNotifier extends StateNotifier<List<ChatModel>>{
  ChatNotifier(): super([]);
  void add(ChatModel chatModel) async{
    final prefs = await SharedPreferences.getInstance();
    getChatModel();
    state = [...state, chatModel];
    listChatModel.add(chatModel);
    await prefs.setStringList('chats', listChatModel.map((map) => jsonEncode(map)).toList());
    getChatModel();
  }

}

final chatsProvider = StateNotifierProvider<ChatNotifier,List<ChatModel>>((ref) => ChatNotifier(),argument: getChatModel(),);

