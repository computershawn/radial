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
int fps = 15;
int animationDuration = 48;//12;

//Projectile[] stars = new Projectile[numStars];
ArrayList<Ray> rays;

int diam0 = 40;
int diam1 = diam0 + 4;
int minDiam = 6;
int maxDiam = 16;
PShape niceFrame, niceFrameOpen, fancyMat, simpleFrame;
PShape clipFrame1, clipFrame2;
Sun sun;
ArrayList<PVector> framePoints;

PVector dims = new PVector(166, 226);
int frameCols = 3;
int frameRows = 3;
int numPages = 20;
int pageStartIndex = 0;

public enum Modes {
  PRINT,
    ANIMATE
}
Modes currentMode;
ArrayList<Frame> frames;
int currentPage = 0;

void setup() {
  size(612, 792);

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

  //for (int i = 0; i < numStars; i++) {
  //  //PVector traj = PVector.random2D();
  //  // Projectile star = new Projectile(new PVector(2 * wd, 0), traj);
  //  //int kind = i < numStars / 2 ? 1 : 2;
  //  int kind = i % 2 == 0 ? 1 : 2;
  //  //Projectile star = new Projectile(kind);
  //  stars[i] = new Projectile(kind);
  //}
  framePoints = getFramePoints();
  niceFrame = getNiceLittleFrame(true);
  niceFrameOpen = getNiceLittleFrame(false);
  fancyMat = getNiceLittleMat();
  simpleFrame = getSimpleMat(6);
  clipFrame1 = getClipFrame1();
  clipFrame2 = getClipFrame2();
  sun = new Sun();

  frames = new ArrayList<Frame>();
  int gutter = 24;
  float xStep = dims.x + gutter;
  float yStep = dims.y + gutter;
  float gridWd = frameCols * dims.x + (frameCols - 1) * gutter;
  float gridHt = frameRows * dims.y + (frameRows - 1) * gutter;
  float xOff = (wd - gridWd) / 2;
  float yOff = (ht - gridHt) / 2;
  for (int i = 0; i < frameRows; i++) {
    for (int j = 0; j < frameCols; j++) {
      frames.add(new Frame(xOff + xStep * j, yOff + yStep * i, i * frameCols + j));
    }
  }
  //frames.add(new Frame(0, 20, 0));
  //frames.add(new Frame(dims.x, 20, 1));

  currentMode = Modes.PRINT;
  frameRate(fps);
}

void renderPrintMode() {
  if (saving) {
    beginRecord(SVG, "output/radials-" + getTimestamp() + "-" + currentPage + ".svg");
  }

  for (int j = 0; j < frames.size(); j++) {
    Frame f = frames.get(j);
    f.render(j, false);
  }

  if (saving) {
    saving = false;
    endRecord();
  }
}

void draw() {
  background(fillColor);
  switch(currentMode) {
  case ANIMATE:
    Frame f = frames.get(0);
    f.render(frameCount, true);
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
  if (key == CODED && !saving && currentMode == Modes.PRINT) {
    if (keyCode == LEFT) {
      if (currentPage == 0) {
        currentPage = numPages - 1;
      } else {
        currentPage -= 1;
      }
    } else if (keyCode == RIGHT) {
      if (currentPage == numPages - 1) {
        currentPage = 0;
      } else {
        currentPage += 1;
      }
    }

    pageStartIndex = currentPage * frameCols * frameRows;
  }
}
