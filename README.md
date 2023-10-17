# Flutter To-Do List App

이 Flutter 앱은 사용자의 일상의 할 일을 간편하게 관리할 수 있는 To-Do List 애플리케이션입니다. 앱은 Flutter 프레임워크와 Hive 데이터베이스를 활용하여 개발되었으며, 직관적인 UI를 통해 사용자가 효과적으로 할 일을 추가, 수정, 삭제할 수 있습니다.

## 기술 스택

- **Flutter**: 모바일 앱 개발 프레임워크로 UI를 구성합니다.
- **Hive**: 빠르고 경량화된 NoSQL 데이터베이스로 할 일의 데이터를 로컬에 저장합니다.

## 주요 기능

1. **할 일 추가**
   - 플로팅 액션 버튼을 통해 할 일을 쉽게 추가할 수 있습니다.
   - 추가 시 다이얼로그를 통해 할 일의 내용을 입력받습니다.
   
2. **할 일 삭제**
   - 각 할 일 항목 옆의 삭제 버튼을 통해 특정 할 일을 삭제할 수 있습니다.

3. **할 일 완료 표시**
   - 할 일 항목의 체크박스를 통해 해당 할 일의 완료 여부를 선택할 수 있습니다.
   - 완료된 할 일은 텍스트에 취소선이 그어져 표시됩니다.

4. **완료된 할 일 표시 및 숨김**
   - 앱바에 있는 버튼을 통해 완료된 할 일만 보거나 모든 할 일을 볼 수 있는 기능을 토글 할 수 있습니다.

5. **데이터 저장 및 관리**
   - 할 일의 데이터는 Hive 데이터베이스에 안전하게 저장되며, 앱을 종료하고 다시 시작해도 데이터는 그대로 유지됩니다.
  

https://code-trainee.tistory.com/125
