import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/page/Screening/hasil_screening.dart';
import 'package:quickalert/quickalert.dart';
import 'package:medical_app/data/data_screening.dart';

class TestScreeningScreen extends StatefulWidget {
  const TestScreeningScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TestScreeningScreenState createState() => _TestScreeningScreenState();
}

class _TestScreeningScreenState extends State<TestScreeningScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> answers = {};

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _selectAnswer(int value) {
    setState(() {
      answers[currentQuestionIndex] = value;
    });
  }

  void _showAlert(String title, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title,
      text: message,
      confirmBtnColor: const Color(0xFF199A8E),
      confirmBtnText: "OK",
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  void _nextQuestion() {
    if (!answers.containsKey(currentQuestionIndex)) {
      _showAlert("Jawaban Belum Dipilih!", "Silakan pilih jawaban sebelum melanjutkan.");
      return;
    }

    if (currentQuestionIndex < screeningQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _confirmExit() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Konfirmasi",
      text: "Anda yakin ingin keluar dari tes ini?",
      confirmBtnText: "Ya",
      cancelBtnText: "Tidak",
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const NavBottom()),
        // );
      },
    );
  }

  void _submitTest() {
    if (!answers.containsKey(currentQuestionIndex)) {
      _showAlert("Jawaban Belum Dipilih!", "Silakan pilih jawaban sebelum mengirim.");
      return;
    }

    int totalScore = answers.values.fold(0, (sum, item) => sum + item);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HasilScreeningScreen(totalScore: totalScore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = screeningQuestions[currentQuestionIndex];

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
            Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Soal ${currentQuestionIndex + 1} dari ${screeningQuestions.length}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / screeningQuestions.length,
                  borderRadius: BorderRadius.circular(50),
                  backgroundColor: const Color(0xFFE8F3F1),
                  color: const Color(0xFF199A8E),
                  minHeight: 12,
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                      "${currentQuestionIndex + 1}. ${question['question']}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: (question['answers'] as Map<int, String>)
                  .entries
                  .map((entry) {
                final isSelected = answers[currentQuestionIndex] == entry.key;

                return GestureDetector(
                  onTap: () => _selectAnswer(entry.key),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: isSelected ? const Color(0xFF199A8E) : const Color(0xFFF9FAFB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                    elevation: isSelected ? 4 : 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.circle_outlined,
                            color: isSelected ? const Color(0xFFF9FAFB) : const Color(0xFF199A8E),
                            size: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: _previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Color(0xFF199A8E), width: 2),
                    ),
                    child: const Row(children: [
                      Icon(FontAwesomeIcons.chevronLeft, color: Color(0xFF199A8E)),
                      SizedBox(width: 10),
                      Text("Previous", style: TextStyle(color: Color(0xFF199A8E), fontSize: 18)),
                    ]),

                  ),
                ElevatedButton(
                  onPressed: currentQuestionIndex == screeningQuestions.length - 1 ? _submitTest : _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF199A8E),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(currentQuestionIndex == screeningQuestions.length - 1 ? "Selesai" : "Next",
                      style: const TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}