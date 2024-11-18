import java.util.Date;
import processing.svg.*;
import micycle.pgs.*;

int ht, wd, cx, cy;
float diag;
PVector center;

int lineColor = #04A9B9;
int fillColor = #E5FFFA;
int numStars = 60;
int numRays = 60;
boolean saving = false;
int fps = 12;
int animationDuration = 12;

Projectile[] stars = new Projectile[numStars];
ArrayList<Ray> rays;

int diam0 = 40;
int diam1 = diam0 + 4;
int minDiam = 6;
int maxDiam = 16;
PShape frame, fancyMat;
Sun sun;
ArrayList<PVector> framePoints;

public enum Modes {
  PRINT,
    ANIMATE
}
Modes currentMode;

void setup() {
  size(166, 226);

  wd = width;
  ht = height;
  cx = wd / 2;
  cy = ht / 2;
  diag = 0.5 * sqrt(ht * ht + wd * wd);

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

void renderAnimation() {
  background(fillColor);

  // Layer: Rays
  for (Ray ray : rays) {
    ray.update();
    ray.render();
  }

  // Update star positions
  for (int i = 0; i < numStars; i++) {
    stars[i].update();
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
}

void renderPrintMode() {
  if (saving) {
    beginRecord(SVG, "output/radials-" + getTimestamp() + ".svg");
  }

  background(fillColor);

  if (saving) {
    saving = false;
    endRecord();
  }
}

void draw() {
  switch(currentMode) {
  case ANIMATE:
    renderAnimation();
    break;
  case PRINT:
  default:
    renderPrintMode();
  }
}

void keyPressed() {
  if (key == 's') {
    println("saving");
    saving = true;
  }
  if (key == 'm' && !saving) {
    if (currentMode == Modes.ANIMATE) {
      println(":: View print mode");
      currentMode = Modes.PRINT;
    } else {
      println(":: View animation mode");
      currentMode = Modes.ANIMATE;
    }
  }
}
