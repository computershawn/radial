class Sun {
  int sp = 2;
  int numLines = 40;
  float xOff;
  PShape hatch;

  Sun() {
    xOff = 0.5 * (numLines - 1) * sp;

    PShape lines = createShape();
    lines.beginShape(LINES);

    float x0, x1;
    for (int i = 0; i < numLines / 2; i++) {
      x0 = dims.x / 2 + 2 * i * sp - xOff;
      x1 = dims.x / 2 + (2 * i + 1) * sp - xOff;
      lines.vertex(x0 - diam0, dims.y / 2 - diam0);
      lines.vertex(x0 + diam0, dims.y / 2 + diam0);
      lines.vertex(x1 - diam0, dims.y / 2 - diam0);
      lines.vertex(x1 + diam0, dims.y / 2 + diam0);
    }
    lines.endShape();

    PShape circ = createShape(ELLIPSE, dims.x / 2, dims.y / 2, diam0, diam0);
    hatch = intersectShapes(circ, lines);
    PGS_Conversion.setAllStrokeColor(hatch, lineColor, 1);
  }

  void render() {
    fill(fillColor);
    noStroke();
    fill(fillColor);
    circle(dims.x / 2, dims.y / 2, diam1);

    shape(hatch);

    noFill();
    stroke(lineColor);
    circle(dims.x / 2, dims.y / 2, diam0);
    circle(dims.x / 2, dims.y / 2, diam0 + 2);
    
  }
}
