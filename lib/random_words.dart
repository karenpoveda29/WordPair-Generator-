import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _randomWordPairs = <WordPair>[];
  final Set<WordPair> _savedWordPairs = <WordPair>{};

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext context, int item) {
          if (item.isOdd) return const Divider();

          final index = item ~/ 2;

          if (index >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordPairs[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _savedWordPairs.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  // Saved page
  void _pushedSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPairs.map(
        // Why iterable listTile
        (WordPair pair) {
          return ListTile(
              title: Text(pair.asPascalCase,
                  style: const TextStyle(fontSize: 16)));
        },
      );

      final List<Widget> dividedTiles =
          ListTile.divideTiles(context: context, tiles: tiles)
              .toList(); //What is context?

      return Scaffold(
          appBar: AppBar(title: const Text('Saved WordPairs')),
          body: ListView(children: dividedTiles));
    }));
  }

  // Home page
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              const Text('WordPair generator'), // Why is const necessary here?
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.list), onPressed: _pushedSaved)
          ],
        ),
        body: _buildList());
  }
}
