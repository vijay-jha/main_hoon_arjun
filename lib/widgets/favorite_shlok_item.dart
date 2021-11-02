import 'package:flutter/material.dart';

import './speaker_icon_button.dart';
import '../screens/desired_shlok_screen.dart';

class FavoriteShlokItem extends StatefulWidget {
  final Map<String, dynamic> shlok;
  FavoriteShlokItem(this.shlok);
  @override
  _FavoritesShlok2State createState() => _FavoritesShlok2State();
}

class _FavoritesShlok2State extends State<FavoriteShlokItem> {
  var isVolume = false;

  void _onTapOnShlok() {
    Navigator.of(context).pushNamed(
      DesiredShlokScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 3,
      child: Container(
        height: 160, // Previou : 140
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF8E1),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: _onTapOnShlok,
              child: Container(
                margin:
                    const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                child: ShlokCard(shlok: widget.shlok["Shlok"]),
                width: double.infinity,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // shlok numbering Lable
                Container(
                  // margin: const EdgeInsets.only(left: 29.7, top: 3),
                  child: CommentsButton(),
                  alignment: Alignment.center,
                ),

                SpeakerIcnBtn(),

                Container(
                  alignment: Alignment.center,
                  width: 88,
                  // margin: const EdgeInsets.only(right: 0, top: 3),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.orange.shade100,
                  ),
                  child: Text(
                    widget.shlok["Number"],
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        margin: const EdgeInsets.only(
          left: 8,
          top: 8,
          bottom: 8,
          right: 8,
        ),
        height: 75,
        alignment: Alignment.center,
        child: Text(
          shlok.trim(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
    return TextButton.icon(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.orange.withOpacity(0.2);
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return Colors.orange.withOpacity(0.2);
            }
            return null; // Defer to the widget's default.
          },
        ),
      ),
      onPressed: () {},
      icon: const Icon(
        Icons.comment_rounded,
        color: Colors.black87,
        size: 20,
      ),
      label: const Text(
        "Comments",
        style: TextStyle(color: Colors.black87, fontSize: 12),
      ),
    );
  }
}
