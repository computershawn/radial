import processing.svg.*;

int ht, wd;
float diag;
PVector center;

int lineColor = 175;
int numStars = 24;
int numLines = 240; // 480;
boolean saving = false;

Star[] stars = new Star[numStars];
Line[] lines = new Line[numLines];

int minDiam = 12;
int maxDiam = 40;
int diam0 = 80;

void setup() {
  size(640, 640);
  pixelDensity(displayDensity());

  wd = width;
  ht = height;
  diag = 0.5 * wd * sqrt(2);
  
  for(int i = 0; i < lines.length; i++) {
    float angle = random(TWO_PI); 
    float x0 = diam0 * cos(angle) / 2;
    float y0 = diam0 * sin(angle) / 2;
    float x1 = diag * cos(angle);
    float y1 = diag * sin(angle);
    PVector pt0 = new PVector(wd / 2 + x0, ht / 2 + y0);
    PVector pt1 = new PVector(wd / 2 + x1, ht / 2 + y1);
    
    lines[i] = new Line(pt0, pt1);
  };  

  center = new PVector(wd / 2, ht / 2);

  for(int i = 0; i < numStars; i++) {
    PVector traj = PVector.random2D();
    // Star star = new Star(new PVector(2 * wd, 0), traj);
    Star star = new Star();
    stars[i] = star;
  }
  
  // frameRate(30);
}

void draw() {
  if(saving) {
    beginRecord(SVG, "filename.svg");
  }

  background(0);

  float r = diag;

  stroke(lineColor);
  for(int i = 0; i < lines.length; i++) {
    lines[i].render();
  };

  for(int i = 0; i < stars.length; i++) {
    // float d = stars[i].position.dist(center);
    // stars[i].update(d);
    stars[i].update();
    stars[i].render();
  };

  noStroke();
  fill(0);
  circle(wd / 2, ht / 2, diam0);
  
  stroke(0);
  strokeWeight(160);
  noFill();
  circle(wd/2, ht/2, 720);
  stroke(255);
  strokeWeight(1);
  
  if(saving) {
    saving = false;
    endRecord();
  }  
}

void keyPressed() {
  if(key == 's') {
    println("saving");
    saving = true;
  }
}
