class Star {
  float speed = 0.5 + random(2.5);
  PVector trajectory;
  PVector position;
  int diameter;
  int myFrame;
  float angle;

  int timeSpan;
  
  Star() {
    //speed = 0.25 + random(1.25);
    //float a = random(TWO_PI);
    //trajectory = traj.mult(speed);
    int spans[] = {4, 8, 16};
    int index = floor(random(spans.length));
    timeSpan = 60 * spans[index];
    angle = random(TWO_PI);
    // angle = HALF_PI / 2;
    //trajectory = traj;
    position = new PVector(0, 0);
    diameter = round(random(maxDiam - minDiam)) + minDiam;
    myFrame = floor(random(timeSpan));
  }

  //void update(float d) {
  //  float t = myFrame % timeSpan / timeSpan;
  //  position.x = wd / 2 + t * trajectory.x * (diag + diameter / 2);
  //  position.y = ht / 2 + t * trajectory.y * (diag + diameter / 2);
  //  //position.x += t * trajectory.x;
  //  //position.y += t * trajectory.y;
  //  //position.add(this.trajectory);
  //  //if(d > diag + diameter / 2) {
  //  //  position = new PVector(wd / 2, ht / 2);
  //  //}
  //  myFrame += 1;
  //  if(myFrame == timeSpan) {
  //    myFrame = 0;
  //  }
  //}

  void update() {
    float amt = myFrame % timeSpan / (float) timeSpan;
    // float t = amt; // linear
    // float t = amt == 0 ? 0 : pow(2, 10 * amt - 10); // exponential;
    float t = amt * amt * amt; // cubic 

    position.x = wd / 2 + t * (diag + diameter / 2) * cos(angle);
    position.y = ht / 2 + t * (diag + diameter / 2) * sin(angle);
    myFrame += 1;
  }  
  
  void render() {
    fill(0);
    stroke(lineColor);
    circle(position.x, position.y, diameter);
  }
}
