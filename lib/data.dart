import 'package:bookshelf/models/Book.dart';
import 'package:bookshelf/models/BookCategory.dart';

List<BookCategory> allBooksCategories = [
  BookCategory(
    id: 1,
    name: "khmer",
  ),
  BookCategory(
    id: 2,
    name: "Romance",
  ),
  BookCategory(
    id: 3,
    name: "General Education",
  ),
];

List<Book> allBooks = [
  Book(
    id: 1,
    author: "Jack Brannigan",
    published: "October 2000",
    title: "The Secrets of Success and Happiness",
    categoryId: 3,
    pdfUrl: "http://home.sums.ac.ir/~shafieian/files/success.pdf",
    pages: 23,
    views: 0,
  ),
  Book(
    id: 2,
    author: "ជា គីមអៀង",
    published: "22 February 2002",
    title: "ជីវ​វិទ្យា​ សំនួរ​-ចម្លើយ",
    categoryId: 3,
    pdfUrl: "https://drive.google.com/file/d/0B6PFH-cFZihVRWliZEw5Q3FyaGs",
    pages: 151,
    views: 0,
  ),
  Book(
    id: 3,
    title: "The Secrets of Success and Happiness",
    categoryId: 4,
    pdfUrl: "https://drive.google.com/file/d/1D3BhdYfFQMJha62qFBORVxg3IxcPilCf",
    pages: 54,
    views: 0,
  ),
];
