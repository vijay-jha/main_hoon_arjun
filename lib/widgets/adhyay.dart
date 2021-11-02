import 'package:flutter/material.dart';

import '../screens/adhyay_overview_screen.dart';

class Adhyay extends StatelessWidget {
  final String title;
  final String name;
  Adhyay(this.title, this.name);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdhyayOverviewScreen(
                    title: title,
                    adhyayName: name,
                  ))),
      child: Container(
        // height: 200,
        padding:
            const EdgeInsets.only(left: 11, top: 10, bottom: 10, right: 11),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          width: 170,
          height: 200,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 2, left: 2, right: 2, bottom: 5),
                    // padding: EdgeInsets.all(2),
                    height: 200,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      child: Image.asset(
                        "assets/images/Geeta.jfif",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_add_outlined)),
                    ],
                  )
                ]),
              ),
                Container(
                padding: const EdgeInsets.only(left: 4, bottom: 0),
                width: double.infinity,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 20,  // Previous value 23
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 3),
                width: double.infinity,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
