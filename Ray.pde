class Ray {
  PVector startPoint;
  PVector endPoint;
  float startAngle;
  float angle;
  int frameOffset;
  int timeSpan;
  int index;
  float sweep;
  float travel;
  PVector pt0, pt1;
  float r0, r1;
  PShape circo;

  Ray(PVector _pt0, PVector _pt1, int _index) {
    index = _index;
    startPoint = _pt0;
    endPoint = _pt1;
    startAngle = random(TWO_PI);
    angle = startAngle;
    timeSpan = fps * animationDuration;
    frameOffset = floor(random(timeSpan));
    sweep = 0.5 * random(radians(6), radians(24));
    travel = 0.5 * random(radians(12), radians(135));
    float r = dims.x;
    pt0 = new PVector(r * cos(-sweep), r * sin(-sweep));
    pt1 = new PVector(r * cos(sweep), r * sin(sweep));
    r0 = sqrt(pt0.x * pt0.x + pt0.y * pt0.y);
    r1 = sqrt(pt1.x * pt1.x + pt1.y * pt1.y);
    circo = createShape(ELLIPSE, dims.x / 2, dims.y / 2, diam1, diam1);
  }

  void update(int frameNum) {
    int currentFrame = frameNum + frameOffset;
    float amt = currentFrame % timeSpan / (float) timeSpan;
    angle = startAngle + travel * cos(amt * TWO_PI);
  }

  PShape getGeom() {
    PShape temp = createShape();
    temp.beginShape();
    float xa = r0 * cos(angle);
    float ya = r0 * sin(angle);
    float xb = r1 * cos(angle);
    float yb = r1 * sin(angle);
    temp.vertex(dims.x / 2, dims.y / 2);
    temp.vertex(dims.x / 2 + xa, dims.y / 2 + ya);
    temp.vertex(dims.x / 2 + xb, dims.y / 2 + yb);
    temp.endShape(CLOSE);

    return temp;
  }
}
