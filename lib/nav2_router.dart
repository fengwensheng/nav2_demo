import 'package:flutter/material.dart';

final ValueNotifier<List<String>> pages = ValueNotifier(['/']);
const Map<String, Page> pageMap = {
  '/': MaterialPage(child: ViPage('IndexPage')),
  'foo': MaterialPage(child: ViPage('FooPage')),
  'bar': MaterialPage(child: ViPage('BarPage')),
};

class Nav2RouterHome extends StatefulWidget {
  const Nav2RouterHome({super.key});

  @override
  State<Nav2RouterHome> createState() => _Nav2RouterHomeState();
}

class _Nav2RouterHomeState extends State<Nav2RouterHome> {
  final _addressBarController = TextEditingController();

  void _pushFoo() => viRouterDelegate.value = ['/', 'foo'];

  void _pushBar() => viRouterDelegate.value = ['/', 'foo', 'bar'];

  void _updateAddressBar() =>
      _addressBarController.text = viRouterDelegate.value.join(',');

  ///navigate by Address bar
  void _onSubmit(String v) => viRouterDelegate.value = v.split(',');

  @override
  void initState() {
    super.initState();
    _updateAddressBar();
    viRouterDelegate.addListener(_updateAddressBar);
  }

  @override
  void dispose() {
    viRouterDelegate.dispose();
    _addressBarController.dispose();
    pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody()),
      persistentFooterButtons: _buildFoots(),
    );
  }

  List<Widget> _buildFoots() => [
        ElevatedButton(onPressed: _pushFoo, child: const Text('Push Foo')),
        ElevatedButton(onPressed: _pushBar, child: const Text('Push Bar')),
      ];

  Widget _buildBody() => Column(
        children: [
          _buildInput(),
          const Expanded(
            child: Nav2Router(),
          ),
        ],
      );

  Widget _buildInput() => Container(
        height: 44,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _addressBarController,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onSubmitted: (v) => _onSubmit(v),
        ),
      );
}

class ViPage extends StatelessWidget {
  final String name;
  const ViPage(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
    );
  }
}

///
/// pages updating management by framework design
///
/// the _RouterState listening the RouterDelegate,
/// it will setState once delegate changed, it triggers _RouterState#build()
/// then routerDelegate.build()
/// it will rebuild one another new Navigator with updated PAGES.
///

class Nav2Router extends StatelessWidget {
  const Nav2Router({super.key});

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: viRouterDelegate,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

final ViRouterDelegate viRouterDelegate = ViRouterDelegate();

class ViRouterDelegate extends RouterDelegate with ChangeNotifier {
  List<String> _value = ['/'];
  List<String> get value => _value;
  set value(List<String> value) {
    _value = value;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) {
        debugPrint('NavigatorState#pop()');
        value = value.toList()..removeLast();
        return route.didPop(result);
      },
      pages: value.map((e) => pageMap[e]!).toList(),
    );
  }

  int? time;

  @override
  Future<bool> popRoute() async {
    debugPrint('System pop!');
    if (viRouterDelegate.value.join('') == '/') {
      debugPrint("Here's Root!");
      time ??= DateTime.now().millisecondsSinceEpoch;
      final timeDiff = DateTime.now().millisecondsSinceEpoch - time!;
      if (timeDiff < 2000 && timeDiff > 50) {
        debugPrint('[escape]:diff=$timeDiff');
        return false;
      }
      time = DateTime.now().millisecondsSinceEpoch;
      debugPrint('[capture]:diff=$timeDiff');
      return true;
    }
    viRouterDelegate.value = viRouterDelegate.value.toList()..removeLast();
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}
}
