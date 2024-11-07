import 'package:flutter/material.dart';
import '../main.dart';
import 'deckedit.dart';
import 'database_helper.dart';
import 'flashcard_screen.dart';
 
class DeckList extends StatefulWidget {
  const DeckList({super.key});

  @override
  State<DeckList> createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  List<Deck> decks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadDecks();
    downloadDecks();
  }

  Future<void> loadDecks() async {
    setState(() {
      isLoading = true;
    });

    final dbHelper = DBHelper();
    final loadedDecks = await dbHelper.getAllDecks();
    setState(() {
      decks = loadedDecks;
      isLoading = false;
    });
  }

  Future<void> downloadDecks() async {
    setState(() {
      isLoading = true;
    });
    final dbHelper = DBHelper();
    await loadJSONData(dbHelper);
    await loadDecks();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = (screenWidth / 200).floor();
    crossAxisCount = crossAxisCount > 0 ? crossAxisCount : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcard Decks',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 83, 171, 186),
            fontFamily: 'Cursive',
            letterSpacing: 1,
            shadows: [
              Shadow(
                offset: Offset(1.5, 1.5),
                blurRadius: 3.0,
                color: Color.fromARGB(100, 0, 0, 0),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.autorenew,
                color: Color.fromARGB(255, 83, 171, 186), size: 28),
            onPressed: () async {
              await loadDecks();
              await downloadDecks();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: crossAxisCount,
              padding: const EdgeInsets.all(4),
              children: List.generate(
                decks.length,
                (index) => Card(
                  color: const Color.fromARGB(255, 111, 186, 205),
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            navigateToFlashcardsScreen(decks[index]);
                          },
                        ),
                        Center(
                          child: Text(
                            decks[index].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 2, 33, 38),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Color.fromARGB(255, 3, 3, 73),
                                onPressed: () {
                                  navigateToEditDeck(decks[index]);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Color.fromARGB(255, 3, 3, 73),
                                onPressed: () {
                                  confirmDeleteDeck(decks[index]);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddDeck();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 83, 171, 186),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(2, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  void navigateToAddDeck() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDeckScreen(),
      ),
    ).then((value) {
      loadDecks();
    });
  }

  void navigateToFlashcardsScreen(Deck deck) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardScrn(deck: deck),
      ),
    );
  }

  void navigateToEditDeck(Deck deck) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDeckScrn(deck: deck),
      ),
    ).then((value) {
      loadDecks();
    });
  }

  void confirmDeleteDeck(Deck deck) {
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color.fromARGB(255, 230, 245, 250),
      title: Row(
        children: [
          Icon(
            Icons.warning,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 8),
          const Text(
            'Delete Deck',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      content: const Text(
        'Confirm deletion of this deck?All related flashcards will be permanently removed.',
        style: TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 1, 23, 27),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 192, 210, 242),
            foregroundColor: const Color.fromARGB(255, 83, 171, 186),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 83, 171, 186),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            await deleteDeck(deck);
          },
          child: const Text(
            'Delete',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  },
);

  }

  Future<void> deleteDeck(Deck deck) async {
    final dbHelper = DBHelper();
    await dbHelper.deleteDeckAndFlashcards(deck.id!);
    loadDecks();
  }
}

class Deck {
  int? id;
  String title;

  Deck({this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class Flashcard {
  int? id;
  int deckId;
  String question;
  String answer;

  Flashcard({
    this.id,
    required this.deckId,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deck_id': deckId,
      'question': question,
      'answer': answer,
    };
  }
}

class AddDeckScreen extends StatefulWidget {
  const AddDeckScreen({super.key});

  @override
  State<AddDeckScreen> createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends State<AddDeckScreen> {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Deck',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 83, 171, 186),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(labelText: 'Enter the Deck Title'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveDeckTitle,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 192, 210, 242),
                foregroundColor: const Color.fromARGB(255, 83, 171, 186),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveDeckTitle() async {
    final dbHelper = DBHelper();
    final newDeck = Deck(title: titleController.text);
    await dbHelper.insertDeck(newDeck);
    Navigator.pop(context);
  }
}
