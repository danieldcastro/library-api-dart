import 'package:collection/collection.dart';
import 'package:vania/vania.dart';

import '../utils/enums/book_format_enum.dart';

class Book extends Model {
  final String? title;
  final String? subtitle;
  final List<String?>? authors;
  final String? isbn;
  final String? synopsis;
  final String? publisher;
  final int? year;
  final BookFormatEnum? format;
  final int? pages;
  final List<String>? subjects;
  final String? location;

  Book({
    this.title,
    this.subtitle,
    this.authors,
    this.isbn,
    this.synopsis,
    this.publisher,
    this.year,
    this.format,
    this.pages,
    this.subjects,
    this.location,
  }) {
    super.table('books');
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'isbn': final String? isbn,
        'title': final String? title,
        'subtitle': final String? subtitle,
        'authors': final List? authors,
        'publisher': final String? publisher,
        'synopsis': final String? synopsis,
        'year': final int? year,
        'format': final String? format,
        'page_count': final int? pages,
        'subjects': final List? subjects,
        'location': final String? location
      } =>
        Book(
          title: title,
          subtitle: subtitle,
          authors: authors?.map((e) => e as String).toList(),
          isbn: isbn,
          synopsis: synopsis,
          publisher: publisher,
          year: year,
          format: BookFormatEnum.values.firstWhereOrNull(
            (e) => e.value == format,
          ),
          pages: pages,
          subjects: subjects?.map((e) => e as String).toList(),
          location: location,
        ),
      _ => throw ArgumentError('Invalid JSON'),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'authors': authors,
      'isbn': isbn,
      'synopsis': synopsis,
      'publisher': publisher,
      'year': year,
      'format': format?.value,
      'pages': pages,
      'subjects': subjects,
      'location': location,
    };
  }
}
