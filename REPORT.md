# MP Report

## Team

- Name: Mansi Patil


## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [X] iOS simulator / MacOS
  - [ ] Android emulator
- [X] Decks can be created, edited, and deleted
- [X] Cards can be created, edited, sorted, and deleted
- [X] Quizzes work correctly
- [X] Decks and Cards can be loaded from the JSON file
- [X] Decks and Cards are saved/loaded correctly from/to a SQLite database
- [X] The UI is responsive to changes in screen size

## Summary and Reflection

For this flashcard Machine Problem, I made important choices that shaped how it works. I also used the sqflite package to save data, creating separate tables for decks and flashcards that are linked together. This setup made it easier to work with the database. I divided the UI into separate widgets for each page, making the code clearer and easier to manage. However, I struggled with handling database operations asynchronously, particularly with loading states and ensuring the app ran smoothly.

I enjoyed designing the user interface and making it responsive to different screen sizes. However, I found it challenging to ensure the app looked good on all devices. Overall, this project taught me a lot about app design and state management, and I’m proud of what I accomplished, even with some difficulties.
