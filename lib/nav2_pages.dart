import 'package:flutter/material.dart';

final ValueNotifier<List<String>> pages = ValueNotifier(['/']);
const Map<String, Page> pageMap = {
  '/': MaterialPage(child: ViPage('IndexPage')),
  'foo': MaterialPage(child: ViPage('FooPage')),
  'bar': MaterialPage(child: ViPage('BarPage')),
};

class Nav2PagesHome extends StatefulWidget {
  const Nav2PagesHome({super.key});

  @override
  State<Nav2PagesHome> createState() => _Nav2PagesHomeState();
}

class _Nav2PagesHomeState extends State<Nav2PagesHome> {
  final _addressBarController = TextEditingController();

  void _pushFoo() => pages.value = ['/', 'foo'];

  void _pushBar() => pages.value = ['/', 'foo', 'bar'];

  void _updateAddressBar() =>
      _addressBarController.text = pages.value.join(',');

  ///navigate by Address bar
  void _onSubmit(String v) => pages.value = v.split(',');

  @override
  void initState() {
    super.initState();
    _updateAddressBar();
    pages.addListener(_updateAddressBar);
  }

  @override
  void dispose() {
    pages.dispose();
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
          const Expanded(
            child: Nav2Pages(),
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
        leading: BackButton(
          onPressed: () {
            pages.value = pages.value.toList()..removeLast();
          },
        ),
      ),
    );
  }
}

///
/// pages updating management by developer self
///

class Nav2Pages extends StatelessWidget {
  const Nav2Pages({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pages,
      builder: (_, v, __) {
        return Navigator(
          onPopPage: (route, result) {
            return route.didPop(result);
          },
          pages: v.map((e) => pageMap[e]!).toList(),
        );
      },
    );
  }
}
