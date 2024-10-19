import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (searchTerm.isNotEmpty) {
      context.read<SearchTaskCubit>().searchTasks(searchTerm);
    }
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
            SizedBox(height: 2.h),
            Expanded(
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
                          "assets/images/empty_list.png",
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
                        return ListTile(
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
