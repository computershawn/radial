PShape circo(float xpos, float ypos, float diam, boolean close) {
  int n = 24;
  PShape temp = createShape();
  temp.beginShape();
  temp.noFill();

  for (int i = 0; i < n; i++) {
    float ang = TWO_PI * i / n;
    float x = xpos + 0.5 * diam * cos(ang);
    float y = ypos + 0.5 * diam * sin(ang);
    temp.vertex(x, y);
  }
  if (close) {

    temp.endShape(CLOSE);
  } else {
    temp.endShape();
  }

  return temp;
}

PShape arcy(float xpos, float ypos, float diam, float angle0, float angle1) {
  int n = 12;
  PShape temp = createShape();
  temp.beginShape();
  temp.noFill();

  for (int i = 0; i <= n; i++) {
    float ang = angle0 + (float) i / n * (angle1 - angle0);
    float x = xpos + 0.5 * diam * cos(ang);
    float y = ypos + 0.5 * diam * sin(ang);
    temp.vertex(x, y);
  }
  temp.endShape();

  return temp;
}

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

PShape getNiceLittleFrame(boolean close) {
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

  if (close) {
    f.endShape(CLOSE);
  } else {
    p = framePoints.get(0);
    f.vertex(p.x, p.y);
    f.endShape();
  }

  return f;
}

PShape getClipFrame1() {
  PShape inner = getNiceLittleFrame(true);
  PShape outer = createShape();
  int m = 20;

  outer.beginShape();
  outer.vertex(-m, -m);
  outer.vertex(dims.x + m, -m);
  outer.vertex(dims.x + m, dims.y + m);
  outer.vertex(-m, dims.y + m);
  outer.endShape(CLOSE);

  return PGS_ShapeBoolean.subtract(outer, inner);
}

PShape getClipFrame2() {
  int m = 20;
  PShape outer = createShape();

  outer.beginShape();
  outer.vertex(-m, -m);
  outer.vertex(dims.x + m, -m);
  outer.vertex(dims.x + m, dims.y + m);
  outer.vertex(-m, dims.y + m);
  outer.endShape(CLOSE);
  PShape inner = getSimpleMat(mar);

  return PGS_ShapeBoolean.subtract(outer, inner);
}

PShape getNiceLittleMat() {
  PShape f = createShape();
  PShape g = getNiceLittleFrame(true);

  f.beginShape();
  f.stroke(lineColor);
  f.vertex(0, 0);
  f.vertex(dims.x, 0);
  f.vertex(dims.x, dims.y);
  f.vertex(0, dims.y);
  f.endShape(CLOSE);

  PShape h = PGS_ShapeBoolean.subtract(f, g);

  PGS_Conversion.disableAllStroke(h);
  PGS_Conversion.disableAllFill(h);

  return h;
}

PShape getSimpleMat(int m) {
  float w = dims.x;
  float h = dims.y;

  noFill();
  stroke(lineColor);
  rect(m, m, w - 2 * m, h - 2 * m);
  PShape temp = createShape();
  temp.beginShape();
  temp.vertex(m, m);
  temp.vertex(w - m, m);
  temp.vertex(w - m, h - m);
  temp.vertex(m, h - m);
  temp.endShape(CLOSE);

  return temp;
}

void satellite() {
  noFill();
  stroke(255, 0, 0);
  float d = 0.5 * wd;
  arc(cx, cy, d, d, 0, radians(15));
}

float easeInCubic(float t) {
  return t * t * t;
}
