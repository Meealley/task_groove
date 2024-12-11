import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:task_groove/cubits/search_task/search_task_cubit.dart';
import 'package:task_groove/models/task_model.dart';
import 'package:task_groove/routes/pages.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:task_groove/theme/appcolors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

// List to store the recent search
  final List<String> _recentSearches = [];

  // Filtered suggestions based on the user input
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    // Automatically bring up the keyboard when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String searchTerm) {
    setState(() {
      // Filter recent searches based on the user input
      _filteredSuggestions = _recentSearches
          .where((search) =>
              search.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });

    if (searchTerm.isNotEmpty) {
      context.read<SearchTaskCubit>().searchTasks(searchTerm);
    }
  }

  void _onSuggestionSelected(String suggestion) {
    setState(() {
      _searchController.text = suggestion;
      _filteredSuggestions.clear();
    });
    _onSearchChanged(suggestion);
  }

  void _addToRecentSearches(String searchTerm) {
    if (searchTerm.isNotEmpty && !_recentSearches.contains(searchTerm)) {
      setState(() {
        _recentSearches.insert(
            0, searchTerm); // This would add it to the top of the list
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast(); // Keep Only the last 5 searches
        }
      });
    }
  }

  void _deleteRecentSearches(String searchTerm) {
    setState(() {
      _recentSearches.remove(searchTerm);
      _filteredSuggestions.remove(searchTerm);
      print("Recent Searches: $_recentSearches");
      print("Filtered Suggestions: $_filteredSuggestions");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Tasks',
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.backgroundDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: TextField(
                style: AppTextStyles.bodyText,
                keyboardType: TextInputType.text,
                focusNode: _searchFocusNode,
                controller: _searchController,
                onChanged: _onSearchChanged,
                onSubmitted: (searchTerm) {
                  _addToRecentSearches(searchTerm);
                  _onSearchChanged(searchTerm);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    top: 1,
                    bottom: 0,
                    left: 6,
                  ),
                  // labelText: 'Search for tasks',
                  labelStyle: AppTextStyles.bodyText,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            if (_filteredSuggestions.isNotEmpty || _recentSearches.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.clockRotateLeft,
                          size: 14,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          'Recent Searches',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent unnecessary scrolling within the column
                    itemCount: _filteredSuggestions.isNotEmpty
                        ? _filteredSuggestions.length
                        : _recentSearches.length,
                    itemBuilder: (context, index) {
                      final suggestion = _filteredSuggestions.isNotEmpty
                          ? _filteredSuggestions[index]
                          : _recentSearches[index];
                      return ListTile(
                        title: Text(
                          suggestion,
                          style: AppTextStyles.bodyText,
                        ),
                        onTap: () => _onSuggestionSelected(suggestion),
                        trailing: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.x,
                            size: 13,
                          ),
                          onPressed: () => _deleteRecentSearches(suggestion),
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              const SizedBox.shrink(),
            SizedBox(height: 2.h),
            Expanded(
              flex: 15,
              child: BlocBuilder<SearchTaskCubit, SearchTaskState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.error!.message.isNotEmpty) {
                    return Center(
                      child: Text(
                        'Error: ${state.error!.message}',
                        style: AppTextStyles.bodyText,
                      ),
                    );
                  } else if (state.searchTasks.isEmpty) {
                    return Column(
                      children: [
                        Center(
                            child: Image.asset(
                          "assets/images/empty_search.png",
                          fit: BoxFit.cover,
                        )),
                        SizedBox(
                          height: .5.h,
                        ),
                        Center(
                          child: Text(
                            'No tasks found.',
                            style: AppTextStyles.bodyText,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
                      itemCount: state.searchTasks.length,
                      itemBuilder: (context, index) {
                        final TaskModel task = state.searchTasks[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: task.priority == 1
                                ? Colors.red.shade300
                                : task.priority == 2
                                    ? const Color.fromRGBO(220, 164, 124, 57)
                                    : const Color.fromRGBO(156, 169, 134, 57),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: AppTextStyles.bodyText,
                            ),
                            subtitle: Text(
                              task.description,
                              style: AppTextStyles.bodySmall,
                            ),
                            onTap: () {
                              context.pushNamed(
                                Pages.taskDescription,
                                pathParameters: {
                                  'id': task.id,
                                },
                                extra: task,
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
