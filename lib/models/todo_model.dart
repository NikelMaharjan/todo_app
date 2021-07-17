class TodoModel {
  String? id; //for update and delete
  String? name;
  String? desc;
  DateTime? date;

  TodoModel({required this.date, required this.name, required this.desc});

  TodoModel.fromJson(Map<String, dynamic> map, String todoId) {
    id = todoId;
    name = map["name"];
    desc = map["description"] ;
    date = DateTime.parse(map["date"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': desc,
      'date': date!.toIso8601String(),
    };
  }
}
