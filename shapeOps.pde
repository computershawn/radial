PShape subtractShapes(PShape shape1, PShape shape2) {
  PShape result = PGS_ShapeBoolean.subtract(shape1, shape2);

  return result;
}

PShape intersectShapes(PShape shape1, PShape shape2) {
  //PShape ps = getCirc(x, y, r);

  PShape result = PGS_ShapeBoolean.intersect(shape1, shape2);
  //PGS_Conversion.disableAllFill(result);

  return result;
}

PShape removeHiddenLines(ArrayList<Projectile> list) {
  ArrayList<Projectile> listCopy = (ArrayList)list.clone();
  //ArrayList<Projectile> listCopy = new ArrayList<Projectile>();
  //for(Projectile p : list) {
  //  listCopy.add(p);
  //}

  Projectile sun = new Projectile(2);
  sun.diameter = diam1;
  sun.pos = new PVector(dims.x / 2, dims.y / 2);
  listCopy.add(sun);

  int len = listCopy.size();
  PShape group = createShape(GROUP);

  PShape temp;
  Projectile pj;
  for (int i = len - 2; i >= 0; i--) {
    pj = listCopy.get(i);
    temp = getCircle(pj.pos, pj.diameter, false);
    if (pj.kind == 1) {
      temp = getLine(pj.pos, pj.diameter, pj.angle);
    }
    if (pj.kind == 2) {
      temp = getCircle(pj.pos, pj.diameter, false);
    }
    PShape cluster = getCluster(listCopy, i, null);
    temp = PGS_ShapeBoolean.subtract(temp, cluster);
    group.addChild(temp);
  }

  //pj = listCopy.get(len - 1);
  //temp = getCircle(pj.pos, pj.diameter, true);
  //group.addChild(temp);
  PGS_Conversion.disableAllFill(group);
  PGS_Conversion.setAllStrokeColor(group, color(0, 0, 255), 1);

  return group;
}

PShape[] removeHiddenLines2(ArrayList<Projectile> list) {
  ArrayList<Projectile> listCopy = (ArrayList)list.clone();
  int j = 0;

  Projectile sun = new Projectile(2);
  sun.diameter = diam1;
  sun.pos = new PVector(dims.x / 2, dims.y / 2);
  listCopy.add(sun);

  int len = listCopy.size();
  PShape group0 = createShape(GROUP);
  PShape group1 = createShape(GROUP);
  PShape group2 = createShape(GROUP);
  PShape group3 = createShape(GROUP);

  PShape temp = createShape();
  Projectile pj;

  for (int i = len - 2; i >= 0; i--) {
    pj = listCopy.get(i);
    if (inBounds(pj.pos, pj.diameter)) {
      if (pj.kind == 1) {
        temp = getLine(pj.pos, pj.diameter, pj.angle);
      }

      if (pj.kind == 2) {
        temp = getCircle(pj.pos, pj.diameter, false);
      }

      if (j < len / 2 && pj.kind == 1) {
        PShape cluster = getCluster(listCopy, i, null);
        temp = PGS_ShapeBoolean.subtract(temp, cluster);

        group0.addChild(temp);
      }

      if (j >= len / 2 && pj.kind == 1) {
        PShape cluster = getCluster(listCopy, i, null);
        temp = PGS_ShapeBoolean.subtract(temp, cluster);

        group1.addChild(temp);
      }

      if (j < len / 2 && pj.kind == 2) {
        PShape cluster = getCluster(listCopy, i, clipFrame1);
        temp = PGS_ShapeBoolean.subtract(temp, cluster);

        group2.addChild(temp);
      }

      if (j >= len / 2 && pj.kind == 2) {
        PShape cluster = getCluster(listCopy, i, clipFrame2);
        temp = PGS_ShapeBoolean.subtract(temp, cluster);

        group3.addChild(temp);
      }
    }

    j += 1;
  }

  return new PShape[]{group0, group1, group2, group3};
}

// Collected stars that are in the foreground and output
// a union of their shapes
//PShape blobForeItems(ArrayList<Projectile> list) {
//  int len = list.size();
//  PShape group = createShape(GROUP);

//  for (int i = len - 2; i >= 0; i--) {
//    Projectile pj = list.get(i);
//    if (pj.kind == 2 && i < len / 2 && inBounds(pj.pos, pj.diameter)) {
//      PShape c = getCircle(pj.pos, pj.diameter, true);
//      group.addChild(c);
//    }
//  }

//  return PGS_ShapeBoolean.union(group);
//}
PShape blobItems(ArrayList<Projectile> list, int limit) {
  //int len = list.size();
  PShape group = createShape(GROUP);

  //for (int i = len - 2; i >= 0; i--) {
  for (int i = 0; i < limit; i++) {
    Projectile pj = list.get(i);
    if (pj.kind == 2 && inBounds(pj.pos, pj.diameter)) {
      PShape c = getCircle(pj.pos, pj.diameter, true);
      group.addChild(c);
    }
  }

  return PGS_ShapeBoolean.union(group);
}


boolean inBounds(PVector pos, int s) {
  boolean inBoundsHoriz = pos.x > - s / 2 && pos.x < dims.x + s / 2;
  boolean inBoundsVert = pos.y > - s / 2 && pos.y < dims.y + s / 2;

  return inBoundsHoriz && inBoundsVert;
}

PShape getCluster(ArrayList<Projectile> list, int endIndex, PShape clipper) {
  PShape layers = createShape(GROUP);

  if (clipper != null) {
    layers.addChild(clipper);
  }

  int len = list.size();
  Projectile first = list.get(len - 1);
  PShape temp;
  if (first.kind == 2) {
    temp = getCircle(first.pos, first.diameter, true);
    layers.addChild(temp);
  }

  for (int i = len - 2; i > endIndex; i--) {
    Projectile pj = list.get(i);
    if (pj.kind == 2) {
      temp = getCircle(pj.pos, pj.diameter, true);
      layers.addChild(temp);
    }
  }

  return PGS_ShapeBoolean.union(layers);
}

PShape getCircle(PVector pos, float diam, boolean close) {
  int n = 8 + 2 * round(map(diam, minDiam, maxDiam, 0, 8));
  PShape temp = createShape();
  temp.beginShape();
  temp.noFill();
  float x0 = pos.x + 0.5 * diam * 1;
  float y0 = pos.y;

  for (int i = 0; i < n; i++) {
    float ang = TWO_PI * i / n;
    float x = pos.x + 0.5 * diam * cos(ang);
    float y = pos.y + 0.5 * diam * sin(ang);
    temp.vertex(x, y);
  }

  if (close) {
    temp.endShape(CLOSE);
  } else {
    temp.vertex(x0, y0);
    temp.endShape();
  }

  return temp;
}

PShape getLine(PVector pos, float diam, float angle) {
  float x0 = pos.x + 0.5 * diam * cos(angle);
  float y0 = pos.y + 0.5 * diam * sin(angle);
  float x1 = pos.x - 0.5 * diam * cos(angle);
  float y1 = pos.y - 0.5 * diam * sin(angle);

  PShape temp = createShape();
  temp.beginShape();
  temp.vertex(x0, y0);
  temp.vertex(x1, y1);
  temp.endShape();

  return temp;
}
