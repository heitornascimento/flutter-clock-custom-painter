import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Clock(),
    );
  }
}

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.blue.shade900,
        child: _ClockView(),
      ),
    );
  }
}

class _ClockView extends StatefulWidget {
  const _ClockView({super.key});

  @override
  State<_ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<_ClockView> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(painter: _ClockPainter()),
          ),
        ),
        SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(painter: _ClockHoursView()),
        ),
      ],
    );
  }
}

class _ClockHoursView extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var radius = min(centerX, centerY);
    var outerCircleRadius = radius - 10;

    for (double i = 0; i < 360; i += 30) {
      var x1 = centerX + outerCircleRadius * cos((i * pi / 180) - pi / 2);
      var y1 = centerY + outerCircleRadius * sin((i * pi / 180) - pi / 2);

      ParagraphBuilder paragraph = ParagraphBuilder(
        ParagraphStyle(fontSize: 18),
      );
      paragraph.addText("${(i / 30).toInt()}");

      var dashBrush =
          Paint()
            ..color = Color(0xFFEAECFF)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 2;

      canvas.drawParagraph(
        paragraph.build()..layout(ParagraphConstraints(width: size.width)),
        Offset(x1 - 8, y1 - 12),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var dateTime = DateTime.now();

    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = Colors.blue.shade800;

    var centerFillBrush = Paint()..color = Colors.white;

    var secHandBrush =
        Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8;

    var minHandBrush =
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.yellow, Colors.black],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 16;

    var hourHandBrush =
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.purple, Colors.black],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 16;

    canvas.drawCircle(center, radius - 40, fillBrush);
    var outlineBrush =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 16;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 40),
      0,
      dateTime.second * 6 * pi / 180,
      false,
      outlineBrush,
    );

    ///Hours
    var hourHandX =
        centerX +
        60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY =
        centerY +
        60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    ///Minutes
    var minHandX = centerX + 80 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerY + 80 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    ///Seconds
    var secHandX = centerX + 80 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + 80 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, 16, centerFillBrush);

    var dashBrush =
        Paint()
          ..color = Color(0xFFEAECFF)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
