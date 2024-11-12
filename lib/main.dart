import 'dart:convert';
import '../views/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/decklist.dart';
  
Future<void> loadJSONData(DBHelper dbHelper) async {
  final jsonContent = await rootBundle.loadString('assets/flashcards.json');
  final List<dynamic> jsonList = jsonDecode(jsonContent);

  for (final dynamic map in jsonList) {
    final deckTitle = map['title'];
    final flashcards = map['flashcards'];

    final deck = Deck(title: deckTitle);
    final deckId = await dbHelper.insertDeck(deck);
    print('Inserted Deck: $deckTitle');

    for (final flashcardMap in flashcards) {
      final question = flashcardMap['question'];
      final answer = flashcardMap['answer'];

      final flashcard = Flashcard(
        deckId: deckId,
        question: question,
        answer: answer,
      );

      await dbHelper.insertFlashcard(flashcard);
      print('Inserted Flashcard: $question');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  final dbHelper = DBHelper();
  await dbHelper.initDatabase();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DeckList(),
  ));
}
