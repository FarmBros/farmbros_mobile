import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FarmbrosMapSearchBar extends StatelessWidget {
  final GestureTapCallback? selectStructure;
  final bool showSuggestions;
  final List<Map<String, dynamic>> searchSuggestions;
  final Function selectSuggestion;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function(String) searchLocation;
  final ValueChanged<String>? onSearchChanged;
  final bool showStructureSelection;
  final bool isDrawingMode;
  final VoidCallback changeMapLayer;
  final VoidCallback clearSearch;
  final VoidCallback? toggleEditMode;
  final bool isEditingMode;

  const FarmbrosMapSearchBar({
    super.key,
    required this.selectStructure,
    required this.showSuggestions,
    required this.searchSuggestions,
    required this.selectSuggestion,
    required this.searchController,
    required this.searchFocusNode,
    required this.searchLocation,
    required this.onSearchChanged,
    required this.showStructureSelection,
    required this.isDrawingMode,
    required this.changeMapLayer,
    required this.clearSearch,
    this.toggleEditMode,
    this.isEditingMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search Bar and Map Type Button
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                children: [
                  // Search Suggestions
                  if (showSuggestions && searchSuggestions.isNotEmpty)
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: searchSuggestions.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1),
                          itemBuilder: (context, index) {
                            final suggestion = searchSuggestions[index];
                            return ListTile(
                              leading:
                                  Icon(Icons.location_on, color: Colors.grey),
                              title: Text(
                                suggestion['name'] ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                              subtitle: suggestion['address'] != null
                                  ? Text(
                                      suggestion['address'],
                                      style: TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              onTap: () => selectSuggestion(suggestion),
                            );
                          },
                        ),
                      ),
                    ),
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      decoration: InputDecoration(
                        hintText: "Search location...",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: clearSearch,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      onChanged: onSearchChanged,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          searchLocation(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              spacing: 10,
              children: [
                // Draw Button (shows structure selection) - hidden when editing
                if (!showStructureSelection && !isDrawingMode && !isEditingMode)
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: selectStructure,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColorUtils.secondaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                // Edit Mode Toggle Button (only shown when structures exist and not drawing)
                if (toggleEditMode != null && !isDrawingMode)
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: toggleEditMode,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isEditingMode ? Colors.orange : Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          isEditingMode ? Icons.done : CupertinoIcons.pencil,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                // Map Layer Toggle
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: changeMapLayer,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.layers,
                        color: ColorUtils.secondaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
