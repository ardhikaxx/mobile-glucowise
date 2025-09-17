import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/model/edukasi.dart';
import 'package:medical_app/services/edukasi_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class DetailEdukasiScreen extends StatefulWidget {
  final Edukasi edukasi;

  const DetailEdukasiScreen({super.key, required this.edukasi});

  @override
  State<DetailEdukasiScreen> createState() => _DetailEdukasiScreenState();
}

class _DetailEdukasiScreenState extends State<DetailEdukasiScreen> {
  List<Edukasi> otherEdukasi = [];
  bool isLoadingOtherEdukasi = true;

  @override
  void initState() {
    super.initState();
    _loadOtherEdukasi();
  }

  Future<void> _loadOtherEdukasi() async {
    try {
      final allEdukasi = await EdukasiServices.getEdukasi(context);
      setState(() {
        otherEdukasi = allEdukasi
            .where((e) => e.idEdukasi != widget.edukasi.idEdukasi)
            .take(3) // Limit to 3 related articles
            .toList();
        isLoadingOtherEdukasi = false;
      });
    } catch (e) {
      setState(() {
        isLoadingOtherEdukasi = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: size.height * 0.35,
              pinned: true,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.edukasi.gambarUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    // Gradient overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      FontAwesomeIcons.chevronLeft,
                      color: Color(0xFF199A8E),
                      size: 23,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and Date
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF199A8E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.edukasi.kategori,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF199A8E),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _formatDate(widget.edukasi.tanggalPublikasi),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.edukasi.judul,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF199A8E),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ReadMoreText(
                      widget.edukasi.deskripsi,
                      trimLines: 5,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Baca Selengkapnya',
                      trimExpandedText: 'Sembunyikan',
                      moreStyle: const TextStyle(
                        color: Color(0xFF199A8E),
                        fontWeight: FontWeight.bold,
                      ),
                      lessStyle: const TextStyle(
                        color: Color(0xFF199A8E),
                        fontWeight: FontWeight.bold,
                      ),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Divider
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                      height: 1,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Edukasi Terkait',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Related Articles List
            isLoadingOtherEdukasi
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : otherEdukasi.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Belum ada edukasi terkait',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = otherEdukasi[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailEdukasiScreen(edukasi: item),
                                    ),
                                  );
                                },
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
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: item.gambarUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.white,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                                Icons.broken_image,
                                                size: 30),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.kategori,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color:
                                                      const Color(0xFF199A8E),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item.judul,
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                _formatDate(
                                                    item.tanggalPublikasi),
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey[600],
                                          size: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: otherEdukasi.length,
                        ),
                      ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}
