import 'package:flutter/material.dart';
import 'quiztime.dart';
import 'flashedit.dart';
import 'database_helper.dart';
import 'dart:math';
import 'decklist.dart';

class FlashcardScrn extends StatefulWidget {
  final Deck deck;

  const FlashcardScrn({required this.deck});

  @override
  _FlashcardScrnState createState() => _FlashcardScrnState();
}

class _FlashcardScrnState extends State<FlashcardScrn> {
  List<Flashcard> flashcards = [];
  List<Flashcard> originalFlashcards = []; 
  bool ascendingOrder = false;
  Map<int, bool> showAnswer = {};

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  void loadFlashcards() async {
    final dbHelper = DBHelper();
    final loadedFlashcards =
        await dbHelper.getFlashcardsByDeckId(widget.deck.id!);

    setState(() {
      flashcards = loadedFlashcards;
      originalFlashcards = List.from(loadedFlashcards);
      showAnswer = {for (var fc in flashcards) fc.id!: false};
    });
  }

  void toggleSortOrder() {
    setState(() {
      if (ascendingOrder) {
        flashcards = List.from(originalFlashcards);
      } else {
        flashcards.sort((a, b) => a.question.compareTo(b.question));
      }
      ascendingOrder = !ascendingOrder;
    });
  }

  void toggleShowAnswer(int flashcardId) {
    setState(() {
      showAnswer[flashcardId] = !showAnswer[flashcardId]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth ~/ 200;
    crossAxisCount = crossAxisCount > 0 ? crossAxisCount : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcards',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 111, 186, 205),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.sort_by_alpha,
              color: const Color.fromARGB(255, 111, 186, 205),
              size: 28,
            ),
            onPressed: toggleSortOrder,
          ),
          IconButton(
            icon: const Icon(
              Icons.assignment,
              color: const Color.fromARGB(255, 111, 186, 205),
              size: 28,
            ),
            onPressed: navigateToQuizTime,
          ),
        ],
        centerTitle: true,
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.2,
          ),
          itemCount: flashcards.length,
          itemBuilder: (context, index) {
            final flashcard = flashcards[index];
            return Card(
              color: const Color.fromARGB(255, 111, 186, 205),
              child: Stack(
               
                children: [
                  InkWell(
                    onTap: () {
                      toggleShowAnswer(flashcard.id!);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            showAnswer[flashcard.id!] == true
                                ? flashcard.answer
                                : flashcard.question,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 2, 33, 38),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () {
                        navigateToEditFlashcard(flashcard);
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddFlashcard,
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

  void navigateToAddFlashcard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFlashcardScrn(deck: widget.deck),
      ),
    ).then((value) {
      loadFlashcards();
    });
  }

  void navigateToQuizTime() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizTimeScrn(
          flashcards: flashcards,
        ),
      ),
    );
  }

  void navigateToEditFlashcard(Flashcard flashcard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashEditScrn(flashcard: flashcard),
      ),
    ).then((value) {
      loadFlashcards();
    });
  }
}

class AddFlashcardScrn extends StatefulWidget {
  final Deck deck;

  const AddFlashcardScrn({required this.deck, super.key});

  @override
  State<AddFlashcardScrn> createState() => _AddFlashcardScrnState();
}

class _AddFlashcardScrnState extends State<AddFlashcardScrn> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Flashcard',
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
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 22),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: saveFlashcard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 192, 210, 242),
                foregroundColor: const Color.fromARGB(255, 83, 171, 186),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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

  void saveFlashcard() async {
    final dbHelper = DBHelper();
    final newFlashcard = Flashcard(
      deckId: widget.deck.id!,
      question: questionController.text,
      answer: answerController.text,
    );
    await dbHelper.insertFlashcard(newFlashcard);
    Navigator.pop(context);
  }
}
