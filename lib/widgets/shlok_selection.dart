import 'package:flutter/material.dart';

class ShlokSelection extends StatefulWidget {
  final PageController pageController;
  const ShlokSelection({@required this.pageController, Key key})
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
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutSine);

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
    var _deviceSize = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(horizontal: 14),
            height: _deviceSize / 1.8,
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration:const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                    child: Center(
                      child: Text(
                        "Shloks",
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.w800,
                            fontSize: 21),
                      ),
                    )),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 50),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedItem = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedItem == index
                                  ? Colors.black
                                  : Colors.orange,
                            ),
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              (index + 1).toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                ),
                Stack(children: [
                  Positioned(
                    child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: GestureDetector(
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
                            color: Colors.orange,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: const Text(
                            "OK",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
