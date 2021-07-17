import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_bloc/blocs/todo_bloc.dart';
import 'package:todo_bloc/widgets/shared/app_colors.dart';

class CreateOrUpdateTodo extends StatelessWidget {
  final TodoBloc bloc;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  CreateOrUpdateTodo({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCreating = bloc.editingTodo == null;
    if (!isCreating) {
      _nameController.text = bloc.editingTodo!.name!;
      _descriptionController.text = bloc.editingTodo!.desc!;
      bloc.changeName(bloc.editingTodo!.name!);
      bloc.changeDescription(bloc.editingTodo!.desc!);

      bloc.changeDate(bloc.editingTodo!.date!);
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _buildAppBar(isCreating, context),
        body: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    buildTodoNameField(bloc),
                    SizedBox(height: 16),
                    buildDescriptionField(bloc),
                    SizedBox(height: 16),
                    buildDatePickerButton(bloc, context),
                    buildSubmitButton(bloc, context, isCreating),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTodoNameField(TodoBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          keyboardType: TextInputType.name,
          controller: _nameController,
          onChanged: bloc.changeName,
          decoration: InputDecoration(
              labelText: "Todo Name",
              hintText: "learn machine learning",
              errorText: !snapshot.hasError ? null : snapshot.error.toString(),
              border: OutlineInputBorder()),
        );
      },
    );
  }

  Widget buildDescriptionField(TodoBloc bloc) {
    return StreamBuilder(
      stream: bloc.descriptionStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          controller: _descriptionController,
          maxLines: 5,
          minLines: 5,
          onChanged: bloc.changeDescription,
          decoration: InputDecoration(
              labelText: "Todo description",
              hintText: "Learn Machine Learning via youtube videos",
              errorText: !snapshot.hasError ? null : snapshot.error.toString(),
              border: OutlineInputBorder()),
        );
      },
    );
  }

  Widget buildDatePickerButton(TodoBloc bloc, BuildContext context) {
    return StreamBuilder(
        stream: bloc.dateStream,
        builder: (context, AsyncSnapshot<DateTime> snapshot) {
          return Container(
            width: double.infinity,
            child: Column(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    minimumSize: Size(double.infinity, 56),
                    primary: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: primaryColor)),
                  ),
                  onPressed: () {
                    _pickCompletionDate(bloc, context);
                  },
                  child: Text(snapshot.hasData
                      ? snapshot.data!.toIso8601String().substring(0, 10)
                      : "Pick Completion date"),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    snapshot.hasError ? snapshot.error.toString() : "",
                    style: TextStyle(color: redColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildSubmitButton(TodoBloc todoBloc, BuildContext context, bool isCreating) {
    return StreamBuilder(
        stream: todoBloc.loadingStatusStream,
        initialData: false,
        builder: (context, AsyncSnapshot<bool> loadingSnapshot) {
          return StreamBuilder(
              stream: todoBloc.buttonStream,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                return Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      primary: Colors.blueAccent,
                    ),
                    onPressed: snapshot.hasData && (!loadingSnapshot.data!)
                        ? () {
                      _onSubmit(todoBloc, context, isCreating);
                    }
                        : null,
                    child: loadingSnapshot.data!
                        ? CircularProgressIndicator()
                        : Text(isCreating ? "Save" : "Update"),
                  ),
                );
              });
        });
  }

  Future _onSubmit(TodoBloc bloc, BuildContext context, bool isCreating) async {
    bloc.changeLoadingStatus(true);

    if (isCreating) {
      await bloc.addNewTodo();
    } else {
      bloc.updateTodo();
    }
    bloc.setEditingTodo(null);
    bloc.changeLoadingStatus(false);
    Navigator.of(context).pop();

    // var response = await bloc.save();

    // if (response == null) {
    //   //todo show a snackbar message
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Failed to save the todo, please try again")),
    //   );
    // } else {
    //   bloc.setEditingTodo(null);
    //   Navigator.of(context).pop();

    //   //todo navigate to the other screen
    // }
  }

  AppBar _buildAppBar(bool isCreating, BuildContext context) {
    return AppBar(
        title: Text(
          isCreating ? "Create new todo" : "Update todo",
          style: TextStyle(color: blackColor87),
        ),
        backgroundColor: whiteColor,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: blackColor87,
            ),
            onPressed: () => Navigator.of(context).pop()));
  }

  void _pickCompletionDate(TodoBloc bloc, BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365 * 2)));
    if (picked != null) {
      bloc.changeDate(picked);
    }
  }

  ///called when the back button is pressed or we are trying to go back
  ///if we return true then it can go back else cannot
  ///here we are setting the editing todo to back to null
  Future<bool> _onWillPop() async {
    bloc.setEditingTodo(null);

    return true;
  }
}