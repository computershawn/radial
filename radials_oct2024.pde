import java.util.Date;
import processing.svg.*;
import micycle.pgs.*;

int ht, wd, cx, cy;
float diag;
PVector center;
//ADD ARCS TO CORNERS OF FRAME
int lineColor = #000000;
int lineColor1 = #ff0000;
int lineColor2 = #00ff00;
int lineColor3 = #0000ff;
int lineColor4 = #000000;
int fillColor = #efefef;
int numStars = 80;
int numRays = 60;
boolean saving = false;
boolean multiColor = false;
int fps = 15;
int animationDuration = 12;
int timeSpan;
int mar = 6;

ArrayList<Ray> rays;
ArrayList<Projectile> stars;

int diam0 = 40;
int diam1 = diam0 + 4;
int minDiam = 6;
int maxDiam = 16;
PShape niceFrame, niceFrameOpen, fancyMat, simpleFrame;
PShape clipFrame1, clipFrame2;
Sun sun;
ArrayList<PVector> framePoints;

PVector dims = new PVector(166, 226);
int frameCols = 6;
int frameRows = 3;
int numPages = fps * animationDuration / (frameCols * frameRows);
int pageStartIndex = 0;

public enum Modes {
  PRINT,
    ANIMATE
}
Modes currentMode;
ArrayList<Frame> frames;
int currentPage = 0;

void setup() {
  size(1224, 792);

  wd = width;
  ht = height;
  cx = wd / 2;
  cy = ht / 2;
  diag = 0.5 * sqrt(dims.y * dims.y + dims.x * dims.x);

  timeSpan = fps * animationDuration;

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

  stars = new ArrayList<Projectile>();

  for (int i = 0; i < numStars; i++) {
    int kind = i % 2 == 0 ? 1 : 2;
    stars.add(new Projectile(kind));
  }

  framePoints = getFramePoints();
  niceFrame = getNiceLittleFrame(true);
  niceFrameOpen = getNiceLittleFrame(false);
  fancyMat = getNiceLittleMat();
  simpleFrame = getSimpleMat(mar);
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

  currentMode = Modes.ANIMATE;
  frameRate(fps);

  println("Current page is " + getPage());
  println("Press 'c' to switch to multi-color view");
  println("Press 'm' to switch to print mode");
}

void renderPrintMode() {
  if (saving) {
    beginRecord(SVG, "output/radials-" + getTimestamp() + "-" + (currentPage + 1) + ".svg");
  }

  for (Frame f : frames) {
    f.update();
    f.render();
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
    f.update();
    f.render();
    break;
  case PRINT:
  default:
    renderPrintMode();
  }
}

void keyPressed() {
  if (key == 's') {
    println("\nSaving page " + getPage() + "\n--------");
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
  if (key == 'c' && !saving) {
    if (multiColor) {
      multiColor = false;
      println(":: Switched to multi-color");
    } else {
      multiColor = true;
      println(":: Switched to single-color");
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
    println("\nChanged to page " + getPage() + "\n--------");
  }
}

String getPage() {
  return (currentPage + 1) + " / " + numPages;
}
