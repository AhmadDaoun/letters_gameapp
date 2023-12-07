import 'package:flutter/material.dart';

class LetterCard extends StatelessWidget {
  final String? letter;
  final String? imagePath;

  const LetterCard({this.letter, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: letter != null
            ? Center(
          child: Text(
            letter!,
            style: TextStyle(fontSize: 24.0),
          ),
        )
            : (imagePath != null
            ? Image(
          image: AssetImage(imagePath!), // Use AssetImage here
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        )
            : Center(
          child: Text(
            "???",
            style: TextStyle(fontSize: 24.0),
          ),
        )),
      ),
    );
  }
}



class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  Map<String, String> originalLetterImageMap = {
    'A': 'assets/apple.jpg',
    'B': 'assets/banana.jpg',
    'C': 'assets/car.jpg',
    'D': 'assets/duck.jpg',
    'E': 'assets/elephant.jpg',
    'F': 'assets/flower.jpg',
    'G': 'assets/grapes.jpg',
    'H': 'assets/hat.jpg',
    'I': 'assets/ice_cream.jpg',
    'J': 'assets/jellyfish.jpg',
    'K': 'assets/key.jpg',
    'L': 'assets/lion.jpg',
    'M': 'assets/moon.jpg',
    'N': 'assets/nest.jpg',
    'O': 'assets/orange.jpg',
    'P': 'assets/penguin.jpg',
    'Q': 'assets/queen.jpg',
    'R': 'assets/rainbow.jpg',
    'S': 'assets/sun.jpg',
    'T': 'assets/tiger.jpg',
    'U': 'assets/umbrella.jpg',
    'V': 'assets/violin.jpg',
    'W': 'assets/watermelon.jpg',
    'X': 'assets/xylophone.jpg',
    'Y': 'assets/yak.jpg',
    'Z': 'assets/zebra.jpg',
  };

  List<String> currentLetters = [];
  List<String> currentImages = [];

  List<String> allCards = [];
  List<bool> flipped = [];

  List<String> matchedValues = [];

  int? firstCardIndex;
  int? secondCardIndex;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      // Reset the current game data
      currentLetters.clear();
      currentImages.clear();

      // Select random 5 unique letters and their corresponding images
      currentLetters = originalLetterImageMap.keys.toList()..shuffle();
      currentLetters = currentLetters.sublist(0, 5);
      currentImages = currentLetters.map((letter) => originalLetterImageMap[letter] ?? '').toList();

      // Create a list of all cards (letters and images)
      allCards.clear();
      allCards.addAll(currentLetters);
      allCards.addAll(currentImages);

      // Shuffle the cards
      allCards.shuffle();

      // Initialize the flipped state for each card
      flipped = List.generate(allCards.length, (index) => false);

      // Clear the selected cards indices and matched values
      firstCardIndex = null;
      secondCardIndex = null;
      matchedValues.clear();
    });
  }

  void _checkForMatches() {
    if (firstCardIndex != null && secondCardIndex != null) {
      // Get the values (letter and image) of the selected cards
      String card1 = allCards[firstCardIndex!];
      String card2 = allCards[secondCardIndex!];

      // Check if the selected cards correspond to each other
      bool isMatched = false;

      if (currentLetters.contains(card1) && currentImages.contains(card2) && originalLetterImageMap[card1] == card2) {
        isMatched = true;
      } else if (currentImages.contains(card1) && currentLetters.contains(card2) && originalLetterImageMap[card2] == card1) {
        isMatched = true;
      }

      // Cards match, keep them displayed
      if (isMatched) {
        matchedValues.addAll([card1, card2]);

        // Clear the selected cards indices
        firstCardIndex = null;
        secondCardIndex = null;

        // Check for game completion
        _checkGameCompletion();
      } else {
        // Cards don't match, flip them back after a delay
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            flipped[firstCardIndex!] = false;
            flipped[secondCardIndex!] = false;
            firstCardIndex = null;
            secondCardIndex = null;
          });
        });
      }
    }
  }


  void _checkGameCompletion() {
    // Check if all cards are flipped
    if (flipped.every((card) => card)) {
      // All cards are flipped, show a dialog and start a new game
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You matched all the letters and images.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startNewGame();
                },
                child: Text('Play Again'),
              ),
            ],
          );
        },
      );
    }
  }

  void _onCardTap(int index) {
    setState(() {
      // Check if the tapped card is already flipped or if two cards are already flipped
      if (flipped[index] || (firstCardIndex != null && secondCardIndex != null)) {
        return;
      }

      // Flip the card
      flipped[index] = true;

      // Update the selected card index
      if (firstCardIndex == null) {
        firstCardIndex = index;
      } else {
        secondCardIndex = index;

        // Check for matches after the second card is tapped
        _checkForMatches();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letters Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: allCards.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Handle card tap
                _onCardTap(index);
              },
              child: AspectRatio(
                aspectRatio: 1.0, // Adjust this ratio as needed
                child: LetterCard(
                  // Show card content only if it's flipped or matched
                  letter: matchedValues.contains(allCards[index]) || flipped[index] ? allCards[index] : "???",
                  imagePath: flipped[index] ? originalLetterImageMap[allCards[index]] : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}