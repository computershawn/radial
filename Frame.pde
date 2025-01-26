class Frame {
  float xPos, yPos;
  int index;
  int mar = 6;
  PShape sunOutline;
  ArrayList<Projectile> stars;

  Frame(float _xPos, float _yPos, int _index) {
    xPos = _xPos;
    yPos = _yPos;
    index = _index;

    wd = width;
    ht = height;
    cx = wd / 2;
    cy = ht / 2;
    //diag = 0.5 * sqrt(ht * ht + wd * wd);
    diag = 0.5 * sqrt(dims.y * dims.y + dims.x * dims.x);

    rays = new ArrayList<Ray>();
    for (int i = 0; i < numRays; i++) {
      float angle = random(TWO_PI);
      float x0 = diam0 * cos(angle) / 2;
      float y0 = diam0 * sin(angle) / 2;
      float x1 = diag * cos(angle);
      float y1 = diag * sin(angle);
      PVector pt0 = new PVector(cx + x0, cy + y0);
      PVector pt1 = new PVector(cx + x1, cy + y1);

      rays.add(new Ray(pt0, pt1, i));
    };

    center = new PVector(cx, cy);

    stars = new ArrayList<Projectile>();

    for (int i = 0; i < numStars; i++) {
      int kind = i % 2 == 0 ? 1 : 2;
      stars.add(new Projectile(kind));
    }

    sunOutline = createShape(ELLIPSE, dims.x / 2, dims.y / 2, diam1, diam1);
  }

  void render(int frameNumber, boolean isAnimating) {
    pushMatrix();
    if (isAnimating) {
      translate(cx - dims.x / 2, cy - dims.y / 2);
    } else {
      translate(xPos, yPos);
    }

    // Layer: Rays
    PShape rayGroup = createShape(GROUP);
    PShape starGroup = createShape(GROUP);
    for (Ray ray : rays) {
      if (currentMode == Modes.ANIMATE) {
        ray.update(frameNumber);
      } else {
        ray.update(index + pageStartIndex);
      }
      PShape r = ray.getGeom();
      rayGroup.addChild(r);
    }

    PShape circo = createShape(ELLIPSE, dims.x / 2, dims.y / 2, diam1, diam1);
    // Intersect initial shape with frame
    rayGroup = intersectShapes(rayGroup, niceFrame);
    PShape starCluster = blobItems(stars, stars.size());
    rayGroup = subtractShapes(rayGroup, circo);
    rayGroup = subtractShapes(rayGroup, starCluster);
    PGS_Conversion.setAllStrokeColor(rayGroup, lineColor, 1);
    shape(rayGroup);

    // Update star positions
    for (Projectile star : stars) {
      if (currentMode == Modes.ANIMATE) {
        star.update(frameNumber);
      } else {
        star.update(index + pageStartIndex);
      }
      PShape sg = star.getGeom();
      starGroup.addChild(sg);
    };

    PShape[] temp = new PShape[numStars / 2];
    int j = 0;
    for (Projectile star : stars) {
      if (star.kind == 2) {
        temp[j] = createShape(ELLIPSE, star.pos.x, star.pos.y, star.diameter, star.diameter);
        j += 1;
      }
    }

    PShape[] ps2 = removeHiddenLines(stars);
    PShape blob = blobItems(stars, stars.size() / 2);
    PShape lines0 = createShape();
    int d = ps2[0].getChildCount();
    lines0.beginShape(LINES);
    for (int i = 0; i < d; i++) {
      PShape s = ps2[0].getChild(i);
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
    d = ps2[1].getChildCount();
    lines1.beginShape(LINES);
    for (int i = 0; i < d; i++) {
      PShape s = ps2[1].getChild(i);
      int c = s.getVertexCount();
      if (c > 0) {
        PVector u1 = s.getVertex(0);
        PVector u2 = s.getVertex(1);
        lines1.vertex(u1.x, u1.y);
        lines1.vertex(u2.x, u2.y);
      }
    }
    lines1.endShape();

    PShape blep0 = intersectShapes(lines0, niceFrame);
    PShape blep1 = intersectShapes(lines1, simpleFrame);

    PGS_Conversion.setAllStrokeColor(blep0, lineColor, 1);
    PGS_Conversion.setAllStrokeColor(blep1, lineColor, 1);
    PGS_Conversion.setAllStrokeColor(ps2[2], lineColor, 1);
    PGS_Conversion.setAllStrokeColor(ps2[3], lineColor, 1);
    PGS_Conversion.disableAllFill(ps2[2]);
    PGS_Conversion.disableAllFill(ps2[3]);
    
    // Layer: Sun in center
    sun.render();

    // Layer: Stylized frame
    PShape niceFrameClipped = subtractShapes(niceFrameOpen, blob);
    PGS_Conversion.disableAllFill(niceFrameClipped);
    PGS_Conversion.setAllStrokeColor(niceFrameClipped, lineColor, 1);
    shape(niceFrameClipped);

    // Layer: Background stars
    shape(blep0);    // Lines
    shape(ps2[2]);   // Circles

    // Layer: Foreground stars
    shape(blep1);    // Lines
    shape(ps2[3]);   // Circles

    // Layer: Outer rectangle frame
    shape(simpleFrame);
    noFill();
    int b = 3;
    rect(b, b, dims.x - 2 * b, dims.y - 2 * b);

    popMatrix();
  }
}
