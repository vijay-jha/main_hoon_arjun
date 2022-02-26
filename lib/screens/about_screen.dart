import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about-screen';
  var name = "४"; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      // appBar: AppBar(
      //   title: const Text("About Main Hoon Arjun"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              ClipPath(
                clipper: Myclipper(),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        // padding: EdgeInsets.all(14),
                        height: MediaQuery.of(context).size.height/2.3,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.orange),
                        child: Image.asset(
                          "assets/images/mai_hoon_arjun_logo.png",
                          color: Colors.white,
                          cacheHeight: (MediaQuery.of(context).size.height/3.5).round(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 30,
                ),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop()),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "About",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 0),
              child: Text(
                """'Mai Hoon Arjun' is based on the 'Shrimad Bhagvad Geeta' which has solution  for controlling all human feelings.The app provides shloks with enriched translation and meaning based on user feelings. 

Our misssion is to spread the learnings from 'Shrimad Bhagvad Geeta' and make people aware of this great treasure.""",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.normal),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 56, bottom: 12),
              child: Column(
                children: [
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 4, bottom: 2),
                        child: Text(
                          " Developed by",
                          style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                   
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Text(
                          "${name}izhad",
                          style: TextStyle(
                              color: Colors.orange[500],
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        )),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 36 ,bottom: 10),
                  child: Text(
                    "version 1.0",
                    style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class Myclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 90);
    path.quadraticBezierTo(
        size.width / 2.2, size.height, size.width, size.height - 90);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclipper) {
    return false;
  }
}
