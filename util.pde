ArrayList<PVector> getFramePoints() {
  ArrayList<PVector> points = new ArrayList<PVector>();

  float x1 = dims.x / 2;
  float x2 = 72;  // control
  float x3 = 13;  // control
  float x4 = 13;

  float y1 = 11;
  float y2 = 26;  // control
  float y3 = 16;  // control
  float y4 = 49;

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
    f.vertex(p.x, dims.y - p.y);
  }
  for (int i = 1; i < steps; i++) {
    p = framePoints.get(i);
    f.vertex(dims.x - p.x, dims.y - p.y);
  }
  for (int i = steps - 1; i > 0; i--) {
    p = framePoints.get(i);
    f.vertex(dims.x - p.x, p.y);
  }
  f.endShape(CLOSE);

  return f;
}

PShape niceLittleMat() {
  PShape f = createShape();
  PShape g = niceLittleFrame();

  f.beginShape();
  //f.fill(#ff00ff);
  f.stroke(lineColor);
  //f.noStroke();
  f.vertex(0, 0);
  f.vertex(dims.x, 0);
  f.vertex(dims.x, dims.y);
  f.vertex(0, dims.y);
  f.endShape(CLOSE);

  PShape h = PGS_ShapeBoolean.subtract(f, g);
  PGS_Conversion.disableAllStroke(h);
  PGS_Conversion.setAllFillColor(h, fillColor);
  return h;
}

void simpleMat(int m) {
  float w = dims.x;
  float h = dims.y;
  noStroke();
  fill(fillColor);
  //fill(0, 127);
  beginShape();
  vertex(0, 0);
  vertex(w, 0);
  vertex(w, h);
  vertex(0, h);
  beginContour();
  vertex(m, m);
  vertex(m, h - m);
  vertex(w - m, h - m);
  vertex(w - m, m);
  endContour();
  endShape(CLOSE);

  noFill();
  stroke(lineColor);
  rect(m, m, w - 2 * m, h - 2 * m);
  float n = 0.5 * m;
  rect(n, n, w - 2 * n, h - 2 * n);
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
