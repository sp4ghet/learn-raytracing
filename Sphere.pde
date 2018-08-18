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
    // c - p_r
    Vec3 v = center.sub(ray.origin);
    // t at point closest to center on ray
    float b = ray.dir.dot(v);
    // x = (p_r + t*u_r)
    // x-c
    Vec3 x = ray.origin.add(ray.dir.scale(b)).sub(center);
    // |x - c|^2
    float d = x.dot(x);

    if(d < sq(radius)){
      float a = sqrt(sq(radius) - d);
      isect.t = b-a;
      isect.p = ray.origin.add(ray.dir.scale(isect.t));
      isect.n = isect.p.sub(this.center).scale(1/radius);
      isect.m = this.material;
      return isect;
    }
    return isect;
  }
}
