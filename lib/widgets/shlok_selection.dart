import 'package:flutter/material.dart';

class ShlokSelection extends StatefulWidget {
  final PageController pageController;
  final List<Map<String, dynamic>> chapterData;
  final List<String> shlokList;
  const ShlokSelection(
      {@required this.pageController,
      this.chapterData,
      this.shlokList,
      Key key})
      : super(key: key);

  @override
  _ShlokSelectionState createState() => _ShlokSelectionState();
}

class _ShlokSelectionState extends State<ShlokSelection>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  int selectedItem = -1;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.reverse();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return ScaleTransition(
      scale: scaleAnimation,
      child: Center(
        child: AnimatedContainer(
          duration: Duration(minutes: 2),
          decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: _deviceSize.height / 1.6,
          child: Column(children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: Center(
                  child: Text(
                    "Jump to Shlok",
                    style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w800,
                        fontSize: 22),
                  ),
                )),
            Container(
              height: _deviceSize.height / 2.2,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 72,
                    mainAxisExtent: 50,
                  ),
                  itemCount: widget.shlokList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItem = index;
                          // Navigator.pop(context);
                          //  widget.pageController.jumpToPage(selectedItem);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: selectedItem == index
                              ? Colors.orange[900]
                              : Colors.orange,
                        ),
                        margin: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          widget.shlokList[index].substring(5),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                //page change animation
                if (selectedItem != -1) {
                  widget.pageController.jumpToPage(selectedItem);
                  // widget.pageController.animateToPage(selectedItem,
                  //     duration: const Duration(milliseconds: 700),
                  //     curve: Curves.bounceInOut);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red[600],
                ),
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                margin: EdgeInsets.symmetric(
                    horizontal: _deviceSize.width / 3.2, vertical: 26),
                child: const Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
