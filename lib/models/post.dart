// Model untuk data Post dari API
// Ini adalah contoh model sederhana untuk mempelajari struktur data dari API

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // Factory constructor untuk membuat Post dari JSON
  // Method ini mengkonversi data JSON dari API menjadi object Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  // Method untuk mengkonversi Post menjadi JSON
  // Berguna saat melakukan POST atau PUT request
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  // Method untuk membuat copy Post dengan nilai yang diubah
  // Berguna untuk update data
  Post copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  String toString() {
    return 'Post{id: $id, userId: $userId, title: $title, body: $body}';
  }
}
