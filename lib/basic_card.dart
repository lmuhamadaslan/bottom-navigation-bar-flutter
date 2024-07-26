import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HideNavigationBar extends StatefulWidget {
  const HideNavigationBar({Key? key}) : super(key: key);

  @override
  _HideNavigationBarState createState() => _HideNavigationBarState();
}

class _HideNavigationBarState extends State<HideNavigationBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController animationController;
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _pages = <Widget>[
      CallsPage(isHideBottomNavBar: (isHideBottomNavBar) {
        isHideBottomNavBar
            ? animationController.forward()
            : animationController.reverse();
      }),
      const Center(
        child: Icon(
          Icons.camera,
          size: 150,
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
              labelText: 'Find Contact',
              labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        ),
      )
    ];
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('With TabBar Demo'),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizeTransition(
        sizeFactor: animationController,
        axisAlignment: -0.1,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
            BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Camera'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class CallsPage extends StatelessWidget {
  CallsPage({required this.isHideBottomNavBar});
  final Function(bool) isHideBottomNavBar;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Incoming',
                  ),
                  Tab(
                    text: 'Outgoing',
                  ),
                  Tab(
                    text: 'Missed',
                  )
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IncomingPage(),
            OutgoingPage(isHideBottomNavBar: (value) {
              isHideBottomNavBar(value);
            }),
            // const Icon(Icons.call_missed_outgoing, size: 350)
            MissedPage()
          ],
        ),
      ),
    );
  }
}

class IncomingPage extends StatefulWidget {
  @override
  _IncomingPageState createState() => _IncomingPageState();
}

class _IncomingPageState extends State<IncomingPage> {
  final List<Card> cards = List.generate(
      100,
      (index) => Card(
          margin: const EdgeInsets.only(top: 8),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(3),
            width: 300,
            height: 150,
            child: ListTile(
              title: Text('Incoming Call $index'),
              subtitle: Text('Time: ${DateTime.now()}'),
              leading: const Icon(Icons.call_received),
            ),
          )));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: cards,
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: cards,
            ),
          )
        ],
      ),
    );
  }
}

class OutgoingPage extends StatefulWidget {
  final Function(bool) isHideBottomNavBar;

  OutgoingPage({required this.isHideBottomNavBar});

  @override
  _OutgoingPageState createState() => _OutgoingPageState();
}

class _OutgoingPageState extends State<OutgoingPage>
    with AutomaticKeepAliveClientMixin<OutgoingPage> {
  final items = List<String>.generate(1000, (index) => 'Call $index');

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            widget.isHideBottomNavBar(true);
            break;
          case ScrollDirection.reverse:
            widget.isHideBottomNavBar(false);
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        body: Center(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${items[index]}'),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MissedPage extends StatefulWidget {
  @override
  _MissedPageState createState() => _MissedPageState();
}

class _MissedPageState extends State<MissedPage> {
  // create a list of cards
  final List<Card> cards = List.generate(
      100,
      (index) => Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
              title: Text('Missed Call $index'),
              subtitle: Text('Time: ${DateTime.now()}'),
              leading: const Icon(Icons.call_missed),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cards,
    );
  }
}
