import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin DateRange {
  final Rxn<DateTime> start = Rxn();
  final Rxn<DateTime> end = Rxn();

  DateTime get startFirstDate => DateTime(2023, 4, 1);
  DateTime get startFirstEnd => end.value ?? DateTime.now().add(const Duration(days: 365 * 10));

  DateTime get endFirstDate => start.value ?? DateTime(2023, 4, 1);
  DateTime get endFirstEnd => DateTime.now().add(const Duration(days: 365 * 10));

  void pickStartDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: start.value ?? DateTime.now(),
      firstDate: startFirstDate,
      lastDate: startFirstEnd,
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
      lastDate: endFirstEnd,
    );
    if (date != null && date != end.value) {
      end.value = date;
      onDateUpdate();
    }
  }

  void onDateUpdate() {}
}
