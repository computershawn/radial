class Projectile {
  float speed = 0.5 + random(2.5);
  PVector trajectory;
  PVector pos;
  int diameter;
  int frameOffset;
  float angle;
  float x0, y0;
  int kind;
  int timeSpan;
  PShape circo;
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
      if (dist > 0.5 * (diam1 - diameter)) {
        fill(fillColor);
        stroke(lineColor);
        circle(pos.x, pos.y, diameter);
      }
    }
  }
}
