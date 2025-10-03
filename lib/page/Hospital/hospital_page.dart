import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/services/hospital_services.dart';
import 'hospital_detail.dart';

class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  late Future<HospitalResponse> _hospitalsFuture;
  List<Hospital> _filteredHospitals = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _hospitalsFuture = HospitalService.getHospitals();
    _hospitalsFuture.then((response) {
      if (mounted) {
        setState(() {
          _filteredHospitals = response.data;
        });
      }
    });
  }

  void _filterHospitals(String query) {
    _hospitalsFuture.then((response) {
      if (mounted) {
        setState(() {
          if (query.isEmpty) {
            _filteredHospitals = response.data;
          } else {
            _filteredHospitals = response.data.where((hospital) {
              final namaLower = hospital.namaRumahSakit.toLowerCase();
              final tempatLower = hospital.tempat.toLowerCase();
              final jenisLower = hospital.jenis.toLowerCase();
              final queryLower = query.toLowerCase();

              return namaLower.contains(queryLower) ||
                  tempatLower.contains(queryLower) ||
                  jenisLower.contains(queryLower);
            }).toList();
          }
        });
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _hospitalsFuture.then((response) {
        if (mounted) {
          setState(() {
            _filteredHospitals = response.data;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        title: const Text(
          'Rumah Sakit',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterHospitals,
                onTap: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari rumah sakit...',
                  prefixIcon: const Icon(
                    FontAwesomeIcons.search,
                    color: Color(0xFF199A8E),
                    size: 18,
                  ),
                  suffixIcon: _isSearching || _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.times,
                            color: Colors.grey,
                            size: 18,
                          ),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Info jumlah rumah sakit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  '${_filteredHospitals.length} Rumah Sakit Ditemukan',
                  style: const TextStyle(
                    color: Color(0xFF199A8E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // List rumah sakit
          Expanded(
            child: FutureBuilder<HospitalResponse>(
              future: _hospitalsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: const Color(0xFF199A8E),
                      size: 50,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FDFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE8F3F1),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.exclamationCircle,
                              size: 32,
                              color: Color(0xFF199A8E),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Gagal Memuat Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF199A8E),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _hospitalsFuture =
                                    HospitalService.getHospitals();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF199A8E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Coba Lagi',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final hospitals = _filteredHospitals;

                  if (hospitals.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FDFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE8F3F1),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.hospital,
                              size: 32,
                              color: Color(0xFF199A8E),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Tidak Ada Hasil',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF199A8E),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Tidak ditemukan rumah sakit yang sesuai dengan pencarian Anda.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = hospitals[index];
                      return _buildHospitalCard(hospital, context);
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Tidak ada data yang tersedia'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HospitalDetailPage(hospital: hospital),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3F1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Icon(
                    FontAwesomeIcons.hospital,
                    color: Color(0xFF199A8E),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.namaRumahSakit,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF199A8E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hospital.tempat,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hospital.jenis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF199A8E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
