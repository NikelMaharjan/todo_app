import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_bloc/blocs/todo_bloc.dart';
import 'package:todo_bloc/blocs/todo_bloc_provider.dart';
import 'package:todo_bloc/models/todo_model.dart';
import 'package:todo_bloc/widgets/shared/text_styles.dart';

import 'create_or_update_todo.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoBlocProvider(
      child: Builder(builder: (context) {
        final TodoBloc bloc = TodoBlocProvider.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text("Your todos", style: TextStyle(color: blackColor87)),
            backgroundColor: whiteColor,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 40,
                  color: blackColor87,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return CreateOrUpdateTodo(
                      bloc: bloc,
                    );
                  }));
                },
              ),
              SizedBox(
                width: 16,
              )
            ],
          ),
          body: _buildBody(bloc),
        );
      }),
    );
  }

  Widget _buildBody(TodoBloc bloc) {
    return FutureBuilder(
        future: bloc.fetchAllTodos(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: StreamBuilder(
              stream: bloc.todoListStream,
              builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                print(
                    "snapshot data is ${snapshot.data} and has data ${snapshot.hasData}");
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildGetStarted(context, bloc);
                }
                return _buildTodoList(context, bloc, snapshot.data!);
              },
            ),
          );
        });
  }
  Widget _buildGetStarted(BuildContext context, TodoBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Create your first Todo",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 12,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return CreateOrUpdateTodo(bloc: bloc);
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      primary: blueColor),
                  child: Text(
                    "Add New Todo",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: whiteColor),
                  ))),
        ],
      ),
    );
  }

  Widget _buildTodoList(BuildContext context, TodoBloc bloc, List<TodoModel> list) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, int index) {
        final single = list[index];
        return _buildSingleTodoItem(single, bloc, context);
      },
    );
  }

  Widget _buildSingleTodoItem(TodoModel single, TodoBloc bloc, BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Update',
          color: Colors.green,
          icon: Icons.edit,
          onTap: () {
            bloc.setEditingTodo(single);
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return CreateOrUpdateTodo(bloc: bloc);
            }));
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            bloc.deleteTodo(single);
          },
        ),
      ],
      child: Card(
        child: ListTile(
          title: Text(single.name!),
          subtitle: Text(single.desc!),
          trailing: Text(single.date!.toIso8601String().substring(0, 10)),
          onTap: () {},
        ),
      ),
    );
  }
}