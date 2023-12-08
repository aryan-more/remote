// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:remote/remote/content_search.dart';

class RemoteSearchWidget<T extends RemoteContentBaseSearch>
    extends StatelessWidget {
  const RemoteSearchWidget({
    Key? key,
    this.tag,
    this.decoration,
  }) : super(key: key);
  final String? tag;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: tag,
      builder: (T controller) {
        // TypeAheadField(itemBuilder: itemBuilder, onSelected: onSelected, suggestionsCallback: suggestionsCallback)
        return TypeAheadField(
          onSelected: controller.onSelect,
          itemBuilder: (context, itemData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(itemData.toSearchLabel()),
            );
          },
          autoFlipDirection: true,
          suggestionsCallback: (pattern) =>
              controller.flush().then((value) => controller.data),
          controller: controller.textEditingController,
          builder: (context, tController, focusNode) {
            return TextFormField(
              focusNode: focusNode,
              controller: tController,
              maxLines: 1,
              validator: controller.validator,
              decoration: decoration ??
                  InputDecoration(
                    labelText: controller.hintText,
                  ),
            );
          },
        );
      },
    );
  }
}
