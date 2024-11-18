class Ray {
  PVector startPoint;
  PVector endPoint;
  float startAngle;
  float angle;
  int currentFrame;
  int timeSpan;
  int index;
  float sweep;
  float travel;
  PVector pt0, pt1;
  float r0, r1;
  //color co;
  PShape circo;

  Ray(PVector _pt0, PVector _pt1, int _index) {
    index = _index;
    startPoint = _pt0;
    endPoint = _pt1;
    startAngle = random(TWO_PI);
    angle = startAngle;
    timeSpan = fps * animationDuration;
    currentFrame = floor(random(timeSpan));
    sweep = 0.5 * random(radians(6), radians(24));
    travel = 0.5 * random(radians(12), radians(135));
    int r = wd;
    pt0 = new PVector(r * cos(-sweep), r * sin(-sweep));
    pt1 = new PVector(r * cos(sweep), r * sin(sweep));
    r0 = sqrt(pt0.x * pt0.x + pt0.y * pt0.y);
    r1 = sqrt(pt1.x * pt1.x + pt1.y * pt1.y);
    //co = random(1) > 0.7 ? color(random(24, 143)) : 255;
    circo = createShape(ELLIPSE, cx, cy, diam1, diam1);
  }

  void update() {
    float amt = currentFrame % timeSpan / (float) timeSpan;
    // float t = amt; // linear
    // float t = amt == 0 ? 0 : pow(2, 10 * amt - 10); // exponential;
    //float t = amt * amt * amt; // cubic
    //position.x = wd / 2 + t * (diag + diameter / 2) * cos(angle);
    //position.y = ht / 2 + t * (diag + diameter / 2) * sin(angle);
    angle = startAngle + travel * cos(amt * TWO_PI);
    currentFrame += 1;
  }

  //void render() {
  //  PShape temp = createShape();
  //  temp.beginShape();
  //  float xa = r0 * cos(angle);
  //  float ya = r0 * sin(angle);
  //  float xb = r1 * cos(angle);
  //  float yb = r1 * sin(angle);
  //  temp.vertex(cx, cy);
  //  temp.vertex(cx + xa, cy + ya);
  //  temp.vertex(cx + xb, cy + yb);
  //  temp.endShape(CLOSE);
  //  PShape ray = intersectShapes(temp, frame);
  //  PGS_Conversion.setAllStrokeColor(ray, lineColor, 1);
  //  shape(ray);
  //}
  void render() {
    PShape temp = createShape();
    temp.beginShape();
    float xa = r0 * cos(angle);
    float ya = r0 * sin(angle);
    float xb = r1 * cos(angle);
    float yb = r1 * sin(angle);
    temp.vertex(cx, cy);
    temp.vertex(cx + xa, cy + ya);
    temp.vertex(cx + xb, cy + yb);
    temp.endShape(CLOSE);
    
    // Intersect initial shape with frame
    PShape ray = intersectShapes(temp, frame);
  
    // Intersect resulting shape with center sun
    ray = subtractShapes(ray, circo);
  
    PGS_Conversion.setAllStrokeColor(ray, lineColor, 1);
    shape(ray);
  }
}
