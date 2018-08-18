class Plane implements Intersectable{
  Vec3 p;
  Vec3 n;
  Material m;

   Plane(Vec3 pos, Vec3 normal, Material material){
     this.n = normal.normalize(); this.p = pos; this.m = material;
   }

  Intersection intersect(Ray ray){
    Intersection isect = new Intersection();
    // n dot u
    float v = this.n.dot(ray.dir);
    float t = -(this.n.dot(ray.origin.sub(this.p))) / v;
    if (t >= 0){
      isect.t = t;
      isect.p = ray.origin.add(ray.dir.scale(t));
      isect.n = this.n;
      isect.m = this.m;
    }
    return isect;
  }
}
