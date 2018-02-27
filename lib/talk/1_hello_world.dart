import 'package:flutter/material.dart';

class HelloWorldMinimalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Text('Hello World', textDirection: TextDirection.ltr),
    );
  }
}

class HelloWorldArabicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const Text('برنامج أهلا بالعالم', textDirection: TextDirection.rtl),
    );
  }
}

class HelloWorldDirectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: const Center(
        child: const Text('Hello World',),
      )
    );
  }
}

class HelloWorldRoutingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WidgetsApp(
      color: Colors.white,
      onGenerateRoute: (_) => new PageRouteBuilder(
        pageBuilder: (context, anim, secondAnim) => 
          const Center(child: const Text('Hello world'))
      )      
    );
  }
}

class HelloWorldMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: const Center(
        child: const Text('Hello World'),
      ),
    );
  }
}

class HelloWorldScaffoldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hello World',
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Hello World'),
        ),
        body: const Center(
          child: const Text('Hello World'),
        ),
      ),
    );
  }
}
