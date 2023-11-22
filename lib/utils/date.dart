import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote/remote.dart';

mixin DateRange {
  final Rxn<DateTime> start = Rxn();
  final Rxn<DateTime> end = Rxn();

  DateTime get startFirstDate => DateTime(2023, 4, 1);
  DateTime get startLastDate => end.value ?? DateTime.now().add(const Duration(days: 365 * 10));

  DateTime get endFirstDate => start.value ?? DateTime(2023, 4, 1);
  DateTime get endLastDate => DateTime.now().add(const Duration(days: 365 * 10));

  void pickStartDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: start.value ?? DateTime.now(),
      firstDate: startFirstDate,
      lastDate: startLastDate,
    );
    if (date != null && date != start.value) {
      start.value = date;
      onDateUpdate();
    }
  }

  void pickEndDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: end.value ?? DateTime.now(),
      firstDate: endFirstDate,
      lastDate: endLastDate,
    );
    if (date != null && date != end.value) {
      end.value = date;
      onDateUpdate();
    }
  }

  void onDateUpdate() {
    if (this is RemoteContentBaseSearch) {
      return;
    }
    if (this is RemoteContentLazy) {
      (this as RemoteContentLazy).flush();
      return;
    }

    if (this is RemoteContent) {
      (this as RemoteContentLazy).loadData();
      return;
    }
  }
}
