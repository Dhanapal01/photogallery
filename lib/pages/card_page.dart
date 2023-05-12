import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogalery/pages/button/button_widget.dart';
import 'address_page.dart';

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

class CardWidget extends StatefulWidget {
  final double imageHeight;
  final double imageWidth;
  final StackFit imageFit;
  TextStyle? photographerText = GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white);

  final Function onDeletePressed;
  final Function onLikePressed;
  TextStyle? txtStyle = GoogleFonts.poppins(
      fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white);

  final AppGallery photoGallery;

  final BoxFit boxFit;

  final String formatTime;

  CardWidget({
    super.key,
    required this.onDeletePressed,
    required this.onLikePressed,
    required this.imageHeight,
    required this.imageWidth,
    required this.imageFit,
    required this.boxFit,
    required this.formatTime,
    required this.photoGallery,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    bool checkboxValue1 = false;
    bool checkboxValue2 = true;
    bool checkboxValue3 = true;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: () {
          showDialog(
              useSafeArea: true,
              context: context,
              builder: (context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  content: SizedBox(
                    width: width,
                    height: height,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Image.network(
                          widget.photoGallery.photoURL,
                          fit: BoxFit.contain,
                        )),
                  ),
                  actions: [
                    Center(
                      child: CustomButton(
                          title: "CLOSE",
                          onPressed: () => Navigator.pop(context)),
                    )
                  ],
                );
              });
        },
        child: SizedBox(
          height: widget.imageHeight,
          width: widget.imageWidth,
          child: Stack(
            fit: widget.imageFit,
            children: <Widget>[
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Image.network(
                    widget.photoGallery.photoURL,
                    fit: widget.boxFit,
                  )),
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
                child: Text("-by ${widget.photoGallery.photgrapherName}",
                    // ignore: prefer_const_constructors
                    style: widget.photographerText),
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 28.85, left: 9),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.photoGallery.description,
                    // ignore: prefer_const_constructors
                    style: widget.txtStyle,
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 16, right: 12),
                  constraints: const BoxConstraints(
                    minHeight: 36,
                  ),
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () =>
                        widget.onDeletePressed(widget.photoGallery),
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
                  widget.formatTime,
                  style: widget.txtStyle,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 16.44, left: 14.44),
                child: IconButton(
                    constraints: const BoxConstraints(minHeight: 36.67),
                    onPressed: () => widget.onLikePressed(widget.photoGallery),
                    icon: Icon(
                      widget.photoGallery.isLiked
                          ? Icons.favorite
                          : Icons.favorite,
                      color: widget.photoGallery.isLiked
                          ? Colors.redAccent
                          : Colors.white,
                      size: 40,
                    )),
              ),
            ],
          ),
        ));
  }
}
