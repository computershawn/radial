class Frame {
  float xPos, yPos;
  int index;

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

    for (int i = 0; i < numStars; i++) {
      //PVector traj = PVector.random2D();
      // Projectile star = new Projectile(new PVector(2 * wd, 0), traj);
      //int kind = i < numStars / 2 ? 1 : 2;
      int kind = i % 2 == 0 ? 1 : 2;
      //Projectile star = new Projectile(kind);
      stars[i] = new Projectile(kind);
    }
    framePoints = getFramePoints();
    frame = niceLittleFrame();
    fancyMat = niceLittleMat();
    sun = new Sun();

    currentMode = Modes.ANIMATE;
    frameRate(fps);
  }

  void render(int frameNumber, boolean isAnimating) {
    pushMatrix();
    if (isAnimating) {
      translate(cx - dims.x / 2, cy - dims.y / 2);
    } else {
      translate(xPos, yPos);
    }

    // Layer: Rays
    for (Ray ray : rays) {
      if (currentMode == Modes.ANIMATE) {
        ray.update(frameNumber);
      } else {
        ray.update(index + pageStartIndex);
      }
      ray.render();
    }

    // Update star positions
    for (int i = 0; i < numStars; i++) {
      //stars[i].update(index);

      if (currentMode == Modes.ANIMATE) {
        stars[i].update(frameNumber);
      } else {
        stars[i].update(index + pageStartIndex);
      }
    };

    // Layer: Background stars
    for (int i = 0; i < numStars / 2; i++) {
      stars[i].render();
    };

    // Layer: Mat
    shape(fancyMat);
    shape(frame);

    // Layer: Foreground stars
    for (int i = numStars / 2; i < numStars; i++) {
      stars[i].render();
    };

    // Layer: Outer frame
    int m = 6;
    simpleMat(m);

    // Layer: Sun in center
    sun.render();

    popMatrix();
  }
}
