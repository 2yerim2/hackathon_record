import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'services/sign_up_page.dart';

void main() async { // main함수, async로 시간 걸리는 작업 기다릴 수 있게
  WidgetsFlutterBinding.ensureInitialized(); // flutter 내부 시스템 초기화

  await Firebase.initializeApp( // 초기화 끝날때까지 기다리고 다음 줄로
    options: DefaultFirebaseOptions.currentPlatform, // 실행 중인 플랫폼에 맞는 firebase 사용
  );

  runApp(const MyApp()); // 앱으로 실행
}

class MyApp extends StatelessWidget { // MyApp 클래스 정의, StatelessWidget 상속받음
  const MyApp({super.key}); // 이 클래스의 생성자, 부모 클래스에 key값 전달

  @override // 부모 클래스인 StatelessWidget의 build 메서드 재정의
  Widget build(BuildContext context) { // 화면 구성
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // 배너 숨김
      home: SignUpPage(), // 실행 시 첫 화면에서 회원가입 화면 보여주기
    );
  }
}