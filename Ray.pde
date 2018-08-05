class Ray{
  Vec3 origin;
  Vec3 dir;
  
  Ray(Vec3 origin, Vec3 dir){
    this.origin = origin;
    this.dir = dir.normalize();
  }
}
