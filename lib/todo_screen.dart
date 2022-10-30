import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';
import 'package:todo_app/todo_db_helper.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  TextEditingController datetimeEditingController = TextEditingController();

  List<ToDo> todoList = [];
  late ToDo _selectedTodo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ToDoDBHelper.instance.getToDoSList().then((value){
      setState(() {
        todoList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
      ),
      body: Center(
        child: Column(
          
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index){
                      if(todoList.isNotEmpty){
                        return GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 3,
                                  color: Colors.grey.withOpacity(0.2)
                                )
                              ]
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.alarm),
                              title: Text(todoList[index].title ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                              subtitle: Text(todoList[index].description ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15),),
                              trailing: SizedBox(
                                width: 100,
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    IconButton(onPressed: (){
                                      setState(() {
                                        _selectedTodo = todoList[index];
                                        showTodoAlertDialog(context, InputType.updateProduct);
                                      });
                                    }, icon: const Icon(Icons.edit)),
                                    IconButton(onPressed: (){
                                      setState(() {
                                        _selectedTodo = todoList[index];
                                      });
                                      ToDoDBHelper.instance.deleteToDo(_selectedTodo).then((value){
                                        ToDoDBHelper.instance.getToDoSList().then((value){
                                          setState(() {
                                            todoList = value;
                                          });
                                        });
                                      });
                                    }, icon: const Icon(Icons.delete, color: Colors.red,)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      else{
                        return const Center(child: Text('List is empty'),);
                      }
                    }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showTodoAlertDialog(context, InputType.addProduct);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  showTodoAlertDialog(BuildContext context, InputType inputType){

    bool isUpdateTodo = false;
    isUpdateTodo = (inputType == InputType.updateProduct) ? true : false;

    if(isUpdateTodo){
      titleEditingController.text = _selectedTodo.title ?? '';
      descriptionEditingController.text = _selectedTodo.description ?? '';
      datetimeEditingController.text = _selectedTodo.dateTime ?? '2022/4/6';
    }

    TextButton saveButton = TextButton(onPressed: (){
      if(titleEditingController.text.isNotEmpty && descriptionEditingController.text.isNotEmpty && datetimeEditingController.text.isNotEmpty){

          if(!isUpdateTodo){
            setState(() {
              ToDo toDo = ToDo();
              toDo.title = titleEditingController.text;
              toDo.description = descriptionEditingController.text;
              toDo.dateTime = datetimeEditingController.text;

              ToDoDBHelper.instance.insertToDo(toDo).then((value){
                ToDoDBHelper.instance.getToDoSList().then((value){
                  setState(() {
                    todoList = value;
                  });
                });
                Navigator.pop(context);
                _emptyTextFields();
              });
            });
          }else{
            setState(() {

              _selectedTodo.title = titleEditingController.text;
              _selectedTodo.description = descriptionEditingController.text;
              _selectedTodo.dateTime = datetimeEditingController.text;

              ToDoDBHelper.instance.updateToDo(_selectedTodo).then((value){
                ToDoDBHelper.instance.getToDoSList().then((value){
                  setState(() {
                    todoList = value;
                  });
                });
                Navigator.pop(context);
                _emptyTextFields();
              });
            });
          }

      }
    }, child: const Text('save'));

    TextButton cancelButton = TextButton(onPressed: (){
      Navigator.of(context).pop();
      _emptyTextFields();
    }, child: const Text('cancel'));


    AlertDialog todoAlertDialog = AlertDialog(
      title: Text(!isUpdateTodo ? 'Add New Todo': 'Update Todo'),
      content: Container(
        child: Wrap(
          children: [
            Container(
              child: TextFormField(
                controller: titleEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Title'
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: descriptionEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Description'
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: datetimeEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Datetime'
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        saveButton,
        cancelButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return todoAlertDialog;
    });
  }

  _emptyTextFields(){
    titleEditingController.text = '';
    descriptionEditingController.text = '';
    datetimeEditingController.text = '';
  }
}

enum InputType{addProduct, updateProduct}
