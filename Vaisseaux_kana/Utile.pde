boolean IsPointInTriangle(PVector point, PVector p1, PVector p2, PVector p3) {
  // Calculate vectors for the edges of the triangle
  PVector v0 = new PVector(p3.x - p1.x, p3.y - p1.y);
  PVector v1 = new PVector(p2.x - p1.x, p2.y - p1.y);
  PVector v2 = new PVector(point.x - p1.x, point.y - p1.y);

  // Calculate dot products
  float dot00 = v0.x * v0.x + v0.y * v0.y;
  float dot01 = v0.x * v1.x + v0.y * v1.y;
  float dot02 = v0.x * v2.x + v0.y * v2.y;
  float dot11 = v1.x * v1.x + v1.y * v1.y;
  float dot12 = v1.x * v2.x + v1.y * v2.y;

  // Calculate barycentric coordinates
  float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
  float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
  float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

  // Check if the point is inside the triangle
  return (u >= 0) && (v >= 0) && (u + v <= 1);
}

int getSign(float val) {
  return int(val/abs(val));
}
