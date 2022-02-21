import 'package:flutter/material.dart';

class BookmarkCard extends StatelessWidget {
  BookmarkCard() : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[100],
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 0.5), //(x,y)
            blurRadius: 3.0,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(left: 20 ,top: 12 ,bottom: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20 ,vertical: 12),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children:  [
              Text(
                "Adhyay 1 Shlok 1",
                style: TextStyle(
                    color: Colors.orange[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )
            ],
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white
              ),
              child: const Text(
                """धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |
मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय """,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
