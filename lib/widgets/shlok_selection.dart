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
          height: _deviceSize.height / 1.65,
          child: Column(children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 6),
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
                        fontWeight: FontWeight.w700,
                        fontSize: 22),
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(
                    bottom: _deviceSize.height * 0.011,
                    left: _deviceSize.width * 0.25,
                    right: _deviceSize.width * 0.25),
                child: Divider(
                  thickness: 1,
                  height: 1,
                )),
            Container(
              height: _deviceSize.height / 2.3,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: _deviceSize.width * 0.19,
                    mainAxisExtent: _deviceSize.height * 0.058,
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
                // page change animation
                if (selectedItem != -1) {
                  widget.pageController.jumpToPage(selectedItem);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange[100],
                    border: Border.all(width: 1, color: Colors.orange[300])),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: _deviceSize.width * 0.04,
                    vertical: _deviceSize.height * 0.005),
                margin: EdgeInsets.only(
                    left: _deviceSize.width / 3.4,
                    right: _deviceSize.width / 3.4,
                    top: _deviceSize.height * 0.023,
                    bottom: _deviceSize.height * 0.013),
                child: const Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
