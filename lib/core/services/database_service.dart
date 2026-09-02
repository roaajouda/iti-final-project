import 'package:flutter/foundation.dart';
import 'package:flutter_application_2/models/movie.record.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;

      return databaseFactory.openDatabase(
        'movies_app.db',
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movies_app.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    const columnDef = '''
      id            INTEGER PRIMARY KEY,
      title         TEXT NOT NULL,
      poster_path   TEXT,
      release_year  INTEGER,
      vote_average  REAL NOT NULL DEFAULT 0
    ''';

    for (final table in ['favourites', 'watch_now', 'watch_later', 'watched']) {
      await db.execute('CREATE TABLE $table ($columnDef)');
    }
  }

  // ── Generic helpers ─────────────────────────────────────────────

  Future<void> _insert(String table, MovieRecord movie) async {
    final db = await database;

    await db.insert(
      table,
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _delete(String table, int movieId) async {
    final db = await database;

    await db.delete(table, where: 'id = ?', whereArgs: [movieId]);
  }

  Future<bool> _exists(String table, int movieId) async {
    final db = await database;

    final rows = await db.query(
      table,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [movieId],
      limit: 1,
    );

    return rows.isNotEmpty;
  }

  Future<List<MovieRecord>> _getAll(String table) async {
    final db = await database;

    final rows = await db.query(table, orderBy: 'rowid DESC');

    return rows.map(MovieRecord.fromMap).toList();
  }

  // ── Favourites ──────────────────────────────────────────────────

  Future<void> addFavourite(MovieRecord movie) => _insert('favourites', movie);

  Future<void> removeFavourite(int id) => _delete('favourites', id);

  Future<bool> isFavourite(int id) => _exists('favourites', id);

  Future<List<MovieRecord>> getFavourites() => _getAll('favourites');

  // ── Watch Now ───────────────────────────────────────────────────

  Future<void> addWatchNow(MovieRecord movie) => _insert('watch_now', movie);

  Future<void> removeWatchNow(int id) => _delete('watch_now', id);

  Future<bool> isWatchNow(int id) => _exists('watch_now', id);

  Future<List<MovieRecord>> getWatchNow() => _getAll('watch_now');

  // ── Watch Later ─────────────────────────────────────────────────

  Future<void> addWatchLater(MovieRecord movie) =>
      _insert('watch_later', movie);

  Future<void> removeWatchLater(int id) => _delete('watch_later', id);

  Future<bool> isWatchLater(int id) => _exists('watch_later', id);

  Future<List<MovieRecord>> getWatchLater() => _getAll('watch_later');

  // ── Watched ─────────────────────────────────────────────────────

  Future<void> addWatched(MovieRecord movie) => _insert('watched', movie);

  Future<void> removeWatched(int id) => _delete('watched', id);

  Future<bool> isWatched(int id) => _exists('watched', id);

  Future<List<MovieRecord>> getWatched() => _getAll('watched');
}
