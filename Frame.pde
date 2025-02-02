class Frame {
  float xPos, yPos;
  int index;
  int mar = 6;
  PShape sunOutline;
  //ArrayList<Projectile> stars;

  Frame(float _xPos, float _yPos, int _index) {
    xPos = _xPos;
    yPos = _yPos;
    index = _index;

    wd = width;
    ht = height;
    cx = wd / 2;
    cy = ht / 2;
    diag = 0.5 * sqrt(dims.y * dims.y + dims.x * dims.x);

    sunOutline = createShape(ELLIPSE, dims.x / 2, dims.y / 2, diam1, diam1);
  }

  void update() {
    // Update stars positions
    for (Projectile star : stars) {
      if (currentMode == Modes.ANIMATE) {
        star.update(frameCount);
      }
      if (currentMode == Modes.PRINT) {
        star.update(currentPage * frameCols * frameRows + index);
      }
    };

    // Update rays positions
    for (Ray ray : rays) {
      if (currentMode == Modes.ANIMATE) {
        ray.update(frameCount);
      }
      if (currentMode == Modes.PRINT) {
        ray.update(currentPage * frameCols * frameRows + index);
      }
    }
  }

  void render() {
    pushMatrix();
    if (currentMode == Modes.ANIMATE) {
      translate(cx - dims.x / 2, cy - dims.y / 2);
    } else {
      translate(xPos, yPos);
    }

    // Layer: Rays
    renderRays();

    // Layer: Stars
    renderStars();

    // Layer: Sun in center
    sun.render();

    renderPictureFrame();

    popMatrix();
  }

  void renderRays() {
    color co = multiColor ? lineColor3 : lineColor;
    PShape rayGroup = createShape(GROUP);
    for (Ray ray : rays) {
      PShape r = ray.getGeom();
      rayGroup.addChild(r);
    }
    PShape circo = createShape(ELLIPSE, dims.x / 2, dims.y / 2, diam1, diam1);
    // Intersect initial shape with frame
    rayGroup = intersectShapes(rayGroup, niceFrame);
    PShape starCluster = blobItems(stars, stars.size());
    rayGroup = subtractShapes(rayGroup, circo);
    rayGroup = subtractShapes(rayGroup, starCluster);
    PGS_Conversion.setAllStrokeColor(rayGroup, co, 1);
    shape(rayGroup);
  }

  void renderStars() {
    PShape[] temp = new PShape[numStars / 2];
    int j = 0;
    for (Projectile star : stars) {
      if (star.kind == 2) {
        temp[j] = createShape(ELLIPSE, star.pos.x, star.pos.y, star.diameter, star.diameter);
        j += 1;
      }
    }

    PShape[] ps = removeHiddenLines(stars);
    PShape lines0 = createShape();
    int d = ps[0].getChildCount();
    lines0.beginShape(LINES);
    for (int i = 0; i < d; i++) {
      PShape s = ps[0].getChild(i);
      int c = s.getVertexCount();
      if (c > 0) {
        PVector u1 = s.getVertex(0);
        PVector u2 = s.getVertex(1);
        lines0.vertex(u1.x, u1.y);
        lines0.vertex(u2.x, u2.y);
      }
    }
    lines0.endShape();

    PShape lines1 = createShape();
    d = ps[1].getChildCount();
    lines1.beginShape(LINES);
    for (int i = 0; i < d; i++) {
      PShape s = ps[1].getChild(i);
      int c = s.getVertexCount();
      if (c > 0) {
        PVector u1 = s.getVertex(0);
        PVector u2 = s.getVertex(1);
        lines1.vertex(u1.x, u1.y);
        lines1.vertex(u2.x, u2.y);
      }
    }
    lines1.endShape();

    color co = multiColor ? lineColor1 : lineColor;
    PShape lines0Clipped = intersectShapes(lines0, niceFrame);
    PShape lines1Clipped = intersectShapes(lines1, simpleFrame);
    PGS_Conversion.setAllStrokeColor(lines0Clipped, co, 1);
    PGS_Conversion.setAllStrokeColor(lines1Clipped, co, 1);
    PGS_Conversion.setAllStrokeColor(ps[2], co, 1);
    PGS_Conversion.setAllStrokeColor(ps[3], co, 1);
    PGS_Conversion.disableAllFill(ps[2]);
    PGS_Conversion.disableAllFill(ps[3]);

    // Background stars
    shape(lines0Clipped); // Lines
    shape(ps[2]); // Circles

    // Foreground stars
    shape(lines1Clipped); // Lines
    shape(ps[3]); // Circles
  }

  void renderPictureFrame() {
    color co = multiColor ? lineColor3 : lineColor;
    // Layer: Stylized frame
    PShape blob = blobItems(stars, stars.size() / 2);
    PShape niceFrameClipped = subtractShapes(niceFrameOpen, blob);
    PGS_Conversion.disableAllFill(niceFrameClipped);
    PGS_Conversion.setAllStrokeColor(niceFrameClipped, co, 1);
    shape(niceFrameClipped);

    co = multiColor ? lineColor2 : lineColor;
    // Layer: Outer rectangle frame
    PGS_Conversion.setAllStrokeColor(simpleFrame, co, 1);
    shape(simpleFrame);
    noFill();
    int b = 4;
    stroke(co);
    rect(b, b, dims.x - 2 * b, dims.y - 2 * b);

    // Interior rounded corners
    float a0 = 0;
    float a1 = HALF_PI;
    float a2 = PI;
    float a3 = 1.5 * PI;
    float a4 = TWO_PI;

    int r = 16;
    float x0 = b + r + 2;
    float y0 = x0;
    float x1 = dims.x - x0;
    float y1 = dims.y - y0;

    PShape arc1 = arcy(x0, y0, 2 * r, a2, a3);
    PShape arc2 = arcy(x1, y0, 2 * r, a3, a4);
    PShape arc3 = arcy(x1, y1, 2 * r, a0, a1);
    PShape arc4 = arcy(x0, y1, 2 * r, a1, a2);

    arc1 = subtractShapes(arc1, blob);
    arc2 = subtractShapes(arc2, blob);
    arc3 = subtractShapes(arc3, blob);
    arc4 = subtractShapes(arc4, blob);

    PShape corners = createShape(GROUP);
    corners.addChild(arc1);
    corners.addChild(arc2);
    corners.addChild(arc3);
    corners.addChild(arc4);
    PGS_Conversion.setAllStrokeColor(corners, co, 1);
    shape(corners);
  }
}
