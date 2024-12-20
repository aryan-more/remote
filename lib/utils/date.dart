import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote/remote.dart';

class NoDateRangeUpdate {}

mixin DateRange {
  final Rxn<DateTime> start = Rxn();
  final Rxn<DateTime> end = Rxn();

  DateTime get startFirstDate => DateTime(2023, 4, 1);
  DateTime get startLastDate =>
      end.value ?? DateTime.now().add(const Duration(days: 365 * 10));

  DateTime get endFirstDate => start.value ?? DateTime(2023, 4, 1);
  DateTime get endLastDate =>
      DateTime.now().add(const Duration(days: 365 * 10));

  void pickStartDate() async {
    DateTime? date = await selectDate(
      initialDate: start.value ,
      firstDate: startFirstDate,
      lastDate: startLastDate,
    );
    if (date != null && date != start.value) {
      start.value = date;
      onDateUpdate();
    }
  }

  void pickEndDate() async {
    DateTime? date = await selectDate(
      initialDate: end.value ,
      firstDate: endFirstDate,
      lastDate: endLastDate,
    );
    if (date != null && date != end.value) {
      end.value = date;
      onDateUpdate();
    }
  }

  Future<DateTime?> selectDate({
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDate,
  }) async {
    return await showDatePicker(
      context: Get.context!,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initialDate,
    );
  }

  void onDateUpdate() {
    if (this is NoDateRangeUpdate) {
      return;
    }

    if (this is RemoteContentBaseSearch) {
      return;
    }
    if (this is RemoteContentLazy) {
      (this as RemoteContentLazy).flush();
      return;
    }

    if (this is RemoteContent) {
      (this as RemoteContent).loadData();
      return;
    }
  }
}
