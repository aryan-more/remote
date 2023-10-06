import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote/remote/content_lazy.dart';

abstract interface class Searchable {
  const Searchable();
  String toSearchLabel();
}

abstract interface class SearchableSelect {
  const SearchableSelect();
  String get onSelected;
}

abstract class RemoteContentBaseSearch<T extends Searchable> extends RemoteContentLazy<T> {
  RemoteContentBaseSearch({T? selected, super.defaultLoad = false, super.updateController = false});
  late final TextEditingController textEditingController;

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

  void onSelect(T? selected);

  String? validator(String? text) {
    return null;
  }
}

abstract class RemoteContentSearch<T extends Searchable> extends RemoteContentBaseSearch<T> {
  RemoteContentSearch({this.selected, super.defaultLoad = false, super.updateController = false});

  T? selected;

  @override
  void onInit() {
    textEditingController = TextEditingController(text: selected is SearchableSelect ? (selected as SearchableSelect?)?.onSelected : selected?.toSearchLabel());
    textEditingController.addListener(() {
      if (selected != null && textEditingController.text == "") {
        selected = null;
        onSelected();
      }
    });
    super.onInit();
  }

  @override
  void onSelect(T? selected) {
    if (this.selected == selected) {
      return;
    }

    this.selected = selected;
    if (selected is SearchableSelect) {
      textEditingController.text = (selected as SearchableSelect?)?.onSelected ?? "";
    } else {
      textEditingController.text = selected?.toSearchLabel() ?? "";
    }
    onSelected();
  }
}

abstract class RemoteContentSearchRx<T extends Searchable> extends RemoteContentBaseSearch<T> {
  RemoteContentSearchRx({T? selected, super.defaultLoad = false, super.updateController = false}) {
    this.selected.value = selected;
  }

  final Rxn<T> selected = Rxn();

  @override
  void onInit() {
    textEditingController = TextEditingController(text: selected.value is SearchableSelect ? (selected.value as SearchableSelect?)?.onSelected : selected.value?.toSearchLabel());
    textEditingController.addListener(() {
      if (selected.value != null && textEditingController.text == "") {
        selected.value = null;
        onSelected();
      }
    });
    super.onInit();
  }

  @override
  void onSelect(T? selected) {
    if (this.selected.value == selected) {
      return;
    }

    this.selected.value = selected;
    if (selected is SearchableSelect) {
      textEditingController.text = (selected as SearchableSelect?)?.onSelected ?? "";
    } else {
      textEditingController.text = selected?.toSearchLabel() ?? "";
    }
    onSelected();
  }
}
