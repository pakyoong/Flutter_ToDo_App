// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();  // Hive 패키지 초기화
  await Hive.openBox('mybox');  // 'mybox'라는 이름의 박스를 열거나 새로 생성
  runApp(const MyApp());
}

/// 메인 앱 위젯
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 디버그 모드 배너 제거
      home: const HomePage(),
      theme: ThemeData(primarySwatch: Colors.lightBlue),  // 앱의 기본 테마 설정
    );
  }
}

/// 할 일 데이터를 관리하고 Hive 데이터베이스와 연동하는 클래스
class ToDoDatabase {
  List<ToDoItem> toDoList = [];  // 할 일 목록을 저장하는 리스트
  final _myBox = Hive.box('mybox');  // Hive 데이터베이스의 'mybox' 박스

  /// 초기 데이터 생성
  void createInitialData() {
    toDoList = [
      ToDoItem(name: "컴퓨터공학과 3학년", isCompleted: false),
      ToDoItem(name: "20190531 박현빈", isCompleted: false),
      ToDoItem(name: "10/19 오픈소스프로젝트 과제2", isCompleted: false),
    ];
  }

  void loadData() {
    var loadedData = _myBox.get("TODOLIST") as List<dynamic>? ?? [];
    toDoList = loadedData.map((item) {
      if (item is Map) {
        return ToDoItem.fromMap(item.cast<String, dynamic>());
      }
      return null;  // 잘못된 데이터 타입에 대한 처리. 실제로 이런 데이터가 없다면 이 줄은 실행되지 않습니다.
    }).where((item) => item != null).cast<ToDoItem>().toList();
  }




  /// 변경된 할 일 데이터를 데이터베이스에 업데이트
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList.map((e) => e.toMap()).toList());  // 'TODOLIST' 키에 리스트 데이터 저장
  }
}

/// 할 일 아이템 모델
class ToDoItem {
  String name;  // 할 일의 이름 또는 내용
  bool isCompleted;  // 할 일의 완료 여부

  ToDoItem({required this.name, this.isCompleted = false});

  /// Map 데이터 형식에서 ToDoItem 객체로 변환
  ToDoItem.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        isCompleted = map['isCompleted'];

  /// ToDoItem 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {'name': name, 'isCompleted': isCompleted};
}

/// 사용자 정의 버튼 위젯. UI 일관성을 위해 별도로 구현
class CustomButton extends StatelessWidget {
  final String label;  // 버튼에 표시될 텍스트
  final VoidCallback onPressed;  // 버튼 클릭 시 실행될 함수

  const CustomButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,  // 버튼 색상
      child: Text(label),  // 버튼 텍스트
    );
  }
}

/// 할 일을 추가하기 위한 다이얼로그
class AddTaskDialog extends StatelessWidget {
  final TextEditingController controller;  // 입력한 텍스트를 관리하는 컨트롤러
  final VoidCallback onSave;  // 저장 버튼 클릭 시 실행될 함수
  final VoidCallback onCancel;  // 취소 버튼 클릭 시 실행될 함수

  const AddTaskDialog({super.key, required this.controller, required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[100],
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "새로운 할 일 추가",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(label: "저장", onPressed: onSave),
                const SizedBox(width: 8),
                CustomButton(label: "취소", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 각 할 일 항목을 표시하는 위젯
class ToDoItemWidget extends StatelessWidget {
  final ToDoItem item;  // 할 일 아이템 정보
  final ValueChanged<bool?> onChanged;  // 체크박스 변경 시 실행될 함수
  final VoidCallback onDelete;  // 삭제 버튼 클릭 시 실행될 함수

  const ToDoItemWidget({super.key, required this.item, required this.onChanged, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blueGrey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: item.isCompleted,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                ),
                Text(
                  item.name,
                  style: TextStyle(
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough  // 완료된 할 일은 취소선 표시
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),  // 삭제 아이콘
              onPressed: onDelete,
            )
          ],
        ),
      ),
    );
  }
}

/// 홈 페이지 위젯. 할 일 목록을 보여주는 화면
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ToDoDatabase db = ToDoDatabase();  // 할 일 데이터베이스
  bool showCompletedTasksOnly = false;  // 완료된 할 일만 보여주는지 여부
  final _taskController = TextEditingController();  // 새로운 할 일 입력을 위한 컨트롤러

  @override
  void initState() {
    super.initState();
    db.loadData();  // 화면 로드 시 데이터베이스에서 할 일 데이터를 가져옴
    if (db.toDoList.isEmpty) {  // 로드된 데이터가 없다면
      db.createInitialData();  // 초기 데이터 생성
      db.updateDataBase();  // 생성된 초기 데이터를 데이터베이스에 저장
    }  
  } 
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('ToDo List App'),
      actions: [
        IconButton(
          icon: Icon(showCompletedTasksOnly ? Icons.list : Icons.check),
          onPressed: () {
            setState(() {
              showCompletedTasksOnly = !showCompletedTasksOnly;  // 완료된 할 일만 보여주는 옵션을 토글
            });
          },
        ),
      ],
    ),
    body: ListView.builder(
      itemCount: showCompletedTasksOnly  // 완료된 할 일만 보여줄지 여부에 따라 목록 길이 결정
          ? db.toDoList.where((task) => task.isCompleted).length
          : db.toDoList.length,
      itemBuilder: (context, index) {
        var task = showCompletedTasksOnly
            ? db.toDoList.where((task) => task.isCompleted).toList()[index]
            : db.toDoList[index];
        return ToDoItemWidget(
          item: task,
          onChanged: (value) {
            setState(() {
              task.isCompleted = value!;
              db.updateDataBase();  // 변경된 데이터를 데이터베이스에 업데이트
            });
          },
          onDelete: () {
            setState(() {
              db.toDoList.remove(task);  // 할 일 목록에서 해당 아이템 삭제
              db.updateDataBase();  // 변경된 데이터를 데이터베이스에 업데이트
            });
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _addTask,  // '+' 버튼 클릭 시 새로운 할 일 추가 함수 실행
      child: const Icon(Icons.add),  // 플로팅 버튼 아이콘
    ),
  );
}

  // 새로운 할 일을 추가하는 함수
  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        controller: _taskController,
        onSave: () {
          setState(() {
            var newTask = ToDoItem(name: _taskController.text);  // 입력한 텍스트를 기반으로 새로운 할 일 생성
            db.toDoList.add(newTask);  // 할 일 목록에 새로운 아이템 추가
            db.updateDataBase();  // 변경된 데이터를 데이터베이스에 업데이트
            _taskController.clear();  // 입력 필드 초기화
          });
          Navigator.of(context).pop();  // 다이얼로그 닫기
        },
        onCancel: () {
          _taskController.clear();  // 입력 필드 초기화
          Navigator.of(context).pop();  // 다이얼로그 닫기
        },
      ),
    );
  }
}
