import 'dart:async';

import 'package:rxdart/rxdart.dart' show BehaviorSubject, Rx;
import 'package:todo_bloc/apis/todo_api.dart';
import 'package:todo_bloc/blocs/cache_bloc.dart';
import 'package:todo_bloc/models/todo_model.dart';
import 'package:todo_bloc/validators/todo_validators.dart';

class TodoBloc with TodoValidator {
  final api = TodoApi();

  // holds the list of all the todos
  final _todoListController = BehaviorSubject<List<TodoModel>>();

  //to hold the status of the button's child
  final _loadingController = BehaviorSubject<bool>();

  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _dateController = BehaviorSubject<DateTime>();

  //used to set the currently active todo
  final _editingTodoController = BehaviorSubject<TodoModel?>();

  Function(bool val) get changeLoadingStatus => _loadingController.sink.add;

  Function(String val) get changeName => _nameController.sink.add;
  Function(String val) get changeDescription => _descriptionController.sink.add;
  Function(DateTime val) get changeDate => _dateController.sink.add;

  //adding value to the currently active todo
  Function(TodoModel? todo) get setEditingTodo =>
      _editingTodoController.sink.add;

  Future<void> addNewTodo() async {
    List<TodoModel> _existing =
    _todoListController.hasValue ? _todoListController.value : [];
    int existingTodoIndex = _existing
        .indexWhere((element) => element.name == _nameController.value);

    if (existingTodoIndex >= 0) {
      _nameController.addError("This name already exists");
      return;
    }
    print("Index is this one current one ${_existing.map((e) => e.toJson())}");

    final uid = cache.currentUid!; ////to save/display different list for different users


    final newId = await api.createTodo(currentTodo, uid);   //wait till new ID is assigned? //for fixing updating problem
    final newTodo = currentTodo;
    newTodo.id = newId;
    _existing.add(newTodo);
    print("Index is this one current two ${_existing.map((e) => e.toJson())}");
    print("Index is this one current empty ${_existing.isEmpty}");

    _todoListController.sink.add(_existing);
  }

  void updateTodo() {
    List<TodoModel> _existing =
    _todoListController.hasValue ? _todoListController.value : [];
    int index = _existing.indexOf(editingTodo!);
    _existing.removeAt(index);
    print("Existing todo ${editingTodo!.id}");

    final updatingTodo = currentTodo;
    updatingTodo.id = editingTodo!.id;
    _existing.insert(index, updatingTodo);
    _todoListController.sink.add(_existing);
    final uid = cache.currentUid!; ////to save/display different list for different users

    api.updateTodo(updatingTodo, uid);
  }

  void deleteTodo(TodoModel todo) {
    List<TodoModel> _existing =
    _todoListController.hasValue ? _todoListController.value : [];
    int index = _todoListController.value
        .indexWhere((element) => element.name == todo.name);
    _existing.removeAt(index);

    _todoListController.sink.add(_existing);
    final uid = cache.currentUid!; ////to save/display different list for different users

    api.deleteTodo(todo.id!, uid);
  }

  //stream getters

  Stream<String> get nameStream =>
      _nameController.stream.transform(nameValidator);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(descriptionValidator);

  Stream<DateTime> get dateStream =>
      _dateController.stream.transform(dateValidator);

  Stream<bool> get loadingStatusStream => _loadingController.stream;

  // combine 4 streams for signup button
  Stream<bool> get buttonStream => Rx.combineLatest3(
      nameStream, descriptionStream, dateStream, (a, b, c) => true);

  Stream<List<TodoModel>> get todoListStream => _todoListController.stream;

  //get the current active todo
  TodoModel? get editingTodo =>
      _editingTodoController.hasValue ? _editingTodoController.value : null;

  Future save() async {
    final String name = _nameController.value;
    final String description = _descriptionController.value;
    final DateTime date = _dateController.value;
    await Future.delayed(Duration(seconds: 2));
    print("name $name and description $description and date $date");

    return true;
  }

  TodoModel get currentTodo => TodoModel(
      date: _dateController.value,
      name: _nameController.value,
      desc: _descriptionController.value);

  void dispose() {
    _loadingController.close();
    _nameController.close();
    _descriptionController.close();
    _dateController.close();
    _todoListController.close();
    _editingTodoController.close();
  }

   Future<void> fetchAllTodos() async {

    String uid = cache.currentUid!;  //to save/display different list for different users

    final list = await api.getAllTodos(uid);
    if (list != null) {
      _todoListController.sink.add(list);
    } else {
      _todoListController.sink.add([]);
    }
  }
}