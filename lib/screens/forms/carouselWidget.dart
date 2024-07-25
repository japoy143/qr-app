import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  final pageIndex;
  final color;
  const CarouselWidget(
      {super.key, required this.pageIndex, required this.color});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: widget.pageIndex == index
                ? Container(
                    height: 12,
                    width: 24,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  )
                : Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ));
      }),
    );
  }
}
