import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawable_mipmap/flutter_drawable_mipmap.dart';
import 'package:flutter_test/flutter_test.dart';

const MethodChannel _channel = MethodChannel("flutter_drawable_mipmap");

final Uint8List _transparentPng = base64Decode(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=",
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> calls = [];

  setUp(() {
    calls.clear();
    imageCache.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          final Map<Object?, Object?> args = call.arguments as Map;
          if (args["name"] == "missing") {
            throw PlatformException(code: "NOT_FOUND");
          }
          if (args["name"] == "broken") {
            throw PlatformException(code: "RENDER_FAILED");
          }
          return _transparentPng;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  group("FlutterDrawableMipmap", () {
    test("sends type, name, size, scale and brightness", () async {
      final Uint8List? bytes = await FlutterDrawableMipmap.drawable(
        "logo",
        width: 24,
        scale: 3,
        brightness: Brightness.dark,
      );

      expect(bytes, _transparentPng);
      expect(calls.single.method, "load");
      expect(calls.single.arguments, {
        "type": "drawable",
        "name": "logo",
        "width": 24.0,
        "height": null,
        "scale": 3.0,
        "dark": true,
      });
    });

    test("omits brightness when not set", () async {
      await FlutterDrawableMipmap.appIcon(scale: 2);

      final Map<Object?, Object?> args = calls.single.arguments as Map;
      expect(args["type"], "appIcon");
      expect(args.containsKey("dark"), isFalse);
    });

    test("returns null when the image is missing", () async {
      expect(await FlutterDrawableMipmap.mipmap("missing"), isNull);
    });

    test("rethrows other platform errors", () {
      expect(
        FlutterDrawableMipmap.system("broken"),
        throwsA(isA<PlatformException>()),
      );
    });

    test("deprecated drawableMipmap maps to the new API", () async {
      // ignore: deprecated_member_use_from_same_package
      await FlutterDrawableMipmap.drawableMipmap("logo", false);

      expect((calls.single.arguments as Map)["type"], "mipmap");
    });
  });

  group("NativeImageProvider", () {
    test("equal providers share a cache key", () {
      expect(
        const NativeImageProvider.drawable("logo", width: 10),
        const NativeImageProvider(NativeImageType.drawable, "logo", width: 10),
      );
      expect(
        const NativeImageProvider.drawable("logo"),
        isNot(const NativeImageProvider.mipmap("logo")),
      );
    });
  });

  group("NativeImage", () {
    testWidgets("renders and passes theme brightness", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: const Drawable("logo", width: 20, height: 20),
        ),
      );
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
      expect((calls.single.arguments as Map)["dark"], isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets("shows errorBuilder when missing", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Mipmap(
            "missing",
            errorBuilder: (context, error, stack) => const Text("missing"),
          ),
        ),
      );
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(find.text("missing"), findsOneWidget);
    });

    testWidgets("shows placeholder while loading", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NativeImage.system("star", placeholder: Text("loading")),
        ),
      );

      expect(find.text("loading"), findsOneWidget);
    });
  });
}
