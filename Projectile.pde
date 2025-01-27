class Projectile {
  float speed = 0.5 + random(2.5);
  PVector trajectory;
  PVector pos;
  int currentFrame = 0;
  int diameter;
  int frameOffset;
  float angle;
  float x0, y0;
  int kind;
  PShape circo;
  int mar = 6;

  Projectile(int _kind) {
    kind = _kind;
    angle = random(TWO_PI);
    pos = new PVector(0, 0);
    diameter = round(random(maxDiam - minDiam)) + minDiam;
    frameOffset = floor(random(timeSpan));
    int r = 6;
    x0 = r * cos(angle);
    y0 = r * sin(angle);
  }

  //void update(int frameNum) {
  //  int currentFrame = frameNum + frameOffset;
  //  //if (currentMode == Modes.ANIMATE) {
  //  //  currentFrame = frameNum + frameOffset;
  //  //}
  //  //if (currentMode == Modes.PRINT) {
  //  //  currentFrame = frameNum;
  //  //}

  //  float amt = currentFrame % timeSpan / (float) timeSpan;
  //  amt = easeInCubic(amt);

  //  pos.x = dims.x / 2 + amt * (diag + diameter / 2) * cos(angle);
  //  pos.y = dims.y / 2 + amt * (diag + diameter / 2) * sin(angle);
  //}

  //void update(int frameNum) {
  //  currentFrame = frameNum + frameOffset;
  //  float amt = currentFrame % timeSpan / (float) timeSpan;
  //  amt = easeInCubic(amt);

  //  pos.x = dims.x / 2 + amt * (diag + diameter / 2) * cos(angle);
  //  pos.y = dims.y / 2 + amt * (diag + diameter / 2) * sin(angle);
  //}
  
  void update(int frameNum) {
    currentFrame = frameNum + frameOffset;
    float amt = currentFrame % timeSpan / (float) timeSpan;
    amt = easeInCubic(amt);

    pos.x = dims.x / 2 + amt * (diag + diameter / 2) * cos(angle);
    pos.y = dims.y / 2 + amt * (diag + diameter / 2) * sin(angle);
  }
  
  //void updateOther(int index) {
  //  int frameNum = currentPage * frameCols * frameRows + index + frameOffset;
  //  // Example
  //  // timeSpan is 180
  //  // frameNumber is 143
  //  // frameOffset = 87
  //  // 143 + 87 = 230
  //  // 230 % 180 is 50
  //  // amt = 50/180 = 0.277
  //  //
  //  // what if frameOffset is 2?
  //  // timespan  177  178  179  180  181
  //  //           179  180  181  182  183
  //  //           179  0    1    2    3
  //  //           .99  0    .005 .01  .016
    
  //  //println(frameNum);
  //  ////currentFrame = frameNum + frameOffset;
  //  float amt = frameNum % timeSpan / (float) timeSpan;
  //  amt = easeInCubic(amt);

  //  pos.x = dims.x / 2 + amt * (diag + diameter / 2) * cos(angle);
  //  pos.y = dims.y / 2 + amt * (diag + diameter / 2) * sin(angle);
  //  //float amt = (float) (frameNum % timeSpan) / timeSpan;
  //  //float amt = (float) frameNum / timeSpan;
  //  //println(frameNum);
  //  //println("amt " + amt);
  //  //pos.x = dims.x / 2 + 60 * ((index % 8) / 8.0);
  //  //pos.x = dims.x / 2 + amt * 60;
  //  //pos.y = dims.y / 4;
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
    case 2: // Projectile instance is a circle
    default:
      temp = circo( pos.x, pos.y, diameter, true);
    }

    return temp;
  }
}
