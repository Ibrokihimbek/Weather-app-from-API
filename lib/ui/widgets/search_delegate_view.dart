import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchDelegateView extends SearchDelegate {
  SearchDelegateView({required this.suggestionList});

  final List<String> suggestionList;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: const Color.fromARGB(255, 249, 226, 199),
        toolbarTextStyle: const TextTheme(
          headline6: TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ).bodyText2,
        titleTextStyle: const TextTheme(
          
          headline6: TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ).headline6,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Color.fromARGB(255, 249, 226, 199),
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
          color: Colors.black54,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: const TextStyle(fontSize: 24),
      ),
      
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = suggestionList.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFEEACF),
            Color(0xFFFEBB80),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            suggestions.length,
            (index) => GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFFEBB80),
                        blurRadius: 4,
                        offset: Offset(4, 8), // Shadow position
                      ),
                    ],
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xFFFEEACF)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  suggestions[index],
                  style: const TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ),
              onTap: () {
                query = suggestions[index];
                close(context, query);
              },
            ),
          ),
        ),
      ),
    );
  }
}
