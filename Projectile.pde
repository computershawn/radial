class Projectile {
  float speed = 0.5 + random(2.5);
  PVector trajectory;
  PVector pos;
  int diameter;
  int frameOffset;
  float angle;
  float x0, y0;
  int kind;
  //boolean isFore = random(1) > 0.5;
  int timeSpan;
  PShape circo;
  //PShape circ;
  PShape clip;
  int mar = 6;

  Projectile(int _kind) {
    kind = _kind;
    timeSpan = fps * animationDuration;
    angle = random(TWO_PI);
    pos = new PVector(0, 0);
    diameter = round(random(maxDiam - minDiam)) + minDiam;
    frameOffset = floor(random(timeSpan));
    int r = 6;
    x0 = r * cos(angle);
    y0 = r * sin(angle);
    //circo = createShape(ELLIPSE, dims.x / 2, dims.y / 2, diam1, diam1);
    clip = createShape();
    float w = dims.x;
    float h = dims.y;
    fill(0, 127);
    clip.beginShape();
    clip.vertex(mar, mar);
    clip.vertex(w - mar, mar);
    clip.vertex(w - mar, h - mar);
    clip.vertex(mar, h - mar);
    clip.endShape(CLOSE);
  }

  void update(int frameNum) {
    int currentFrame = frameNum + frameOffset;

    float amt = currentFrame % timeSpan / (float) timeSpan;
    amt = easeInCubic(amt);
    //float t = amt * amt * amt; // cubic

    pos.x = dims.x / 2 + amt * (diag + diameter / 2) * cos(angle);
    pos.y = dims.y / 2 + amt * (diag + diameter / 2) * sin(angle);
  }

  //PShape circo(float xpos, float ypos, float diam) {
  //  int n = 24;
  //  PShape temp = createShape();
  //  temp.beginShape();
  //  for (int i = 0; i < n; i++) {
  //    float ang = TWO_PI * i / n;
  //    float x = xpos + 0.5 * diam * cos(ang);
  //    float y = ypos + 0.5 * diam * sin(ang);
  //    temp.vertex(x, y);
  //  }
  //  temp.endShape(CLOSE);

  //  return temp;
  //}

  boolean inRange(float x, float y, float r) {
    if (x < -r || x > dims.x + r) {
      return false;
    }
    if (y < -r || y > dims.y + r) {
      return false;
    }
    return true;
  }

  PShape getGeom() {
    PShape temp;
    switch(kind) {
    case 1: // Projectile instance is a line
      float x1 = pos.x + x0;
      float y1 = pos.y + y0;
      float x2 = pos.x - x0;
      float y2 = pos.y - y0;
      temp = createShape();
      temp.beginShape();
      temp.vertex(x1, y1);
      temp.vertex(x2, y2);
      temp.endShape();

      break;

      //PShape blep = intersectShapes(clip, temp);
      //PGS_Conversion.disableAllFill(blep);
      //PGS_Conversion.setAllStrokeColor(blep, lineColor, 1);
      //shape(blep);
      //break;
    case 2: // Projectile instance is a circle
    default:
      temp = circo( pos.x, pos.y, diameter, true);
    }

    return temp;
  }

  void render() {
    float dist = dist(pos.x, pos.y, dims.x / 2, dims.y / 2);
    switch(kind) {
    case 1: // Projectile instance is a line
      if (dist > 0.5 * (diam1 - diameter)) {
        float x1 = pos.x + x0;
        float y1 = pos.y + y0;
        float x2 = pos.x - x0;
        float y2 = pos.y - y0;
        PShape temp = createShape();
        temp.beginShape();
        temp.vertex(x1, y1);
        temp.vertex(x2, y2);
        temp.endShape();

        PShape blep = intersectShapes(clip, temp);
        PGS_Conversion.disableAllFill(blep);
        PGS_Conversion.setAllStrokeColor(blep, lineColor, 1);
        shape(blep);
      }
      break;
    case 2: // Projectile instance is a circle
    default:
      //if (dist > 0.5 * (diam1 - diameter)) {
      //  PShape circ = circo(cx, cy, diam1);
      //  PShape blep = intersectShapes(clip, circ);
      //  PGS_Conversion.setAllFillColor(blep, fillColor);
      //  PGS_Conversion.setAllStrokeColor(blep, lineColor, 1);
      //  shape(blep);

      //  //PShape circ1 = circo(cx, cy, diam1);
      //  //PShape circ2 = circo(pos.x, pos.y, diameter);
      //  //PShape blep = intersectShapes(circ2, circ1);
      //  //PGS_Conversion.setAllFillColor(blep, fillColor);
      //  //PGS_Conversion.setAllStrokeColor(blep, lineColor, 1);
      //  //shape(blep);
      //}
      // Draw faceted circle and take into account whether
      // the center circle overlaps it
      //if (dist > 0.5 * (diam1 - diameter)) {
      //  PShape circ = circo(pos.x, pos.y, diameter);
      //  PShape sunOutline = circo(dims.x / 2, dims.y / 2, diam1);
      //  //PShape blep = intersectShapes(clip, circ);
      //  //PShape blep = subtractShapes(circ, sunOutline);
      //  PShape blep = intersectShapes(clip, circ);
      //  blep = subtractShapes(blep, sunOutline);

      //  PGS_Conversion.setAllFillColor(blep, fillColor);
      //  PGS_Conversion.setAllStrokeColor(blep, lineColor, 1);
      //  shape(blep);
      //}

      if (dist > 0.5 * (diam1 - diameter)) {
        fill(fillColor);
        stroke(lineColor);
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
