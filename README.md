Flashcards App 📚 </br>
A multi-page flashcard application that allows users to create, edit, manage, and quiz themselves on custom flashcard decks! This app combines seamless navigation, responsive design, and persistent storage to deliver an intuitive study tool. Built as part of CS 442 coursework, it offers hands-on experience with navigation, state management, and local persistence techniques.


🌟 Features  </br>
 **** Deck Management </br> 
Create, edit, and delete flashcard decks.
Load a starter set of decks from a JSON file for quick setup.

 ****Flashcard Management </br>
Add, edit, delete, and sort flashcards within specific decks.
Sort cards alphabetically or by creation date.

**** Quizzes </br>
Run quizzes from selected decks, with options to shuffle and “peek” at answers.
Track progress with indicators for questions answered and total cards viewed.

**** Responsive Design </br>
Adjusts layout based on screen size.
Compact view for mobile and combined views for larger screens.

****Data Persistence </br>
Saves decks and flashcards locally using SQLite, preserving data between sessions.


💻 Tech Stack </br>

Dart & Flutter for the app framework. </br>
SQLite for local data storage. </br>
Provider for state management. </br>
JSON Parsing for loading initial decks. </br>


🚀 Getting Started </br>
Prerequisites </br>
Flutter SDK: Ensure Flutter is installed and up-to-date. </br>
SQLite: No additional installation required as the app uses the sqflite package. </br>
Installation: </br>
Clone this repository </br>

git clone https://github.com/your-username/flashcards-app.git </br>

cd flashcards-app </br>

Install dependencies </br>
flutter pub get </br>

Run the app </br>
flutter run </br>


📖 Usage

****Deck List Page </br>
View all decks, create a new deck, or load a starter deck from JSON.
Tap a deck to view its cards or use the edit/delete icons for modifications.

****Deck Editor Page </br>
Rename the selected deck and save changes.
Optionally delete the deck, which also deletes all contained cards.

****Card List Page </br>
View and sort flashcards within the selected deck.
Add, edit, or delete cards.

****Card Editor Page </br>
Edit the question and answer for a selected card or delete it if needed.

****Quiz Page </br>
Shuffle cards and quiz yourself with “peek” functionality.
Track the number of cards viewed and answers checked.

🧪 Testing </br>
Tested screen sizes range from 320x568 (iPhone 5) to 1920x1080 (1080p). The app is designed to respond smoothly to any screen size within these limits without overflow errors. </br>

**Note: Testing should be conducted on macOs/iOS simulators or real devices, as SQLite dependencies may prevent the app from running on a web browser or Windows natively.
