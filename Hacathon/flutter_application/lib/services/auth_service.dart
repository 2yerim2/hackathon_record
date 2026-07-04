import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // auth객체 생성
  final FirebaseFirestore _db = FirebaseFirestore.instance; // firestore 객체 생성

  Future<void> signUp({ // 반드시 받아야할 값들 나열
    required String email, 
    required String password,
    required String nickname,
    required String school,
    required String major,
    required int grade,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword( // _auth 객체의 createUserWithEmailAndPassword 메서드 호출 -> 이메일, 비번으로 회원가입 하고 그 값 userCredential에 저장
      email: email,
      password: password,
    );

    final user = userCredential.user; // 회원 가입 성공한 userCredential.user 객체를 user 변수에 저장

    if (user == null) { // 예외 처리, 실패한 경우
      throw Exception('회원가입에 실패했습니다.');
    }

    final uid = user.uid; // firebase에서 생성된 uid 가져와서 uid에 저장함


    await _db.collection('users').doc(uid).set({ // _db 객체의 collection('users') 안에 uid 문서 생성 후 set()으로 저장
      'uid': uid, // firebase에서 uid 생성해줌, 그 uid 저장
      'email': email, // 여기서부턴 사용자에게 받은 값 사용
      'nickname': nickname,
      'school': school,
      'major': major,
      'grade': grade,
      'verified': false,
      'trustScore': 50,
      'tradeCount': 0,
      'rentalCount': 0,
      'createdAt': FieldValue.serverTimestamp(), // 서버 시간으로 생성 시간 할당
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}