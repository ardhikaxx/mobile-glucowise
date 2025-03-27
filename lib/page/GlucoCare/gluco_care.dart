import 'dart:async'; // Untuk Timer
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart'; // Untuk notifikasi
import 'package:audioplayers/audioplayers.dart'; // Untuk memutar audio
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/GlucoCare/edit_care.dart';
import 'package:medical_app/page/GlucoCare/riwayat_care.dart';
import 'package:medical_app/page/GlucoCare/form_care.dart';
import 'package:medical_app/services/care_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GlucoCareScreen extends StatefulWidget {
  final UserData userData;
  const GlucoCareScreen({super.key, required this.userData});

  @override
  _GlucoCareScreenState createState() => _GlucoCareScreenState();
}

class _GlucoCareScreenState extends State<GlucoCareScreen> {
  List<Map<String, dynamic>> jadwalObat = [];
  List<Map<String, dynamic>> riwayatObat = [];
  bool isLoading = true;
  Timer? _alarmTimer; // Timer untuk mengecek alarm
  final AudioPlayer _audioPlayer = AudioPlayer(); // Untuk memutar alarm.mp3
  bool _isAlarmPlaying = false; // Status apakah alarm sedang berbunyi
  bool _isDisposed =
      false; // Flag untuk menandai apakah widget sudah di-dispose

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    _loadData();
    _startAlarmChecker(); // Mulai pengecekan alarm
  }

  @override
  void dispose() {
    _isDisposed = true;
    _alarmTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startAlarmChecker() {
    // Cek alarm setiap detik
    _alarmTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isDisposed) {
        // Hanya jalankan jika widget masih mounted
        _checkAlarms();
      }
    });
  }

  void _checkAlarms() async {
    final now = DateTime.now();
    final currentDate = DateFormat('yyyy-MM-dd').format(now);
    final currentTime = DateFormat('HH:mm:ss').format(now);

    for (var alarm in jadwalObat) {
      final alarmDate = alarm["tanggal"];
      final alarmTime = alarm["jam_minum"];

      if (alarmDate == currentDate &&
          alarmTime == currentTime &&
          !_isAlarmPlaying &&
          !_isDisposed) {
        // Pastikan widget masih mounted
        await _playAlarmSound();
        if (!_isDisposed) {
          // Pastikan widget masih mounted sebelum menampilkan notifikasi
          _showAlarmNotification(context, alarm);
        }
        break; // Hentikan pengecekan setelah menemukan alarm yang sesuai
      }
    }
  }

  Future<void> _playAlarmSound() async {
    await _audioPlayer.play(AssetSource('alarm.mp3'),
        mode: PlayerMode.lowLatency);
    _audioPlayer.setReleaseMode(ReleaseMode.loop); // Set alarm untuk looping
    if (!_isDisposed) {
      setState(() {
        _isAlarmPlaying = true; // Set status alarm sedang berbunyi
      });
    }
  }

  Future<void> _stopAlarmSound() async {
    await _audioPlayer.stop(); // Menghentikan suara alarm
    if (!_isDisposed) {
      setState(() {
        _isAlarmPlaying = false;
      });
    }
  }

  void _showAlarmNotification(
      BuildContext context, Map<String, dynamic> alarm) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Waktunya Minum Obat!',
      text: '${alarm["nama_obat"]} - ${alarm["dosis"]}',
      confirmBtnText: 'Stop',
      onConfirmBtnTap: () async {
        await _stopAlarmSound();
        if (!_isDisposed) {
          Navigator.pop(context); // Tutup notifikasi
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RiwayatCareScreen(riwayatObat: riwayatObat),
            ),
          );
        }
      },
    );
  }

  void _loadData() async {
    if (_isDisposed) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> activeData = await CareServices.getActiveCare(context);
      List<dynamic> riwayatData = await CareServices.getRiwayatCare(context);

      await Future.delayed(const Duration(seconds: 1));

      if (!_isDisposed) {
        setState(() {
          jadwalObat = List<Map<String, dynamic>>.from(activeData);
          riwayatObat = List<Map<String, dynamic>>.from(riwayatData);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");

      await Future.delayed(const Duration(seconds: 1));

      if (!_isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Gluco Care",
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: _buildIconButton(
            icon: FontAwesomeIcons.chevronLeft,
            onTap: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _buildIconButton(
              icon: FontAwesomeIcons.plus,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FormCareScreen()),
                ).then((_) => _loadData());
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Color(0xFF199A8E),
                size: 50,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSelector(),
                  const SizedBox(height: 12),
                  _buildSectionTitle("Jadwal Minum Obat"),
                  _buildScrollableCardList(context, jadwalObat,
                      status: "Aktif"),
                  const SizedBox(height: 12),
                  _buildSectionTitle("Riwayat Minum Obat"),
                  _buildScrollableCardList(context, riwayatObat,
                      isHistory: true, status: "Sudah"),
                ],
              ),
            ),
    );
  }

  Widget _buildDateSelector() {
    DateTime today = DateTime.now();
    List<DateTime> upcomingDays =
        List.generate(7, (index) => today.add(Duration(days: index)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Tanggal Hari Ini",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: upcomingDays.length,
            itemBuilder: (context, index) {
              DateTime date = upcomingDays[index];
              bool isToday = date.day == today.day &&
                  date.month == today.month &&
                  date.year == today.year;

              return Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFFE8F3F1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('d').format(date),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: isToday ? const Color(0xFF199A8E) : Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isToday ? const Color(0xFF199A8E) : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF199A8E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildScrollableCardList(
    BuildContext context,
    List<Map<String, dynamic>> data, {
    bool isHistory = false,
    String status = "Aktif",
  }) {
    double cardHeight = 70.0;
    bool isScrollable = data.length > 3;

    if (data.isEmpty) {
      return const Center(child: Text("Tidak ada data."));
    }

    return SizedBox(
      height: isScrollable ? cardHeight * 3.5 : null,
      child: isScrollable
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  _buildCard(context, data[index], isHistory, status),
            )
          : Column(
              children: data
                  .map((item) => _buildCard(context, item, isHistory, status))
                  .toList(),
            ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    Map<String, dynamic> data,
    bool isHistory,
    String status,
  ) {
    Color statusColor = status == "Sudah" ? Colors.green : Colors.red;
    IconData statusIcon = status == "Sudah"
        ? FontAwesomeIcons.checkCircle
        : FontAwesomeIcons.exclamationCircle;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3F1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 28),
        title: Text(
          data["nama_obat"] ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Text(
              data["tanggal"] ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(width: 10),
            Text(
              "Jam: ${data["jam_minum"] ?? ''}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            status,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
          ),
        ),
        onTap: () {
          if (isHistory) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RiwayatCareScreen(riwayatObat: riwayatObat),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditCareScreen(alarm: data),
              ),
            ).then((_) => _loadData());
          }
        },
      ),
    );
  }
}
