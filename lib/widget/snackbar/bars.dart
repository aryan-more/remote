import 'package:flutter/material.dart';
import 'package:get/get.dart';

void errorSnackBar({required String title, required String error}) {
  Get.snackbar(
    title,
    error,
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.FLOATING,
    backgroundColor: Colors.red.withAlpha(100),
    margin: const EdgeInsets.only(
      bottom: 20,
      left: 8,
      right: 8,
    ),
  );
}

void successSnackBar({required String title, required String subtitle}) {
  Get.snackbar(
    title,
    subtitle,
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.FLOATING,
    backgroundColor: Colors.green.withAlpha(100),
    margin: const EdgeInsets.only(
      bottom: 20,
      left: 8,
      right: 8,
    ),
  );
}

void workInProgress() => errorSnackBar(title: "Error", error: "Work in progress");
