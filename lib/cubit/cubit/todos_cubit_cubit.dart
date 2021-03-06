import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/repository.dart';

part 'todos_cubit_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final Repository repository;

  TodosCubit({required this.repository}) : super(TodosInitial());

  void fetchTodoos() {
    Timer(Duration(seconds: 3), () {
        repository.fetchTodos().then((todos) {
          emit(TodosLoaded(todos: todos));
        });
    });
  }

  void changeCompletion(Todo todo) {
    repository.changeCompletion(!todo.isCompleted, todo.id).then((isChanged) {
      if (isChanged) {
        todo.isCompleted = !todo.isCompleted;
        updateTodolist();
      }
    });
  }

  void updateTodolist() {
    final currentState = state;

    if (currentState is TodosLoaded)
      emit(TodosLoaded(todos: currentState.todos));
  }

  addTodo(Todo todo) {
    final currentState = state;

    if (currentState is TodosLoaded) {
      final todoList = currentState.todos;
      todoList.add(todo);

      emit(TodosLoaded(todos: todoList));
    }
  }

  void deleteTodo(Todo todo) {
    final currentState = state;

    if (currentState is TodosLoaded) {
      final todoList = currentState.todos.where((element) => element.id.toString() != todo.id.toString()).toList();
      emit(TodosLoaded(todos: todoList));
    }
  }
}