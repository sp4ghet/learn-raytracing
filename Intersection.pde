class Intersection{
  float t = NO_HIT;
  Vec3 p;
  Vec3 n;
  Material m;
  
  Intersection(){}
  
  boolean hit() {return this.t != NO_HIT;}
}

interface Intersectable{
  Intersection intersect(Ray ray);
}
