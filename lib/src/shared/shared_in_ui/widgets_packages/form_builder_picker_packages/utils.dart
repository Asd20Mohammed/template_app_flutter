enum DeletedFile { images, videos, docs, singleArticleLink, singleArticleCard }

typedef OnDelete = Future<bool> Function(String url, DeletedFile deletedFile);
