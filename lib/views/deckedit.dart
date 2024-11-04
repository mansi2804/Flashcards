import 'package:flutter/material.dart';
import 'decklist.dart';
import 'database_helper.dart';

class EditDeckScrn extends StatefulWidget {
  final Deck deck;

  const EditDeckScrn({required this.deck});

  @override
  State<EditDeckScrn> createState() => _EditDeckScrnState(deck);
}

class _EditDeckScrnState extends State<EditDeckScrn> {
  final Deck deck;
  TextEditingController titleController = TextEditingController();

  _EditDeckScrnState(this.deck);

  @override
  void initState() {
    super.initState();
    titleController.text = deck.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Deck',
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
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Deck Title'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveDeckTitle();
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
                    deleteDeck();
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

  void saveDeckTitle() async {
    final dbHelper = DBHelper();
    await dbHelper.updateDeckTitle(deck.id!, titleController.text);
    Navigator.pop(context);
  }

  void deleteDeck() async {
    final dbHelper = DBHelper();
    await dbHelper.deleteDeck(deck.id!);
    Navigator.pop(context);
  }
}
