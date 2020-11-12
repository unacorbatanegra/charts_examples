import 'package:graphx/graphx.dart';

class BezierControlPoint {
  GxPoint prev;
  GxPoint next;

  BezierControlPoint([this.prev, this.next]) {
    prev ??= GxPoint();
    next ??= GxPoint();
  }
}

double _dist(double x, double y) => sqrt(x * x + y * y);

bezierCurveThrough(Graphics g, List<GxPoint> points, [double tension = .25]) {
  tension ??= .25;
  var len = points.length;
  if (len == 2) {
    g.moveTo(points[0].x, points[0].y);
    g.lineTo(points[1].x, points[1].y);
    return;
  }

  final cpoints = <BezierControlPoint>[];
  points.forEach((e) {
    cpoints.add(BezierControlPoint());
  });

  for (var i = 1; i < len - 1; ++i) {
    final pi = points[i];
    final pp = points[i - 1];
    final pn = points[i + 1];
    var rdx = pn.x - pp.x;
    var rdy = pn.y - pp.y;
    var rd = _dist(rdx, rdy);
    var dx = rdx / rd;
    var dy = rdy / rd;

    var dp = _dist(pi.x - pp.x, pi.y - pp.y);
    var dn = _dist(pi.x - pn.x, pi.y - pn.y);

    var cpx = pi.x - dx * dp * tension;
    var cpy = pi.y - dy * dp * tension;
    var cnx = pi.x + dx * dn * tension;
    var cny = pi.y + dy * dn * tension;

    cpoints[i].prev.setTo(cpx, cpy);
    cpoints[i].next.setTo(cnx, cny);
  }

  /// end points
  cpoints[0].next = GxPoint(
    (points[0].x + cpoints[1].prev.x) / 2,
    (points[0].y + cpoints[1].prev.y) / 2,
  );

  cpoints[len - 1].prev = GxPoint(
    (points[len - 1].x + cpoints[len - 2].next.x) / 2,
    (points[len - 1].y + cpoints[len - 2].next.y) / 2,
  );

  /// draw?
  g.moveTo(points[0].x, points[0].y);
  for (var i = 1; i < len; ++i) {
    var p = points[i];
    var cp = cpoints[i];
    var cpp = cpoints[i - 1];
    g.cubicCurveTo(cpp.next.x, cpp.next.y, cp.prev.x, cp.prev.y, p.x, p.y);
  }
}