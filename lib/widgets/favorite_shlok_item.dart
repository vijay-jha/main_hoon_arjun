import 'package:flutter/material.dart';

import './speaker_icon_button.dart';
import '../screens/desired_shlok_screen.dart';

class FavoriteShlokItem extends StatefulWidget {
  final Map<String, dynamic> shlok;
  FavoriteShlokItem(this.shlok);
  @override
  _FavoritesShlokState createState() => _FavoritesShlokState();
}

class _FavoritesShlokState extends State<FavoriteShlokItem> {
  void _onTapShlok() {
    Navigator.of(context).pushNamed(
      DesiredShlokScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        top: 15,
        bottom: 5,
        left: 10,
        right: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 3,
      child: Container(
        height: 245,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                widget.shlok["Number"],
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            InkWell(
              onTap: _onTapShlok,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                  right: 10,
                ),
                child: ShlokCard(shlok: widget.shlok["Shlok"]),
                width: double.infinity,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // shlok numbering Lable
                  Container(
                    child: CommentsButton(),
                    alignment: Alignment.center,
                  ),

                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: SpeakerIcnBtn(
                      widget.shlok["Number"],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShlokCard extends StatelessWidget {
  ShlokCard({
    @required this.shlok,
  });

  final String shlok;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 23,
        ),
        height: 168,
        alignment: Alignment.center,
        child: Text(
          shlok.trim(),
          style: TextStyle(
            fontSize: 26,
            color: Colors.orange.shade800,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}

class CommentsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.comment_rounded,
        color: Colors.black87,
        size: 25,
      ),
    );
  }
}
