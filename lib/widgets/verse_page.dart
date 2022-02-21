import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VersePage extends StatefulWidget {
  int verseNumber;
  String shlokTitle;
  final PageController pageController;
  final String shlokText;
  final Map<String,dynamic >translation;
  final Map<String,dynamic> meaning;

  VersePage({Key key, @required this.verseNumber, this.pageController,this.shlokTitle,this.shlokText,this.translation,this.meaning})
      : super(key: key);

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> with TickerProviderStateMixin {
  AnimationController _controller;
  bool isEnglish = true;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String meaning = isEnglish
        ?  widget.translation['english']
        : widget.translation['hindi'];
    String explanation = isEnglish
        ? widget.meaning['english']
        : widget.meaning['hindi'];

    return SingleChildScrollView(
      child: Column(
        children: [
          //shlok number
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF37323E),
            ),
            padding: const EdgeInsets.all(11),
            child: Text(
              'Shlok ${widget.shlokTitle}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.yellow,
                fontSize: 17,
                fontFamily: 'NotoSansMono',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // SizedBox(width: 30,
              // ),
              IconButton(onPressed: () => {}, icon: const Icon(Icons.bookmark)),
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                child: IconButton(
                  icon: isEnglish
                      ? const Text(
                          "अ",
                          style: TextStyle(fontSize: 20),
                        )
                      : const Text(
                          "A",
                          style: TextStyle(fontSize: 20),
                        ),
                  onPressed: () {
                    setState(() {
                      if (isEnglish) {
                        isEnglish = !isEnglish;
                        _controller.forward();
                      } else {
                        isEnglish = !isEnglish;
                        _controller.reverse();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
//                 """धृतराष्ट्र उवाच |धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |
// मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय """,
                widget.shlokText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          CustomWidget(title: "Meaning", content: meaning),
          CustomWidget(
            title: "Explanation",
            content: explanation,
          ),

          //Navigation arrows
          Row(
            mainAxisAlignment: widget.verseNumber != 1
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (widget.verseNumber != 1)
                GestureDetector(
                  onTap: () {
                    int previsoupage = widget.verseNumber - 2;
                    widget.pageController.animateToPage(previsoupage,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.bounceInOut);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 40, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        //arrow
                        Icon(
                          Icons.keyboard_arrow_left_sharp,
                          color: Colors.black,
                        ),
                        Text(
                          "Prev",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  widget.pageController.animateToPage(widget.verseNumber,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.bounceInOut);
                },
                child: Container(
                    margin:
                        const EdgeInsets.only(right: 40, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        //arrow
                        Text(
                          "Next",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.keyboard_arrow_right_outlined),
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  final String title;
  final String content;
  const CustomWidget({
    this.title,
    this.content,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(bottom: 12, right: 12, top: 12, left: 30),
            margin: const EdgeInsets.only(
              bottom: 7,
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              color: Color(0xFF37323E),
            ),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 6, bottom: 28, left: 12, right: 12),
            child: Text(
              content,
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
