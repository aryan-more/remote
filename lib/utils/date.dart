import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin DateRange {
  final Rxn<DateTime> start = Rxn();
  final Rxn<DateTime> end = Rxn();

  void pickStartDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: start.value ?? DateTime.now(),
      firstDate: DateTime(2023, 4, 1),
      lastDate: end.value ?? DateTime.now().add(const Duration(days: 365 * 10)),
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
      firstDate: start.value ?? DateTime(2023, 4, 1),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (date != null && date != end.value) {
      end.value = date;
      onDateUpdate();
    }
  }

  void onDateUpdate() {}
}
