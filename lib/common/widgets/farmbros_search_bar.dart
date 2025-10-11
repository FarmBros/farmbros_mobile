import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FarmbrosSearchBar extends StatelessWidget {
  final TextEditingController searchQuery;
  final List searchResults;
  final String hintText;
  final Function(String)? onChanged;
  final Widget Function(dynamic)? resultBuilder;

  const FarmbrosSearchBar({
    super.key,
    required this.searchQuery,
    required this.searchResults,
    this.hintText = "Enter search query",
    this.onChanged,
    this.resultBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      textStyle: TextStyle(
          color: ColorUtils.inActiveColor,
          fontWeight: FontWeight.bold,
          fontSize: 16),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          spacing: 5,
          children: [
            Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.search_24_regular,
                  color: ColorUtils.inActiveColor,
                ),
                Flexible(
                  child: TextField(
                    controller: searchQuery,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorUtils.secondaryBackgroundColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: ColorUtils.primaryBorderColor)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: ColorUtils.primaryBorderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: ColorUtils.activeBorderColor)),
                        hintText: hintText),
                  ),
                )
              ],
            ),
            if (searchResults.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ColorUtils.primaryBorderColor)),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  children: [
                    Text("Search Results for '${searchQuery.text}'"),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return resultBuilder != null
                              ? resultBuilder!(searchResults[index])
                              : ListTile(
                                  title: Text(searchResults[index].toString()),
                                );
                        },
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
