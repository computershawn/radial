class Line {
  PVector startPoint;
  PVector endPoint;
  
  Line(PVector pt0, PVector pt1) {
    startPoint = pt0;
    endPoint = pt1;
  }
  
  void render() {
    line(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
  }
}
