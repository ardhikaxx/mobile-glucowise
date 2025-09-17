import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/Screening/hasil_screening.dart';
import 'package:medical_app/services/screening_services.dart';
import 'package:medical_app/utils/session_manager.dart';
import 'package:medical_app/components/alert.dart';

class TestScreeningScreen extends StatefulWidget {
  final UserData userData;
  const TestScreeningScreen({super.key, required this.userData});

  @override
  State<TestScreeningScreen> createState() => _TestScreeningScreenState();
}

class _TestScreeningScreenState extends State<TestScreeningScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> answers = {};
  List<dynamic> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final result = await ScreeningServices.getQuestions();
    if (result != null && result['success'] == true) {
      setState(() {
        questions = result['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Show error and go back
      _showAlert("Error", "Gagal memuat pertanyaan screening");
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _selectAnswer(int questionId, int answerId) {
    setState(() {
      answers[questionId] = answerId;
    });
  }

  void _showAlert(String title, String message) {
    CustomAlert.showMessageDialog(
      context: context,
      title: title,
      message: message,
      isSuccess: title == "Error" ? false : true,
    );
  }

  void _nextQuestion() {
    final questionId = questions[currentQuestionIndex]['id_pertanyaan'];
    if (!answers.containsKey(questionId)) {
      _showAlert("Peringatan", "Silakan pilih jawaban sebelum melanjutkan");
      return;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _confirmExit() {
    CustomAlert.showConfirmDialog(
      context: context,
      title: "Konfirmasi",
      message: "Anda yakin ingin keluar dari tes screening?",
      onConfirm: () {
        Get.offAll(() => NavBottom(userData: widget.userData));
      },
    );
  }

  Future<void> _submitTest() async {
    final questionId = questions[currentQuestionIndex]['id_pertanyaan'];
    if (!answers.containsKey(questionId)) {
      _showAlert("Peringatan", "Silakan pilih jawaban sebelum mengirim");
      return;
    }

    int totalScore = 0;
    List<Map<String, dynamic>> answerList = [];

    for (var question in questions) {
      final questionId = question['id_pertanyaan'];
      if (answers.containsKey(questionId)) {
        final answerId = answers[questionId]!;

        final answer = question['jawaban_screening'].firstWhere(
          (a) => a['id_jawaban'] == answerId,
          orElse: () => null,
        );

        if (answer != null) {
          final answerText = answer['jawaban'] as String;
          final scoreMatch = RegExp(r'\((\d+)\)').firstMatch(answerText);
          if (scoreMatch != null) {
            totalScore += int.parse(scoreMatch.group(1)!);
          }

          answerList.add({
            'id_pertanyaan': questionId,
            'id_jawaban': answerId,
          });
        }
      }
    }

    final nik = await SessionManager.getNik();
    if (nik == null) {
      _showAlert("Error", "Tidak dapat mengidentifikasi pengguna");
      return;
    }

    // Tampilkan dialog loading
    CustomAlert.showCustomDialog(
      context: context,
      barrierDismissible: false,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF199A8E),
          ),
          const SizedBox(width: 20),
          const Text(
            "Memproses hasil...",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    final isSuccess = await ScreeningServices.submitAnswers(
      nik: nik,
      answers: answerList,
      totalScore: totalScore,
      context: context,
    );

    if (isSuccess && mounted) {
      Navigator.of(context).pop(); // Tutup dialog loading
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HasilScreeningScreen(totalScore: totalScore),
        ),
      );
    } else {
      Navigator.of(context).pop(); // Tutup dialog loading
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF199A8E),
                ),
                const SizedBox(height: 20),
                Text(
                  "Memuat pertanyaan...",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Screening Test',
            style: TextStyle(
              fontFamily: 'DarumadropOne',
              color: Color(0xFF199A8E),
              fontSize: 35,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF199A8E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        body: const Center(
          child: Text(
            'Tidak ada pertanyaan screening yang tersedia',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final question = questions[currentQuestionIndex];
    final questionId = question['id_pertanyaan'];
    final answersList = question['jawaban_screening'] as List;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Screening Test',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: _confirmExit,
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress indicator
            Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Soal ${currentQuestionIndex + 1} dari ${questions.length}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  borderRadius: BorderRadius.circular(50),
                  backgroundColor: const Color(0xFFE8F3F1),
                  color: const Color(0xFF199A8E),
                  minHeight: 12,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Question card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: const Color(0xFFE8F3F1),
              shadowColor: Colors.black.withOpacity(0.3),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF9FAFB),
                      ),
                      child: Image.asset(
                        'assets/icon/question.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${currentQuestionIndex + 1}. ${question['pertanyaan']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: answersList.length,
                itemBuilder: (context, index) {
                  final answer = answersList[index];
                  final isSelected =
                      answers[questionId] == answer['id_jawaban'];

                  return GestureDetector(
                    onTap: () =>
                        _selectAnswer(questionId, answer['id_jawaban']),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: isSelected
                          ? const Color(0xFF199A8E)
                          : const Color(0xFFF9FAFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF199A8E)
                              : const Color(0xFFE5E7EB),
                          width: 2,
                        ),
                      ),
                      elevation: isSelected ? 4 : 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF199A8E),
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                answer['jawaban'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: _previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side:
                          const BorderSide(color: Color(0xFF199A8E), width: 2),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.chevronLeft,
                          color: Color(0xFF199A8E),
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Sebelumnya",
                          style: TextStyle(
                            color: Color(0xFF199A8E),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ElevatedButton(
                  onPressed: currentQuestionIndex == questions.length - 1
                      ? _submitTest
                      : _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF199A8E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    currentQuestionIndex == questions.length - 1
                        ? "Proses"
                        : "Selanjutnya",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}