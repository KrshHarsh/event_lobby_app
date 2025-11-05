import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  const ImageCarousel({super.key, required this.images});
  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int current = 0;

  void openFull(int idx) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: PhotoViewGallery.builder(
          itemCount: widget.images.length,
          builder: (ctx, i) => PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(widget.images[i]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
          pageController: PageController(initialPage: idx),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(height: 240, color: Colors.grey.shade200, child: const Center(child: Icon(Icons.photo, size: 64)));
    }
    return Column(children: [
      CarouselSlider.builder(
        itemCount: widget.images.length,
        itemBuilder: (ctx, idx, real) {
          final url = widget.images[idx];
          return GestureDetector(
            onTap: () => openFull(idx),
            child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover, width: double.infinity, height: 240),
          );
        },
        options: CarouselOptions(height: 240, viewportFraction: 1, onPageChanged: (i, r) => setState(() => current = i)),
      ),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: widget.images.asMap().entries.map((e) {
        return Container(
          width: current == e.key ? 12 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(color: current == e.key ? Theme.of(context).colorScheme.primary : Colors.grey, borderRadius: BorderRadius.circular(3)),
        );
      }).toList())
    ]);
  }
}
