import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/movie_record.dart';

class HiveService {
  HiveService._();

  static final HiveService _instance = HiveService._();

  factory HiveService() => _instance;

  static const String _favouritesPrefix = 'favourites_';
  static const String _watchNowPrefix = 'watch_now_';
  static const String _watchLaterPrefix = 'watch_later_';
  static const String _watchedPrefix = 'watched_';

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieRecordAdapter());
    }
  }

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user is logged in.');
    }

    return user.uid;
  }

  String get _favouritesBoxName => '$_favouritesPrefix$_uid';

  String get _watchNowBoxName => '$_watchNowPrefix$_uid';

  String get _watchLaterBoxName => '$_watchLaterPrefix$_uid';

  String get _watchedBoxName => '$_watchedPrefix$_uid';

  Future<void> openUserBoxes() async {
    await Hive.openBox<MovieRecord>(_favouritesBoxName);
    await Hive.openBox<MovieRecord>(_watchNowBoxName);
    await Hive.openBox<MovieRecord>(_watchLaterBoxName);
    await Hive.openBox<MovieRecord>(_watchedBoxName);
  }

  Future<void> closeUserBoxes() async {
    if (Hive.isBoxOpen(_favouritesBoxName)) {
      await Hive.box<MovieRecord>(_favouritesBoxName).close();
    }

    if (Hive.isBoxOpen(_watchNowBoxName)) {
      await Hive.box<MovieRecord>(_watchNowBoxName).close();
    }

    if (Hive.isBoxOpen(_watchLaterBoxName)) {
      await Hive.box<MovieRecord>(_watchLaterBoxName).close();
    }

    if (Hive.isBoxOpen(_watchedBoxName)) {
      await Hive.box<MovieRecord>(_watchedBoxName).close();
    }
  }

  Box<MovieRecord> get _favouritesBox {
    return Hive.box<MovieRecord>(_favouritesBoxName);
  }

  Box<MovieRecord> get _watchNowBox {
    return Hive.box<MovieRecord>(_watchNowBoxName);
  }

  Box<MovieRecord> get _watchLaterBox {
    return Hive.box<MovieRecord>(_watchLaterBoxName);
  }

  Box<MovieRecord> get _watchedBox {
    return Hive.box<MovieRecord>(_watchedBoxName);
  }


  Future<void> addFavourite(MovieRecord movie) async {
    await _favouritesBox.put(movie.id, movie);
  }

  Future<void> removeFavourite(int id) async {
    await _favouritesBox.delete(id);
  }

  bool isFavourite(int id) {
    return _favouritesBox.containsKey(id);
  }

  List<MovieRecord> getFavourites() {
    return _favouritesBox.values.toList();
  }


  Future<void> addWatchNow(MovieRecord movie) async {
    await _watchNowBox.put(movie.id, movie);
  }

  Future<void> removeWatchNow(int id) async {
    await _watchNowBox.delete(id);
  }

  bool isWatchNow(int id) {
    return _watchNowBox.containsKey(id);
  }

  List<MovieRecord> getWatchNow() {
    return _watchNowBox.values.toList();
  }


  Future<void> addWatchLater(MovieRecord movie) async {
    await _watchLaterBox.put(movie.id, movie);
  }

  Future<void> removeWatchLater(int id) async {
    await _watchLaterBox.delete(id);
  }

  bool isWatchLater(int id) {
    return _watchLaterBox.containsKey(id);
  }

  List<MovieRecord> getWatchLater() {
    return _watchLaterBox.values.toList();
  }


  Future<void> addWatched(MovieRecord movie) async {
    await _watchedBox.put(movie.id, movie);
  }

  Future<void> removeWatched(int id) async {
    await _watchedBox.delete(id);
  }

  bool isWatched(int id) {
    return _watchedBox.containsKey(id);
  }

  List<MovieRecord> getWatched() {
    return _watchedBox.values.toList();
  }
}