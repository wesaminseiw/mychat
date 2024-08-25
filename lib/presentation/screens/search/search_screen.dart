import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/logic/services/search_screen_service.dart';
import 'package:mychat/presentation/styles/colors.dart';
import 'package:mychat/presentation/widgets/background_shape.dart';
import 'package:mychat/presentation/widgets/paddings.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  final SearchService searchService = SearchService();
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unfocus(context),
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                  ),
                  painter: CustomShapePainter(context: context),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      height(48),
                      Padding(
                        padding: defaultSidePadding,
                        child: Material(
                          elevation: 5, // Add elevation here
                          borderRadius: BorderRadius.circular(50),
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(
                              color: primaryColor,
                            ),
                            autofocus: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: context.brightness == Brightness.light
                                  ? quaternaryColor
                                  : teritaryColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: isExtended == false
                                    ? BorderRadius.circular(50)
                                    : const BorderRadius.vertical(
                                        top: Radius.circular(30),
                                      ),
                              ),
                              hintText: 'Search..',
                              hintStyle: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onChanged: (value) {
                              _search(value);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : isExtended == true
                                ? SearchService().searchResultsContainer(
                                    context,
                                    searchResults: searchResults,
                                  )
                                : Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() {
        searchResults = [];
        isExtended = false;
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> results =
          await searchService.searchByUsername(searchTerm);
      setState(() {
        searchResults = results.map((doc) {
          final data = doc.data();
          return {
            'displayName': data['displayName'] ?? 'No Display name',
            'username': data['username'] ?? 'No username',
            'profileImageUrl': data['profileImageUrl'] ?? '',
            'uid': doc.id // Document ID as UID
          };
        }).toList();
        isExtended = true;
      });
    } catch (e) {
      print('Search error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
