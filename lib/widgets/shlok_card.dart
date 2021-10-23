import 'package:flutter/material.dart';

class ShlokCard extends StatefulWidget {
  ShlokCard({
    @required this.shlok,
  });

  final String shlok;

  @override
  State<ShlokCard> createState() => _ShlokCardState();
}

class _ShlokCardState extends State<ShlokCard> {
  var isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin:
              const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 10),
          child: shlokCard(),
        ),
        Positioned(
          top: 30,
          right: 15,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Container shlokCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 30,
        ),
        child: Text(
          widget.shlok.trim(),
          style: TextStyle(
            color: Colors.orange.shade900,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }
}
