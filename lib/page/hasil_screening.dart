import 'package:flutter/material.dart';
import 'package:medical_app/components/navbottom.dart';

class HasilScreeningScreen extends StatelessWidget {
  final int totalScore;

  const HasilScreeningScreen({super.key, required this.totalScore});

  String getRiskCategory() {
    if (totalScore >= 0 && totalScore <= 7) {
      return "Risiko Rendah";
    } else if (totalScore >= 8 && totalScore <= 14) {
      return "Risiko Sedang";
    } else {
      return "Risiko Tinggi";
    }
  }

  Color getRiskColor() {
    if (totalScore >= 0 && totalScore <= 7) {
      return const Color(0xFF4CAF50);
    } else if (totalScore >= 8 && totalScore <= 14) {
      return const Color(0xFFF0F980);
    } else {
      return const Color(0xFFF44336);
    }
  }

  String getRiskIcon() {
    if (totalScore >= 0 && totalScore <= 7) {
      return 'assets/icon/Heart.png';
    } else if (totalScore >= 8 && totalScore <= 14) {
      return 'assets/icon/warning.png';
    } else {
      return 'assets/icon/alert.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String riskCategory = getRiskCategory();
    final Color riskColor = getRiskColor();
    final String riskIcon = getRiskIcon();

    return Scaffold(
      backgroundColor: const Color(0xFF199A8E),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Hasil Screening',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF199A8E),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Hasil Tes Risiko Diabetes",
                  style: TextStyle(
                    fontFamily: 'DarumadropOne',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.black.withOpacity(0.4),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: riskColor.withOpacity(0.2),
                          ),
                          child: Image.asset(
                            riskIcon,
                            width: 125,
                            height: 125,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Total Skor: $totalScore",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          riskCategory,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: riskColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Berdasarkan hasil tes ini, Anda memiliki $riskCategory terhadap diabetes.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Jika memiliki risiko sedang atau tinggi, pertimbangkan untuk berkonsultasi dengan dokter.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavBottom()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF199A8E),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.black.withOpacity(0.5),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Kembali ke Beranda",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}