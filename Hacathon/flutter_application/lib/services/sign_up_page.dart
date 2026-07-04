import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget { // 회원가입 페이지 정의, StatefulWidget 상속받음
  const SignUpPage({super.key}); // 생성자, 부모에게 key 전달

  @override // 부모 클래스의 createState() 메서드 재정의
  State<SignUpPage> createState() => _SignUpPageState(); // 회원가입 화면 관리하는 객체 생성
}

class _SignUpPageState extends State<SignUpPage> { // SignUpPageState 클래스 선언
  final AuthService _authService = AuthService(); // Firebase 회원가입 처리 서비스 객체 생성

  final emailController = TextEditingController(); // 이메일 입력 관리 컨트롤러
  final passwordController = TextEditingController(); // 비번
  final nicknameController = TextEditingController(); // 닉네임
  final schoolController = TextEditingController(); // 학교
  final majorController = TextEditingController(); // 전공
  final gradeController = TextEditingController(); // 학년

  bool isLoading = false; // 처음에는 로딩 안 되는 상태

  Future<void> signUp() async { // 회원가입 함수
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final nickname = nicknameController.text.trim();
    final school = schoolController.text.trim();
    final major = majorController.text.trim();
    final gradeText = gradeController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        nickname.isEmpty ||
        school.isEmpty ||
        major.isEmpty ||
        gradeText.isEmpty) {
      showMessage('모든 항목을 입력해주세요.');
      return;
    }

    final grade = int.tryParse(gradeText);

    if (grade == null) {
      showMessage('학년은 숫자로 입력해주세요.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Firebase 회원가입 + Firestore 저장은 AuthService로 넘김
      await _authService.signUp(
        email: email,
        password: password,
        nickname: nickname,
        school: school,
        major: major,
        grade: grade,
      );

      showMessage('회원가입 성공!');

      emailController.clear();
      passwordController.clear();
      nicknameController.clear();
      schoolController.clear();
      majorController.clear();
      gradeController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showMessage('이미 가입된 이메일입니다.');
      } else if (e.code == 'weak-password') {
        showMessage('비밀번호가 너무 약합니다.');
      } else if (e.code == 'invalid-email') {
        showMessage('이메일 형식이 올바르지 않습니다.');
      } else {
        showMessage('회원가입 오류: ${e.message}');
      }
    } catch (e) {
      showMessage('오류 발생: $e');
    } finally {
      setState(() {
        isLoading = false; // 로딩 끝남
      });
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() { // 화면 종료 시 호출됨
    emailController.dispose();
    passwordController.dispose();
    nicknameController.dispose();
    schoolController.dispose();
    majorController.dispose();
    gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { // 화면 구성
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
              ),
            ),
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
                labelText: '닉네임',
              ),
            ),
            TextField(
              controller: schoolController,
              decoration: const InputDecoration(
                labelText: '학교',
              ),
            ),
            TextField(
              controller: majorController,
              decoration: const InputDecoration(
                labelText: '전공',
              ),
            ),
            TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '학년',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : signUp,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}