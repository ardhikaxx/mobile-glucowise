import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/GlucoCare/edit_care.dart';
import 'package:medical_app/page/GlucoCare/riwayat_care.dart';
import 'package:medical_app/page/GlucoCare/form_care.dart';
import 'package:medical_app/services/care_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class GlucoCareScreen extends StatefulWidget {
  final UserData userData;
  const GlucoCareScreen({super.key, required this.userData});

  @override
  State<GlucoCareScreen> createState() => _GlucoCareScreenState();
}

class _GlucoCareScreenState extends State<GlucoCareScreen> {
  List<Map<String, dynamic>> jadwalObat = [];
  List<Map<String, dynamic>> riwayatObat = [];
  bool isLoading = true;
  Timer? _alarmTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAlarmPlaying = false;
  bool _isDisposed = false;
  Timer? _alarmRepeatTimer;
  Timer? _reminderTimer;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _currentAlarmId = 0;
  final Set<int> _activeNotificationIds = {};
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    _loadData();
    init();
    _startAlarmChecker();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _alarmTimer?.cancel();
    _alarmRepeatTimer?.cancel();
    _reminderTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> init() async {
    initializeTimeZones();
    setLocalLocation(getLocation('Asia/Jakarta'));
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null && response.payload!.startsWith('stop_alarm_')) {
          await _stopAlarmSound();
        } else if (response.actionId == 'stop_action') {
          await _stopAlarmSound();
        }
      },
    );
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    _activeNotificationIds.add(id);
    await notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notifications',
          channelDescription: 'Instant notification channel',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false,
          actions: [
            AndroidNotificationAction(
              'stop_action',
              'Matikan Alarm',
              cancelNotification: true,
            ),
          ],
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'alarm_category',
          threadIdentifier: 'alarm_thread',
        ),
      ),
      payload: payload,
    );
  }

  void _startAlarmChecker() {
    _alarmTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isDisposed) {
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
          !_isDisposed &&
          _notificationCount == 0) {
        _currentAlarmId = DateTime.now().millisecondsSinceEpoch % 100000;
        await showInstantNotification(
          id: _currentAlarmId,
          title: 'Waktunya Minum Obat!',
          body: '${alarm["nama_obat"]} - ${alarm["dosis"]}',
          payload: 'stop_alarm_${alarm["id"]}',
        );
        await _playAlarmSound();
        _startRepeatingReminder(alarm);
      }
    }
  }

  void _startRepeatingReminder(Map<String, dynamic> alarm) {
    _notificationCount = 1;
    _reminderTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_notificationCount >= 3 || !_isAlarmPlaying || _isDisposed) {
        timer.cancel();
        return;
      }

      _notificationCount++;
      int newId = _currentAlarmId + _notificationCount;

      await showInstantNotification(
        id: newId,
        title: 'Pengingat Minum Obat!',
        body: '${alarm["nama_obat"]} - ${alarm["dosis"]}',
        payload: 'stop_alarm_${alarm["id"]}',
      );
    });
  }

  Future<void> _playAlarmSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('alarm.mp3'),
          mode: PlayerMode.lowLatency);
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      if (!_isDisposed) {
        setState(() {
          _isAlarmPlaying = true;
        });
      }
    } catch (e) {
      print("Error playing alarm: $e");
    }
  }

  Future<void> _stopAlarmSound() async {
    try {
      await _audioPlayer.stop();
      _alarmRepeatTimer?.cancel();
      _reminderTimer?.cancel();

      for (var id in _activeNotificationIds) {
        await notificationsPlugin.cancel(id);
      }
      _activeNotificationIds.clear();

      if (!_isDisposed) {
        setState(() {
          _isAlarmPlaying = false;
          _currentAlarmId = 0;
          _notificationCount = 0;
        });
      }
    } catch (e) {
      print("Error stopping alarm: $e");
    }
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

  Widget _buildNoDataCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FDFC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE8F3F1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF138075),
                  Color(0xFF199A8E),
                  Color(0xFF23B8A9),
                ],
                stops: [0.0, 0.5, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1DE9B6).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF199A8E),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormCareScreen(),
                ),
              ).then((_) => _loadData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF199A8E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Tambahkan Jadwal",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
      body: SafeArea(
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: const Color(0xFF199A8E),
                  size: 50,
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateSelector(),
                    const SizedBox(height: 12),
                    _buildSectionTitle("Jadwal Minum Obat"),
                    jadwalObat.isEmpty
                        ? _buildNoDataCard(
                            icon: FontAwesomeIcons.calendarCheck,
                            title: "Belum Ada Jadwal Obat",
                            subtitle:
                                "Tambahkan jadwal minum obat Anda untuk memulai pengingat",
                          )
                        : _buildScrollableCardList(context, jadwalObat,
                            status: "Aktif"),
                    const SizedBox(height: 12),
                    _buildSectionTitle("Riwayat Minum Obat"),
                    riwayatObat.isEmpty
                        ? _buildNoDataCard(
                            icon: FontAwesomeIcons.history,
                            title: "Belum Ada Riwayat",
                            subtitle: "Riwayat minum obat akan muncul di sini",
                          )
                        : _buildScrollableCardList(context, riwayatObat,
                            isHistory: true, status: "Sudah"),
                  ],
                ),
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
    bool isScrollable = data.length > 4;

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
