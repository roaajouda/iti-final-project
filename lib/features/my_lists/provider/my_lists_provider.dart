import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/movie.record.dart';
import '../controller/my_lists_controller.dart';

enum MyListsState { idle, loading, error, success }

enum ListTab { watched, watching, wantToWatch }

class MyListsProvider extends ChangeNotifier {
  final MyListsController _controller = MyListsController();

  MyListsState state = MyListsState.idle;
  ListTab activeTab = ListTab.watched;

  List<MovieRecord> watched = [];
  List<MovieRecord> watching = [];
  List<MovieRecord> wantToWatch = [];

  List<MovieRecord> get currentList {
    switch (activeTab) {
      case ListTab.watched:
        return watched;
      case ListTab.watching:
        return watching;
      case ListTab.wantToWatch:
        return wantToWatch;
    }
  }

  Future<void> loadLists() async {
    state = MyListsState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _controller.getWatched(),
        _controller.getWatching(),
        _controller.getWantToWatch(),
      ]);

      watched = results[0];
      watching = results[1];
      wantToWatch = results[2];
      state = MyListsState.success;
    } catch (_) {
      state = MyListsState.error;
    }

    notifyListeners();
  }

  void setTab(ListTab tab) {
    activeTab = tab;
    notifyListeners();
  }
}