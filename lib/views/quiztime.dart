import 'package:flutter/material.dart';
import 'decklist.dart';

class QuizTimeScrn extends StatefulWidget {
  final List<Flashcard> flashcards;

  const QuizTimeScrn({required this.flashcards, Key? key}) : super(key: key);

  @override
  State<QuizTimeScrn> createState() => _QuizTimeScrnState(flashcards);
}

class _QuizTimeScrnState extends State<QuizTimeScrn> {
  List<Flashcard> flashcards;
  int currentFlashcardIndex = 0;
  bool isFlipped = false;

  int seen = 1;
  int flip = 0;
  int peek = 0;
  int answer = 1;

  List<Flashcard> shuffledFlashcards = [];
  List<int> flippedCards = [];
  List<int> seenedCards = [0];

  _QuizTimeScrnState(this.flashcards);

  @override
  void initState() {
    super.initState();
    shuffledFlashcards = List<Flashcard>.from(widget.flashcards)..shuffle();
  }

  void showPreviousFlashcard() {
    if (currentFlashcardIndex > 0) {
      setState(() {
        currentFlashcardIndex--;
        if (!seenedCards.contains(currentFlashcardIndex)) {
          seen++;
          seenedCards.add(currentFlashcardIndex);
        }
        isFlipped = false;
        answer = seen;
      });
    } else {
      setState(() {
        currentFlashcardIndex = shuffledFlashcards.length - 1;
        if (!seenedCards.contains(currentFlashcardIndex)) {
          seen++;
          seenedCards.add(currentFlashcardIndex);
        }
        isFlipped = false;
        answer = seen;
      });
    }
  }

  void showNextFlashcard() {
    if (currentFlashcardIndex < shuffledFlashcards.length - 1) {
      setState(() {
        currentFlashcardIndex++;
        if (!seenedCards.contains(currentFlashcardIndex)) {
          seen++;
          seenedCards.add(currentFlashcardIndex);
        }
        isFlipped = false;
        answer = seen;
      });
    } else {
      setState(() {
        currentFlashcardIndex = 0;
        if (!seenedCards.contains(currentFlashcardIndex)) {
          seen++;
          seenedCards.add(currentFlashcardIndex);
        }
        isFlipped = false;
        answer = seen;
      });
    }
  }

  void toggleAnswerReveal() {
    setState(() {
      isFlipped = !isFlipped;
      if (isFlipped &&
          seenedCards.contains(currentFlashcardIndex) &&
          !flippedCards.contains(currentFlashcardIndex)) {
        flip++;
        answer = seen;
        flippedCards.add(currentFlashcardIndex);
        peek++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Time',
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isFlipped
                      ? const Color.fromARGB(255, 28, 141, 143)
                      : const Color.fromARGB(255, 111, 186, 205),
                  border:
                      Border.all(color: const Color.fromARGB(255, 15, 48, 215)),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  isFlipped
                      ? shuffledFlashcards[currentFlashcardIndex].answer
                      : shuffledFlashcards[currentFlashcardIndex].question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_sharp),
                    onPressed: showPreviousFlashcard,
                    color: const Color.fromARGB(255, 83, 171, 186),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flip_to_front_outlined),
                    onPressed: toggleAnswerReveal,
                    color: const Color.fromARGB(255, 83, 171, 186),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_sharp),
                    onPressed: showNextFlashcard,
                    color: const Color.fromARGB(255, 83, 171, 186),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                'Seen: $seen out of ${shuffledFlashcards.length} cards',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 83, 171, 186)),
              ),
              Text(
                'Peeked at $peek out of $answer answers',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 83, 171, 186)),
              ),
            ],
          );
        },
      ),
    );
  }
}
