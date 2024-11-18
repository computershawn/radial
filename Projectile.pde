class Projectile {
  float speed = 0.5 + random(2.5);
  PVector trajectory;
  PVector pos;
  int diameter;
  int myFrame;
  float angle;
  float x0, y0;
  int kind;
  boolean isFore = random(1) > 0.5;
  int timeSpan;
  PShape circo;

  Projectile(int _kind) {
    kind = _kind;
    timeSpan = fps * animationDuration;
    angle = random(TWO_PI);
    pos = new PVector(0, 0);
    diameter = round(random(maxDiam - minDiam)) + minDiam;
    myFrame = floor(random(timeSpan));
    int r = 6;
    x0 = r * cos(angle);
    y0 = r * sin(angle);
    circo = createShape(ELLIPSE, cx, cy, diam1, diam1);
  }

  void update() {
    float amt = myFrame % timeSpan / (float) timeSpan;
    float t = amt * amt * amt; // cubic

    pos.x = cx + t * (diag + diameter / 2) * cos(angle);
    pos.y = cy + t * (diag + diameter / 2) * sin(angle);
    myFrame += 1;
  }

  //PShape circo() {
  //  int n = 20;
  //  PShape temp = createShape();
  //  temp.beginShape();
  //  for (int i = 0; i <= n; i++) {
  //    float ang = TWO_PI * i / n;
  //    float x = pos.x + 1.5 * diameter * cos(ang);
  //    float y = pos.y + 1.5 * diameter * sin(ang);
  //    temp.vertex(x, y);
  //  }
  //  temp.endShape();
  //  return temp;
  //}

  void render() {
    switch(kind) {
    case 1:
      float x1 = pos.x + x0;
      float y1 = pos.y + y0;
      float x2 = pos.x - x0;
      float y2 = pos.y - y0;
      PShape temp = createShape();
      temp.beginShape();
      temp.vertex(x1, y1);
      temp.vertex(x2, y2);
      temp.endShape();
      // Intersect resulting shape with center sun
      PShape ln = subtractShapes(temp, circo);
      PGS_Conversion.setAllStrokeColor(ln, lineColor, 1);
      shape(ln);
      break;
    case 2:
    default:
      float dist = dist(pos.x, pos.y, cx, cy);
      fill(fillColor);
      stroke(lineColor);
      if (dist > 0.5 * (diam1 - diameter)) {
        circle(pos.x, pos.y, diameter);
      }
      // The below code uses PGS boolean operations to create stars
      // however, the line intersecting the center sun and the star
      // is also drawn. This is not the desired effect. So instead
      // of doing the boolean operations here, we'll need to do them
      // in post-production with vpype occult
      // Center star partially overlaps the object
      //if (dist > 0.5 * (diam1 - diameter) && dist <= 0.5 * (diam1 + diameter)) {
      //  PShape circ1 = createShape(ELLIPSE, cx, cy, diam1, diam1);
      //  PShape circ2 = createShape(ELLIPSE, pos.x, pos.y, diameter, diameter);
      //  PShape blep = subtractShapes(circ2, circ1);
      //  PGS_Conversion.setAllFillColor(blep, fillColor);
      //  PGS_Conversion.setAllStrokeColor(blep, lineColor, 1);
      //  shape(blep);
      //}
      // Center star does not overlap the object at all
      //if (dist > 0.5 * (diam1 + diameter)) {
      //  if (isFore) {
      //    PShape circ = createShape(ELLIPSE, pos.x, pos.y, diameter, diameter);
      //    PShape outerFrame = createShape();
      //    outerFrame.beginShape();
      //    outerFrame.vertex(0, 0);
      //    outerFrame.vertex(0, ht);
      //    outerFrame.vertex(wd, ht);
      //    outerFrame.vertex(wd, 0);
      //    outerFrame.endShape(CLOSE);
      //    PShape blep = intersectShapes(outerFrame, circ);
      //    PGS_Conversion.setAllFillColor(blep, fillColor);
      //    PGS_Conversion.setAllStrokeColor(blep, lineColor, 1);
      //    shape(blep);
      //  } else {
      //    //PShape circ = createShape(ELLIPSE, pos.x, pos.y, diameter, diameter);
      //    //PShape frame = niceLittleFrame();
      //    //PShape blep = intersectShapes(frame, circ);
      //    //PGS_Conversion.setAllFillColor(blep, fillColor);
      //    //PGS_Conversion.setAllStrokeColor(blep, lineColor, 1);
      //    //shape(blep);
      //    stroke(lineColor);
      //    fill(fillColor);
      //    circle(pos.x, pos.y, diameter);
      //  }
      //}
    }
  }
}
