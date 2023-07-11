import 'package:flutter/material.dart';
import 'package:remote/remote/content_lazy.dart';

abstract class Searchable {
  String toSearchLabel();
}

abstract class RemoteContentSearch<T extends Searchable> extends RemoteContentLazy<T> {
  RemoteContentSearch({this.selected, super.defaultLoad = false, super.updateController = false});
  late final TextEditingController textEditingController;
  T? selected;
  String get hintText;

  String get selectedSearch;

  final List<RemoteContentLazy> controllers = [];

  void addSearchListener(RemoteContentLazy controller) {
    controllers.add(controller);
  }

  void removeSearchListener(RemoteContentLazy controller) {
    controllers.remove(controller);
  }

  @override
  void onInit() {
    textEditingController = TextEditingController(text: selected?.toSearchLabel());
    textEditingController.addListener(() {
      if (selected != null && textEditingController.text == "") {
        selected = null;
        onSelected();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    controllers.clear();
    textEditingController.dispose();
    super.onClose();
  }

  void onSelected() {
    for (var controller in controllers) {
      controller.flush();
    }
  }

  void onSelect(T? selected) {
    if (this.selected == selected) {
      return;
    }

    this.selected = selected;
    textEditingController.text = selected?.toSearchLabel() ?? "";
    onSelected();
  }

  String? validator(String? text) {
    return null;
  }
}
