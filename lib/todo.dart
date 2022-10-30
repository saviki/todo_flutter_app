class ToDo{

  int? id;
  String? title;
  String? description;
  String? dateTime;

  ToDo({this.id, this.title, this.description, this.dateTime});

  static ToDo fromMap(Map<String, dynamic> query){
    ToDo toDo = ToDo();
    toDo.id = query['id'];
    toDo.title = query['title'];
    toDo.description = query['description'];
    toDo.dateTime = query['datetime'];

    return toDo;
  }

  static Map<String, dynamic> toMap(ToDo toDo){
    return <String, dynamic>{
      'id': toDo.id,
      'title': toDo.title,
      'description': toDo.description,
      'dateTime': toDo.dateTime,
    };
  }

  static List<ToDo> fromMapList(List<Map<String, dynamic>> query){
    List<ToDo> toDos = <ToDo>[];
    for(Map<String, dynamic> map in query){
      toDos.add(fromMap(map));
    }
    return toDos;
  }
}