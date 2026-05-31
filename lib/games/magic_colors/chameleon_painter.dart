import 'dart:math';
import 'package:flutter/material.dart';

class ChameleonFly {
  final Key key = UniqueKey();
  Offset position;
  final Color color;
  final String colorName;
  double angle = 0.0;
  double wingState = 0.0;
  final double speed;
  final double scale;

  ChameleonFly({
    required this.position,
    required this.color,
    required this.colorName,
    required this.speed,
    this.scale = 1.0,
  });

  void update(double dt, double time, double width, double height) {
    // Sinüs dalgalı rastgele uçuş hareketi
    angle += (Random().nextDouble() - 0.5) * 2.0 * dt;
    position = Offset(
      position.dx + cos(angle) * speed * dt,
      position.dy + sin(angle) * speed * dt + sin(time * 5.0) * 0.8,
    );

    // Ekrandan çıkarsa sınırlarda tut veya geri döndür
    if (position.dx < 50) {
      position = Offset(50, position.dy);
      angle = 0;
    } else if (position.dx > width - 50) {
      position = Offset(width - 50, position.dy);
      angle = pi;
    }
    if (position.dy < 80) {
      position = Offset(position.dx, 80);
      angle = pi / 2;
    } else if (position.dy > height - 120) {
      position = Offset(position.dx, height - 120);
      angle = -pi / 2;
    }

    wingState = sin(time * 30.0);
  }
}

class ChameleonPainter extends CustomPainter {
  final Color chameleonColor;
  final double tongueProgress; // 0.0 (mouth) to 1.0 (target)
  final Offset? tongueTarget;
  final Offset lookTarget;
  final List<ChameleonFly> flies;
  final double idleProgress;
  final bool isCamouflaged;
  final Offset chameleonPos;

