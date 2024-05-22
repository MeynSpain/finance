import 'package:finance/core/constants/status/tags_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/tag_model.dart';
import 'package:finance/features/categories/tags/bloc/tags_bloc.dart';
import 'package:finance/features/categories/tags/view/widgets/new_tag_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagsWidget extends StatefulWidget {
  const TagsWidget({super.key});

  @override
  State<TagsWidget> createState() => _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagsBloc, TagsState>(
      builder: (context, state) {
        print('########### ${state.listTags}');
        print('#### ${state.status} ####');
        if (state.status == TagsStatus.gettingAllTags) {
          return CircularProgressIndicator();
        } else if (state.status == TagsStatus.error) {
          return Text('Что то пошло не так...');
        } else {
          print('### Зашел вот статус: ${state.status} ###');
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              ...List.generate(state.listTags.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      getIt<TagsBloc>().add(TagsToggleTagEvent(index: index));
                    });
                    print('TAP');
                    // print(_selectedTags);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: state.listSelectedTags[index] == true
                          ? Colors.black
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 2,
                          color: state.listSelectedTags[index] == true
                              ? Colors.black
                              : Colors.grey),
                    ),
                    child: Text(
                      '${state.listTags?[index].name}',
                      style: TextStyle(
                        color: state.listSelectedTags[index] == true
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: () {
                  _addTag(context);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: Text('Добавить тег +'),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void _addTag(BuildContext context) {
    showDialog(context: context, builder: (context) => NewTagWidget());
  }
}
