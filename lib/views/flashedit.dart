import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'decklist.dart';

class FlashEditScrn extends StatefulWidget {
  final Flashcard flashcard;

  const FlashEditScrn({required this.flashcard, super.key});

  @override
  State<FlashEditScrn> createState() => _FlashEditScrnState(flashcard);
}

class _FlashEditScrnState extends State<FlashEditScrn> {
  final Flashcard flashcard;
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  _FlashEditScrnState(this.flashcard);

  @override
  void initState() {
    super.initState();
    questionController.text = flashcard.question;
    answerController.text = flashcard.answer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Flashcard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveFlashcardContent();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 192, 210, 242),
                    foregroundColor: const Color.fromARGB(255, 83, 171, 186),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
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
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    deleteFlashcard();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 192, 210, 242),
                    foregroundColor: const Color.fromARGB(255, 83, 171, 186),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveFlashcardContent() async {
    final dbHelper = DBHelper();
    await dbHelper.updateFlashcardContent(
      flashcard.id!,
      questionController.text,
      answerController.text,
    );
    Navigator.pop(context);
  }

  void deleteFlashcard() async {
    final dbHelper = DBHelper();
    await dbHelper.deleteFlashcard(flashcard.id!);
    Navigator.pop(context);
  }
}
