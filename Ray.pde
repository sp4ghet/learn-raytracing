float EPSILON = 0.001;

class Ray{
  Vec3 origin;
  Vec3 dir;

  Ray(Vec3 origin, Vec3 dir){
    this.dir = dir.normalize();
    this.origin = origin;
  }
}
