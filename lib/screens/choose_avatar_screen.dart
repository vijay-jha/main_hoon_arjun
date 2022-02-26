// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;
import 'package:provider/provider.dart';

import '../providers/mahabharat_characters.dart';

class DisplayAvatar extends StatefulWidget {
  static const routeName = '/display-avatar-screen';

  @override
  _DisplayAvatarState createState() => _DisplayAvatarState();
}

class _DisplayAvatarState extends State<DisplayAvatar> {
  void _selectAvatar(int index) {
    setState(() {
      Provider.of<MahabharatCharacters>(context, listen: false)
          .currentAvatar(index);
    });
  }

  void _onTapAvatar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Avatar(
          onSelectAvatar: _selectAvatar,
          ctx: context,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Avatar"),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin:
                  EdgeInsets.symmetric(vertical: _deviceSize.height * 0.035),
              child: Text(
                Provider.of<MahabharatCharacters>(context, listen: true)
                    .getChosenAvatarName(),
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: _onTapAvatar,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                  top: _deviceSize.height * 0.0015,
                ),
                height: _deviceSize.height * 0.65,
                child: Image.asset(
                  Provider.of<MahabharatCharacters>(context, listen: true)
                      .getChosenAvatarLink(),
                  fit: BoxFit.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: _deviceSize.height * 0.01,
          ),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            )),
            onPressed: _onTapAvatar,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: "Change Your Avatar\t",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange.shade50,
    );
  }
}

@immutable
class Avatar extends StatefulWidget {
  Avatar({@required this.onSelectAvatar, @required this.ctx});
  final Function(int) onSelectAvatar;
  final BuildContext ctx;
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final _filterCharacters = ValueNotifier<String>(
    'assets/images/Arjun.png',
  );

  int currentPageIndex = 0;

  void _onFilterChanged(String value, int index) {
    _filterCharacters.value = value;
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Avatar"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildPhotoWithFilter(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 35),
              child: Text(
                Provider.of<MahabharatCharacters>(context, listen: false)
                    .getCharacterName(currentPageIndex),
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: _buildFilterSelector(),
          ),
        ],
      ),
      backgroundColor: Colors.orange.shade50,
    );
  }

  Widget _buildPhotoWithFilter() {
    return ValueListenableBuilder(
      valueListenable: _filterCharacters,
      builder: (context, value, child) {
        return Image.asset(
          value as String,
          fit: BoxFit.none,
        );
      },
    );
  }

  Widget _buildFilterSelector() {
    return FilterSelector(
      onSelectAvatar: widget.onSelectAvatar,
      onFilterChanged: _onFilterChanged,
      filters: Provider.of<MahabharatCharacters>(context, listen: false)
          .mahabharatCharacters,
    );
  }
}

@immutable
class FilterSelector extends StatefulWidget {
  FilterSelector({
    @required this.filters,
    @required this.onFilterChanged,
    @required this.onSelectAvatar,
    this.padding = const EdgeInsets.symmetric(vertical: 25.0),
  });

  final List<Map<String, String>> filters;
  final void Function(String link, int index) onFilterChanged;
  final Function(int) onSelectAvatar;
  final EdgeInsets padding;

  @override
  _FilterSelectorState createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  int currentIndexForSelect = 0;
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  PageController _controller;
  int _page;

  int get filterCount => widget.filters.length;

  @override
  void initState() {
    super.initState();
    _page = 0;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    if (page != _page) {
      _page = page;
      currentIndexForSelect = page;
      widget.onFilterChanged(widget.filters[page]['link'], page);
    }
  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }

  void _onAvatarSelect() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.orange.shade50,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Change Avatar"),
            Divider(
              thickness: 1,
            ),
          ],
        ),
        content: Text("Are you Sure you want to Change Avatar?"),
        actions: [
          OutlinedButton(
              onPressed: () async {
                await Future.delayed(Duration(milliseconds: 200));
                Navigator.of(context).pop();
              },
              child: Text("Cancel")),
          OutlinedButton(
              onPressed: () async {
                await Future.delayed(Duration(milliseconds: 200));
                widget.onSelectAvatar(
                  currentIndexForSelect,
                );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("Yes")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      physics: const PageScrollPhysics(),
      viewportBuilder: (context, viewportOffset) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemSize = constraints.maxWidth * _viewportFractionPerItem;
            viewportOffset
              ..applyViewportDimension(constraints.maxWidth)
              ..applyContentDimensions(0.0, itemSize * (filterCount - 1));

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildCarousel(
                  viewportOffset: viewportOffset,
                  itemSize: itemSize,
                ),
                GestureDetector(
                  onTap: _onAvatarSelect,
                  behavior: HitTestBehavior.translucent,
                  child: _buildSelectionRing(itemSize, _onAvatarSelect),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCarousel({
    @required ViewportOffset viewportOffset,
    @required double itemSize,
  }) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: Flow(
        delegate: CarouselFlowDelegate(
          viewportOffset: viewportOffset,
          filtersPerScreen: _filtersPerScreen,
        ),
        children: [
          for (int i = 0; i < filterCount; i++)
            FilterItem(
              onFilterSelected: () => _onFilterTapped(i),
              imageurl: widget.filters[i]["link"],
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionRing(double itemSize, VoidCallback onAvatarSelect) {
    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: Container(
          width: itemSize,
          height: itemSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
              BorderSide(
                width: 6.0,
                color: Colors.orange,
              ),
            ),
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.done_outlined),
          ),
        ),
      ),
    );
  }
}

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    @required this.viewportOffset,
    @required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    // All available painting width
    final size = context.size.width;

    // The distance that a single item "page" takes up from the perspective
    // of the scroll paging system. We also use this size for the width and
    // height of a single item.
    final itemExtent = size / filtersPerScreen;

    // The current scroll position expressed as an item fraction, e.g., 0.0,
    // or 1.0, or 1.3, or 2.9, etc. A value of 1.3 indicates that item at
    // index 1 is active, and the user has scrolled 30% towards the item at
    // index 2.
    final active = viewportOffset.pixels / itemExtent;

    // Index of the first item we need to paint at this moment.
    // At most, we paint 3 items to the left of the active item.
    final min = math.max(0, active.floor() - 3).toInt();

    // Index of the last item we need to paint at this moment.
    // At most, we paint 3 items to the right of the active item.
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // Generate transforms for the visible items and sort by distance.
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}

@immutable
class FilterItem extends StatelessWidget {
  FilterItem({
    @required this.imageurl,
    this.onFilterSelected,
  });

  final String imageurl;
  final VoidCallback onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.asset(
              imageurl,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
