import 'package:path/path.dart' as path;
import 'decklist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';



class DBHelper {
  static const String _databaseName = 'flashcards.db';
  static const int _databaseVersion = 1;

  DBHelper._();
  static final DBHelper _singleton = DBHelper._();
  factory DBHelper() => _singleton;

  Database? _database;

  Future<Database?> get db async {
    _database ??= await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = path.join(dbDir.path, _databaseName);

    var db = await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );

    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE deck (
        id INTEGER PRIMARY KEY,
        title TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE flashcard (
        id INTEGER PRIMARY KEY,
        deck_id INTEGER,
        question TEXT,
        answer TEXT,
        FOREIGN KEY (deck_id) REFERENCES deck(id)
      )
    ''');
  }

  Future<List<Deck>> getAllDecks() async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db!.query('deck');

    return List.generate(maps.length, (index) {
      return Deck(
        id: maps[index]['id'],
        title: maps[index]['title'],
      );
    });
  }

  Future<List<Flashcard>> getFlashcardsByDeckId(int deckId) async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db!.query(
      'flashcard',
      where: 'deck_id = ?',
      whereArgs: [deckId],
    );

    return List.generate(maps.length, (index) {
      return Flashcard(
        id: maps[index]['id'],
        deckId: maps[index]['deck_id'],
        question: maps[index]['question'],
        answer: maps[index]['answer'],
      );
    });
  }

  Future<int> insertDeck(Deck deck) async {
    final db = await this.db;

    final List<Map<String, dynamic>> existingDecks = await db!.query(
      'deck',
      where: 'title = ?',
      whereArgs: [deck.title],
    );
    return await db.insert('deck', deck.toMap());
  }

  Future<int> insertFlashcard(Flashcard flashcard) async {
    final db = await this.db;
    int id = await db!.insert(
      'flashcard',
      flashcard.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> updateDeckTitle(int deckId, String newTitle) async {
    final db = await this.db;
    await db!.update(
      'deck',
      {'title': newTitle},
      where: 'id = ?',
      whereArgs: [deckId],
    );
  }

  Future<void> deleteDeck(int deckId) async {
    final db = await this.db;
    await db!.delete(
      'deck',
      where: 'id = ?',
      whereArgs: [deckId],
    );

    await db.delete(
      'flashcard',
      where: 'deck_id = ?',
      whereArgs: [deckId],
    );
  }

  Future<void> updateFlashcardContent(
      int flashcardId, String newQuestion, String newAnswer) async {
    final db = await this.db;
    await db!.update(
      'flashcard',
      {
        'question': newQuestion,
        'answer': newAnswer,
      },
      where: 'id = ?',
      whereArgs: [flashcardId],
    );
  }

  Future<void> deleteFlashcard(int flashcardId) async {
    final db = await this.db;
    await db!.delete(
      'flashcard',
      where: 'id = ?',
      whereArgs: [flashcardId],
    );
  }

  Future<void> deleteDeckAndFlashcards(int deckId) async {
    final db = await this.db;
    await db!.transaction((txn) async {
      await txn.delete('flashcard', where: 'deck_id = ?', whereArgs: [deckId]);
      await txn.delete('deck', where: 'id = ?', whereArgs: [deckId]);
    });
  }
}
