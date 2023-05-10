import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:photogalery/pages/formfield.dart';

import 'address.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({super.key});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class IMAGEWidget extends StatefulWidget {
  final double imageheight;
  final double imagewidth;
  final StackFit imagefit;
  TextStyle? photographertext = GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white);

  final Function Ondeletepressed;
  final Function Onlikepressed;
  TextStyle? txtstyle = GoogleFonts.poppins(
      fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white);

  final AppGallery photogallery;

  final BoxFit boxfit;

  final String formatetime;

  IMAGEWidget({
    super.key,
    required this.Ondeletepressed,
    required this.Onlikepressed,
    required this.imageheight,
    required this.imagewidth,
    required this.imagefit,
    required this.boxfit,
    required this.formatetime,
    required this.photogallery,
  });

  @override
  State<IMAGEWidget> createState() => _IMAGEWidgetState();
}

class _IMAGEWidgetState extends State<IMAGEWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.imageheight,
      width: widget.imagewidth,
      child: Stack(
        fit: widget.imagefit,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Image.network(
              widget.photogallery.PhotoURL,
              fit: widget.boxfit,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.only(bottom: 200),
                  color: Colors.transparent.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 9.09, bottom: 8),
            alignment: Alignment.bottomRight,
            child: Text("-by " + widget.photogallery.Photgraphername,
                // ignore: prefer_const_constructors
                style: widget.photographertext),
          ),
          Container(
              padding: const EdgeInsets.only(bottom: 28.85, left: 9),
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.photogallery.Description,
                // ignore: prefer_const_constructors
                style: widget.txtstyle,
              )),
          Container(
              margin: const EdgeInsets.only(top: 16, right: 12),
              constraints: BoxConstraints(
                minHeight: 36,
              ),
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => widget.photogallery,
                icon: const Icon(
                  Icons.delete_rounded,
                  color: Colors.redAccent,
                  size: 40,
                ),
              )),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(bottom: 11, left: 9),
            child: Text(
              widget.formatetime,
              style: widget.txtstyle,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 16.44, left: 14.44),
            child: IconButton(
                constraints: BoxConstraints(minHeight: 36.67),
                onPressed: () {
                  widget.Onlikepressed;
                },
                icon: Icon(
                  widget.photogallery.Isliked ? Icons.favorite : Icons.favorite,
                  color: widget.photogallery.Isliked
                      ? Colors.redAccent
                      : Colors.white,
                  size: 40,
                )),
          ),
        ],
      ),
    );
  }
}
