import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/presentation/screens/chat/chat_screen.dart';
import 'package:mychat/presentation/styles/colors.dart';
import 'package:mychat/presentation/widgets/paddings.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchByUsername(
    String username,
  ) async {
    String currentUserId = _auth.currentUser?.uid ?? '';

    if (currentUserId.isEmpty) {
      throw Exception("User is not authenticated");
    }

    // Perform a query to find documents where the username matches the search term
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: username)
        .where('username', isLessThanOrEqualTo: username + '\uf8ff')
        .get();

    // Filter out the current user from the results
    List<QueryDocumentSnapshot<Map<String, dynamic>>> results = snapshot.docs
        .where((doc) =>
            doc.id != currentUserId) // Exclude the current user's document
        .toList();

    return results;
  }

  void search({
    required String searchTerm,
    required List<Map<String, dynamic>> searchResults,
    required bool isExtended,
    required bool isLoading,
  }) async {
    final SearchService searchService = SearchService();

    if (searchTerm.isEmpty) {
      searchResults = [];
      isExtended = false;
      isLoading = false;
      return;
    }

    isLoading = true;

    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> results =
          await searchService.searchByUsername(searchTerm);
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
    } catch (e) {
      print('Search error: $e');
    } finally {
      isLoading = false;
    }
  }

  Widget searchResultsContainer(
    BuildContext context, {
    required List<Map<String, dynamic>> searchResults,
  }) {
    return Padding(
      padding: defaultSidePadding.copyWith(
        bottom: 36,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.brightness == Brightness.light
              ? quaternaryColor
              : teritaryColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        child: searchResults.isNotEmpty
            ? ListView.separated(
                itemCount: searchResults.length,
                separatorBuilder: (context, index) => height(8),
                itemBuilder: (context, index) {
                  Map<String, dynamic> user = searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      push(
                        context,
                        page: ChatScreen(
                          receiverUsername: user['username'] ?? 'Unknown',
                          receiverUserId: user['uid'] ?? 'Unknown',
                          receiverDisplayName: user['displayName'] ?? 'Unknown',
                          receiverProfileImage: user['profileImageUrl'] ?? '',
                        ),
                      );
                    },
                    child: Padding(
                      padding: defaultSidePadding,
                      child: Card(
                        color: context.colorScheme.secondary,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user['profileImageUrl'].isNotEmpty
                                ? NetworkImage(user['profileImageUrl'])
                                : null,
                            child: user['profileImageUrl'].isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 36,
                                    color: Colors.grey[600],
                                  )
                                : null,
                          ),
                          title: Text(
                            user['displayName'],
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: teritaryColor,
                            ),
                          ),
                          titleTextStyle:
                              context.textTheme.headlineLarge, // TODO
                          subtitle: Text('@${user['username']}'),
                          subtitleTextStyle:
                              context.textTheme.labelSmall?.copyWith(
                            color: Colors.grey[400],
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'No users found',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontSize: 26,
                    color: context.colorScheme.secondary,
                  ),
                ),
              ),
      ),
    );
  }
}
