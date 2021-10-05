import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit/add_todo_cubit.dart';

class AddTodoScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Todo")),
      body: BlocListener<AddTodoCubit, AddTodoState>(
        listener: (context, state) {
          if (state is TodoAdded) {
            Navigator.pop(context);
          } else if (state is AddTodoError) {
            print("Show Toast");
            //Toast.show(state.error, context, backgroundColor: Colors.red, duration: 3, gravity: Toast.CENTER);
          }
        },
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(context) {
    return Column(
      children: [
        TextField(
          autofocus: true,
          controller: _controller,
          decoration: InputDecoration(hintText: "Enter todo message..."),
        ),
        SizedBox(
            height: 50.0,
            child: InkWell(
                onTap: () {
                  final message = _controller.text;
                  BlocProvider.of<AddTodoCubit>(context).addTodo(message);
                },
                child: _addBtn(context)))
      ],
    );
  }

  Widget _addBtn(context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
        child: Center(child: BlocBuilder<AddTodoCubit, AddTodoState>(
          builder: (context, state) {
            if (state is AddingTodo) return CircularProgressIndicator();

            return Text("Add Todo", style: TextStyle(color: Colors.white));
          },
        )));
  }
}
