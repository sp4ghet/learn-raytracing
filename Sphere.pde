class Sphere implements Intersectable{
  Vec3 center;
  float radius;
  Material material;
  
  Sphere(Vec3 center, float radius, Material material){
    this.center = center;
    this.radius = radius;
    this.material = material;
  }
  
  Intersection intersect(Ray ray){
    Intersection isect = new Intersection();
    // vec from circle center to camera
    Vec3 v = ray.origin.sub(center);
    float b = ray.dir.dot(v);
    float c = v.dot(v) - sq(radius);
                               
    float d = sq(b) - c;
    if(d >= 0){
      float s = sqrt(d);
      isect.t = -b - s;
      if(isect.t <= 0){isect.t = b + s;}
      if(isect.t > 0){
        isect.p = ray.dir.scale(isect.t);
        isect.n = isect.p.sub(this.center);
        isect.m = this.material;
        return isect;
      }
      return new Intersection();
    }
    return isect;
  }
}
