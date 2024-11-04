Flashcards App 📚
A multi-page flashcard application that allows users to create, edit, manage, and quiz themselves on custom flashcard decks! This app combines seamless navigation, responsive design, and persistent storage to deliver an intuitive study tool. Built as part of CS 442 coursework, it offers hands-on experience with navigation, state management, and local persistence techniques.


🌟 Features
. Deck Management
Create, edit, and delete flashcard decks.
Load a starter set of decks from a JSON file for quick setup.

. Flashcard Management
Add, edit, delete, and sort flashcards within specific decks.
Sort cards alphabetically or by creation date.

. Quizzes
Run quizzes from selected decks, with options to shuffle and “peek” at answers.
Track progress with indicators for questions answered and total cards viewed.

. Responsive Design
Adjusts layout based on screen size.
Compact view for mobile and combined views for larger screens.

.Data Persistence
Saves decks and flashcards locally using SQLite, preserving data between sessions.


💻 Tech Stack

Dart & Flutter for the app framework.
SQLite for local data storage.
Provider for state management.
JSON Parsing for loading initial decks.


🚀 Getting Started
Prerequisites
Flutter SDK: Ensure Flutter is installed and up-to-date.
SQLite: No additional installation required as the app uses the sqflite package.
Installation
Clone this repository

git clone https://github.com/your-username/flashcards-app.git

cd flashcards-app

Install dependencies
flutter pub get

Run the app
flutter run


📖 Usage

Deck List Page
View all decks, create a new deck, or load a starter deck from JSON.
Tap a deck to view its cards or use the edit/delete icons for modifications.

Deck Editor Page
Rename the selected deck and save changes.
Optionally delete the deck, which also deletes all contained cards.

Card List Page
View and sort flashcards within the selected deck.
Add, edit, or delete cards.

Card Editor Page
Edit the question and answer for a selected card or delete it if needed.
Quiz Page

Shuffle cards and quiz yourself with “peek” functionality.
Track the number of cards viewed and answers checked.

🧪 Testing
Tested screen sizes range from 320x568 (iPhone 5) to 1920x1080 (1080p). The app is designed to respond smoothly to any screen size within these limits without overflow errors.

Note: Testing should be conducted on macOs/iOS simulators or real devices, as SQLite dependencies may prevent the app from running on a web browser or Windows natively.
