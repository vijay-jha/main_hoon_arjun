// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;

import '../helpers/mahabharat_characters.dart';
import './animated_dialog_box.dart';

class DisplayAvatar extends StatefulWidget {
  static const routeName = '/display-avatar-screen';

  @override
  _DisplayAvatarState createState() => _DisplayAvatarState();
}

class _DisplayAvatarState extends State<DisplayAvatar> {
  String _AvatarImageUrl =
      'https://cdni.iconscout.com/illustration/premium/thumb/arjun-standing-in-welcome-pose-3247069-2706135.png';

  int choosenAvatarIndex = 0;

  void _selectAvatar(String updatedImageUrl, int index) {
    setState(() {
      _AvatarImageUrl = updatedImageUrl;
      choosenAvatarIndex = index;
    });
  }

  void _onTapOnAvatar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            Avatar(onSelectAvatar: _selectAvatar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Avatar"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            MahabharatCharacters.getCharacterName(choosenAvatarIndex),
            style: TextStyle(
              color: Colors.orange,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 500,
              child: Image.network(
                _AvatarImageUrl,
                fit: BoxFit.none,
              ),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.orange),
            ),
            onPressed: _onTapOnAvatar,
            child: Text(
              "Change Your Avatar",
              style: TextStyle(fontSize: 20),
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
  const Avatar({Key key, @required this.onSelectAvatar}) : super(key: key);
  final Function(String, int) onSelectAvatar;
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  // final mahabharatAvatars = MahabharatCharacters();
  final _mahabharatCharacters = [
    {
      'name': 'Arjun',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/arjun-standing-in-welcome-pose-3247069-2706135.png',
    },
    {
      'name': 'Draupadi',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/draupadi-holding-worship-plate-3220909-2703406.png',
    },
    {
      'name': 'Bhishma',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/bhishma-pitamaha-3247112-2706051.png',
    },
    {
      'name': 'Dhritarashtra',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/king-dhritarashtra-3247180-2706118.png',
    },
    {
      'name': 'Karan',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/karna-removing-his-crown-3220949-2694481.png',
    },
    {
      'name': 'Duryodhan',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/angry-duryodhana-3220998-2694531.png',
    },
    {
      'name': 'Bheem',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/bheem-standing-in-welcome-pose-3247133-2706072.png',
    },
    {
      'name': 'Dronacharya',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/dronacharya-standing-in-namaste-pose-3220920-2703417.png',
    },
    {
      'name': 'Shakuni',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/shakuni-standing-in-welcome-pose-3260304-2726033.png',
    },
  ];

  final _filterCharacters = ValueNotifier<String>(
    MahabharatCharacters.getCharacterImageLink(0),
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
              margin: EdgeInsets.symmetric(vertical: 25),
              child: Text(
                MahabharatCharacters.getCharacterName(currentPageIndex),
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 50,
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
        return Image.network(
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
      filters: _mahabharatCharacters,
    );
  }
}

@immutable
class FilterSelector extends StatefulWidget {
  const FilterSelector({
    Key key,
    @required this.filters,
    @required this.onFilterChanged,
    @required this.onSelectAvatar,
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
  }) : super(key: key);

  final List<Map<String, String>> filters;
  final void Function(String link, int index) onFilterChanged;
  final Function(String, int) onSelectAvatar;
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
    await AnimatedDialogBox.showScaleAlertBox(
        title: const Center(child: Text("Avatar")), // IF YOU WANT TO ADD
        context: context,
        firstButton: MaterialButton(
          // FIRST BUTTON IS REQUIRED
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: const Text('Ok'),
          onPressed: () {
            widget.onSelectAvatar(
              MahabharatCharacters.getCharacterImageLink(currentIndexForSelect),
              currentIndexForSelect,
            );
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        secondButton: MaterialButton(
          // OPTIONAL BUTTON
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
            // Navigator.of(context).pop();
          },
        ),
        icon: const Icon(
          Icons.info_outline,
          color: Colors.red,
        ), // IF YOU WANT TO ADD ICON
        yourWidget: Text('Are you Sure you want to Change Avatar'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Image.network(
              imageurl,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
