import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier<List<String>> _pages = ValueNotifier(['/']);
  final Map<String, Page> _pageMap = const {
    '/': MaterialPage(child: IndexPage()),
    'foo': MaterialPage(child: FooPage()),
    'bar': MaterialPage(child: BarPage()),
  };
  final _addressBarController = TextEditingController();

  void _pushFoo() => _pages.value = ['/', 'foo'];

  void _pushBar() => _pages.value = ['/', 'foo', 'bar'];

  void _updateAddressBar() =>
      _addressBarController.text = _pages.value.join(',');

  ///navigate by Address bar
  void _onSubmit(String v) => _pages.value = v.split(',');

  @override
  void initState() {
    super.initState();
    _updateAddressBar();
    _pages.addListener(_updateAddressBar);
  }

  @override
  void dispose() {
    _addressBarController.dispose();
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
          Expanded(child: _buildNav2()),
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

  Widget _buildNav2() => ValueListenableBuilder(
        valueListenable: _pages,
        builder: (_, v, __) {
          return Navigator(
            onPopPage: (route, result) {
              return route.didPop(result);
            },
            pages: v.map((e) => _pageMap[e]!).toList(),
          );
        },
      );
}

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IndexPage'),
        centerTitle: true,
      ),
    );
  }
}

class FooPage extends StatelessWidget {
  const FooPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FooPage'),
        centerTitle: true,
      ),
    );
  }
}

class BarPage extends StatelessWidget {
  const BarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BarPage'),
        centerTitle: true,
      ),
    );
  }
}
