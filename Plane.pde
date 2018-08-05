class Plane implements Intersectable{
  float altitude;
   Vec3 n;
   Material m;
   
   Plane(float altitude, Vec3 normal, Material material){
     this.altitude = altitude; this.n = normal; this.m = material;
   }
  
  Intersection intersect(Ray ray){
    Intersection isect = new Intersection();
    // n dot u
    float v = this.n.dot(ray.dir);
    float t = -(this.n.dot(ray.origin)+this.altitude) / v;
    if (t >= 0){
      isect.t = t;
      isect.p = ray.origin.add(ray.dir.scale(t));
      isect.n = this.n;
      isect.m = this.m;
    }
    return isect;
  }
}
