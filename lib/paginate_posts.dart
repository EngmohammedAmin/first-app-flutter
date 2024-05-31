class PaginatedPosts {
  final List<Post> posts;
  final int currentPage;
  final int totalPages;

  PaginatedPosts({
    required this.posts,
    required this.currentPage,
    required this.totalPages,
  });
}

class Post {
  final int id;
  final String name;
  // ignore: prefer_typing_uninitialized_variables
  final creatAt;
  // final String body;

  Post({
    required this.id,
    required this.name,
    required this.creatAt,
    // required this.body,
  });
}
