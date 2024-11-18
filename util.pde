ArrayList<PVector> getFramePoints() {
  ArrayList<PVector> points = new ArrayList<PVector>();

  int x1 = wd / 2;
  int x2 = 72;  // control
  int x3 = 13;  // control
  int x4 = 13;

  int y1 = 11;
  int y2 = 26;  // control
  int y3 = 16;  // control
  int y4 = 49;

  int steps = 20;

  for (int i = 0; i < steps; i++) {
    float t0 = i / float(steps);
    float x0 = bezierPoint(x1, x2, x3, x4, t0);
    float y0 = bezierPoint(y1, y2, y3, y4, t0);
    points.add(new PVector(x0, y0));
  }

  return points;
}

String getTimestamp() {
  Date d = new Date();
  String ts = Long.toString(d.getTime() / 1000);

  return ts;
}

PShape niceLittleFrame() {
  PShape f = createShape();
  PVector p;

  f.beginShape();
  //f.fill(fillColor);
  f.noFill();
  f.stroke(lineColor);
  int steps = framePoints.size();

  for (int i = 0; i < steps; i++) {
    p = framePoints.get(i);
    f.vertex(p.x, p.y);
  }
  for (int i = steps - 1; i >= 0; i--) {
    p = framePoints.get(i);
    f.vertex(p.x, ht - p.y);
  }
  for (int i = 1; i < steps; i++) {
    p = framePoints.get(i);
    f.vertex(wd - p.x, ht - p.y);
  }
  for (int i = steps - 1; i > 0; i--) {
    p = framePoints.get(i);
    f.vertex(wd - p.x, p.y);
  }
  f.endShape(CLOSE);

  return f;
}

PShape niceLittleMat() {
  PShape f = createShape();
  PShape g = niceLittleFrame();

  f.beginShape();
  f.fill(#ff00ff);
  f.stroke(lineColor);
  //f.noStroke();
  f.vertex(0, 0);
  f.vertex(wd, 0);
  f.vertex(wd, ht);
  f.vertex(0, ht);
  f.endShape(CLOSE);

  PShape h = PGS_ShapeBoolean.subtract(f, g);
  PGS_Conversion.disableAllStroke(h);
  PGS_Conversion.setAllFillColor(h, fillColor);
  return h;
}

void simpleMat(int m) {
  noStroke();
  fill(fillColor);
  //fill(fillColor, 127);
  beginShape();
  vertex(0, 0);
  vertex(wd, 0);
  vertex(wd, ht);
  vertex(0, ht);
  beginContour();
  vertex(m, m);
  vertex(m, ht - m);
  vertex(wd - m, ht - m);
  vertex(wd - m, m);
  endContour();
  endShape(CLOSE);

  noFill();
  stroke(lineColor);
  rect(m, m, wd - 2 * m, ht - 2 * m);
  float n = 0.5 * m;
  rect(n, n, wd - 2 * n, ht - 2 * n);
}

PShape subtractShapes(PShape shape1, PShape shape2) {
  PShape result = PGS_ShapeBoolean.subtract(shape1, shape2);

  return result;
}

PShape intersectShapes(PShape shape1, PShape shape2) {
  //PShape ps = getCirc(x, y, r);

  PShape result = PGS_ShapeBoolean.intersect(shape1, shape2);
  //PGS_Conversion.disableAllFill(result);

  return result;
}

void satellite() {
  noFill();
  stroke(255, 0, 0);
  float d = 0.5 * wd;
  arc(cx, cy, d, d, 0, radians(15));
}