  ChameleonPainter({
    required this.chameleonColor,
    required this.tongueProgress,
    this.tongueTarget,
    required this.lookTarget,
    required this.flies,
    required this.idleProgress,
    required this.isCamouflaged,
    required this.chameleonPos,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Kamo'nun tünediği dalı çiz
    _drawBranch(canvas, chameleonPos);

    // 2. Kamo'nun gövdesini çiz
    _drawChameleon(canvas, chameleonPos);

    // 3. Sinekleri çiz
    _drawFlies(canvas);

    // 4. Eğer dil fırlatılıyorsa dili çiz
    if (tongueProgress > 0.0 && tongueTarget != null) {
      _drawTongue(canvas, chameleonPos, tongueTarget!, tongueProgress);
    }
  }

  void _drawBranch(Canvas canvas, Offset pos) {
    final branchPaint = Paint()
      ..color = const Color(0xFF8B5A2B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.0
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    // Dalı çiz
    canvas.drawLine(
      Offset(pos.dx - 180, pos.dy + 85),
      Offset(pos.dx + 160, pos.dy + 85),
      branchPaint,
    );

    // Küçük yapraklar ekle
    final leafPath1 = Path();
    leafPath1.moveTo(pos.dx - 120, pos.dy + 80);
    leafPath1.quadraticBezierTo(pos.dx - 140, pos.dy + 60, pos.dx - 160, pos.dy + 80);
    leafPath1.quadraticBezierTo(pos.dx - 140, pos.dy + 100, pos.dx - 120, pos.dy + 80);
    canvas.drawPath(leafPath1, leafPaint);

    final leafPath2 = Path();
    leafPath2.moveTo(pos.dx + 100, pos.dy + 80);
    leafPath2.quadraticBezierTo(pos.dx + 120, pos.dy + 55, pos.dx + 140, pos.dy + 80);
    leafPath2.quadraticBezierTo(pos.dx + 120, pos.dy + 95, pos.dx + 100, pos.dy + 80);
    canvas.drawPath(leafPath2, leafPaint);
  }

  void _drawChameleon(Canvas canvas, Offset pos) {
    // Kamuflaj durumunda saydamlık ekle
    final double opacity = isCamouflaged ? 0.35 : 1.0;
    final color = chameleonColor.withOpacity(opacity);

    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final detailPaint = Paint()
      ..color = Colors.black.withOpacity(0.15 * opacity)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.black.withOpacity(0.2 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Nefes alma (idle) hareketi için hafif genleşme
    final double breath = sin(idleProgress * 2.0 * pi) * 2.5;

    // 1. Kıvrık Kuyruk (Spiral)
    final tailPath = Path();
    tailPath.moveTo(pos.dx - 60, pos.dy + 20);
    // Kuyruk kıvrım çizgisi
    tailPath.cubicTo(
      pos.dx - 110, pos.dy + 40,
      pos.dx - 110, pos.dy + 100,
      pos.dx - 70, pos.dy + 100,
    );
    tailPath.cubicTo(
      pos.dx - 40, pos.dy + 100,
      pos.dx - 40, pos.dy + 60,
      pos.dx - 70, pos.dy + 60,
    );
    tailPath.cubicTo(
      pos.dx - 85, pos.dy + 60,
      pos.dx - 85, pos.dy + 80,
      pos.dx - 70, pos.dy + 80,
    );

    final tailPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0 + breath * 0.2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(tailPath, tailPaint);
    canvas.drawPath(tailPath, Paint()
      ..color = Colors.black.withOpacity(0.15 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0 + breath * 0.2
      ..strokeCap = StrokeCap.round);
    canvas.drawPath(tailPath, tailPaint); // Tekrar çiz ki detay arkada kalsın

    // 2. Ayaklar (Küçük bacaklar ve pençeler)
    final legPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // Ön bacak
    canvas.drawCircle(Offset(pos.dx + 25, pos.dy + 60), 12, legPaint);
    canvas.drawCircle(Offset(pos.dx + 20, pos.dy + 78), 8, legPaint);
    // Arka bacak
    canvas.drawCircle(Offset(pos.dx - 25, pos.dy + 60), 12, legPaint);
    canvas.drawCircle(Offset(pos.dx - 30, pos.dy + 78), 8, legPaint);

    // 3. Tombul Gövde
    final rect = Rect.fromCenter(
      center: Offset(pos.dx, pos.dy + 10),
      width: 120 + breath,
      height: 90 + breath,
    );
    canvas.drawOval(rect, bodyPaint);
    canvas.drawOval(rect, strokePaint);

    // Gövdedeki sevimli benekler/desenler
    final stripePath = Path();
    stripePath.addOval(Rect.fromCenter(center: Offset(pos.dx - 20, pos.dy - 10), width: 14, height: 28));
    stripePath.addOval(Rect.fromCenter(center: Offset(pos.dx, pos.dy - 15), width: 16, height: 32));
    stripePath.addOval(Rect.fromCenter(center: Offset(pos.dx + 20, pos.dy - 10), width: 14, height: 28));
    canvas.drawPath(stripePath, detailPaint);

    // Sırtındaki sevimli küçük üçgen dikenler
    final spinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      final double sx = pos.dx - 50 + i * 22;
      final double sy = pos.dy - 35 - (i == 2 ? 5 : 0) + breath * 0.5;
      final spinePath = Path();
      spinePath.moveTo(sx - 8, sy);
      spinePath.lineTo(sx, sy - 10);
      spinePath.lineTo(sx + 8, sy);
      spinePath.close();
      canvas.drawPath(spinePath, spinePaint);
      canvas.drawPath(spinePath, strokePaint);
    }

    // 4. Kafa
    final headPath = Path();
    headPath.moveTo(pos.dx + 40, pos.dy - 20);
    // Çene
    headPath.quadraticBezierTo(pos.dx + 95, pos.dy + 25, pos.dx + 45, pos.dy + 35);
    headPath.lineTo(pos.dx + 30, pos.dy + 30);
    // Ense / Miğfer
    headPath.quadraticBezierTo(pos.dx + 20, pos.dy - 40, pos.dx + 55, pos.dy - 45);
    headPath.quadraticBezierTo(pos.dx + 75, pos.dy - 40, pos.dx + 70, pos.dy - 20);
    headPath.close();
    canvas.drawPath(headPath, bodyPaint);
    canvas.drawPath(headPath, strokePaint);

    // Ağız çizgisi
    final mouthPath = Path();
    mouthPath.moveTo(pos.dx + 70, pos.dy + 22);
    mouthPath.quadraticBezierTo(pos.dx + 82, pos.dy + 20, pos.dx + 90, pos.dy + 15);
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = Colors.black.withOpacity(0.3 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round,
    );

    // Sevimli Yanak Pembesi (Eğer kamufle değilse)
    if (!isCamouflaged) {
      canvas.drawCircle(
        Offset(pos.dx + 58, pos.dy + 22),
        7,
        Paint()
          ..color = const Color(0xFFFF8AAE).withOpacity(0.6)
          ..style = PaintingStyle.fill,
      );
    }

    // 5. Göz Tasarımı (Büyük Dış Daire ve Bağımsız Pupil)
    final double eyeX = pos.dx + 52;
    final double eyeY = pos.dy - 8;

    // Göz kapağı (chameleonColor)
    canvas.drawCircle(Offset(eyeX, eyeY), 18, bodyPaint);
    canvas.drawCircle(Offset(eyeX, eyeY), 18, strokePaint);

    // Göz akı
    canvas.drawCircle(
      Offset(eyeX, eyeY),
      12,
      Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill,
    );

    // Göz bebeği (Pupil) - lookTarget yönüne bakar
    final double dx = lookTarget.dx - eyeX;
    final double dy = lookTarget.dy - eyeY;
    final double dist = sqrt(dx * dx + dy * dy);

    // Göz bebeği göz akının dışına çıkmasın (maksimum 6 piksel kayabilir)
    final double maxMove = 5.0;
    final double moveX = dist > 0 ? (dx / dist) * min(dist, maxMove) : 0.0;
    final double moveY = dist > 0 ? (dy / dist) * min(dist, maxMove) : 0.0;

    canvas.drawCircle(
      Offset(eyeX + moveX, eyeY + moveY),
      5,
      Paint()
        ..color = const Color(0xFF233238).withOpacity(opacity)
        ..style = PaintingStyle.fill,
    );

    // Göz bebeği içi parıltı
    canvas.drawCircle(
      Offset(eyeX + moveX - 1.5, eyeY + moveY - 1.5),
      1.5,
      Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawFlies(Canvas canvas) {
    for (var fly in flies) {
      final double fOpacity = isCamouflaged ? 0.3 : 1.0;
      final bodyPaint = Paint()
        ..color = fly.color.withOpacity(fOpacity)
        ..style = PaintingStyle.fill;

      final wingPaint = Paint()
        ..color = Colors.white.withOpacity(0.7 * fOpacity)
        ..style = PaintingStyle.fill;

      final strokePaint = Paint()
        ..color = Colors.black.withOpacity(0.3 * fOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.save();
      canvas.translate(fly.position.dx, fly.position.dy);
      // Sinek boyutu ölçekleme
      canvas.scale(fly.scale);

      // 1. İnce bacaklar
      final legPaint = Paint()
        ..color = Colors.black.withOpacity(0.4 * fOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawLine(const Offset(-4, 4), const Offset(-8, 8), legPaint);
      canvas.drawLine(const Offset(4, 4), const Offset(8, 8), legPaint);
      canvas.drawLine(const Offset(-4, 0), const Offset(-9, 2), legPaint);
      canvas.drawLine(const Offset(4, 0), const Offset(9, 2), legPaint);

      // 2. Sinek Gövdesi (Tombul oval)
      canvas.drawOval(const Rect.fromLTWH(-10, -8, 20, 16), bodyPaint);
      canvas.drawOval(const Rect.fromLTWH(-10, -8, 20, 16), strokePaint);

      // Siyah sevimli gözler
      canvas.drawCircle(const Offset(8, -3), 2.5, Paint()..color = Colors.black.withOpacity(fOpacity));
      canvas.drawCircle(const Offset(8, 3), 2.5, Paint()..color = Colors.black.withOpacity(fOpacity));

      // 3. Kanatlar (Uçma animasyonu wingState'e göre döner)
      canvas.save();
      canvas.translate(-2, -6);
      canvas.rotate(-0.4 + fly.wingState * 0.3);
      canvas.drawOval(const Rect.fromLTWH(-16, -6, 18, 10), wingPaint);
      canvas.drawOval(const Rect.fromLTWH(-16, -6, 18, 10), strokePaint);
      canvas.restore();

      canvas.save();
      canvas.translate(-2, 6);
      canvas.rotate(0.4 - fly.wingState * 0.3);
      canvas.drawOval(const Rect.fromLTWH(-16, -4, 18, 10), wingPaint);
      canvas.drawOval(const Rect.fromLTWH(-16, -4, 18, 10), strokePaint);
      canvas.restore();

      canvas.restore();
    }
  }

  void _drawTongue(Canvas canvas, Offset startPos, Offset targetPos, double progress) {
    // Dilin ağızdan çıkış noktası (Kamo'nun ağzı)
    final Offset mouthPos = Offset(startPos.dx + 82, startPos.dy + 20);

    // Mevcut dil ucu pozisyonu
    final double tx = mouthPos.dx + (targetPos.dx - mouthPos.dx) * progress;
    final double ty = mouthPos.dy + (targetPos.dy - mouthPos.dy) * progress;
    final Offset currentTip = Offset(tx, ty);

    // Dil hattını çiz (Pembe elastik ip)
    final tonguePaint = Paint()
      ..color = const Color(0xFFFF5E7E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(mouthPos, currentTip, tonguePaint);

    // Dil ucundaki yapışkan yuvarlak (Tip)
    final tipPaint = Paint()
      ..color = const Color(0xFFFF2E63)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(currentTip, 10.0, tipPaint);
    canvas.drawCircle(currentTip, 10.0, Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0);
  }

  @override
  bool shouldRepaint(covariant ChameleonPainter oldDelegate) {
    return oldDelegate.chameleonColor != chameleonColor ||
        oldDelegate.tongueProgress != tongueProgress ||
        oldDelegate.tongueTarget != tongueTarget ||
        oldDelegate.lookTarget != lookTarget ||
        oldDelegate.flies != flies ||
        oldDelegate.idleProgress != idleProgress ||
        oldDelegate.isCamouflaged != isCamouflaged ||
        oldDelegate.chameleonPos != chameleonPos;
  }
}
