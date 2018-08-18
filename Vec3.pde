  class Vec3{
  float x,y,z;

  Vec3(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Vec3 add(Vec3 v){
    return new Vec3(x + v.x, y + v.y, z + v.z);
  }

  Vec3 sub(Vec3 v){
    return new Vec3(x - v.x, y - v.y, z - v.z);
  }

  Vec3 scale(float s){
    return new Vec3(x*s, y*s, z*s);
  }

  Vec3 neg(){
    return new Vec3(-x, -y, -z);
  }

  Vec3 normalize(){
    return scale(1.0/len());
  }

  Vec3 cross(Vec3 v){
    return new Vec3(y * v.z - v.y * z,
                    z * v.x - v.z * x,
                    x * v.y - v.x * y);
  }

  float len(){
    return sqrt(square());
  }

  float square(){
    return sq(x) + sq(y) + sq(z);
  }

  float dot(Vec3 v){
    return x*v.x + y*v.y + z*v.z;
  }

  String toString(){
    return "Vec3(" + x + ", " + y + ", " + z + ")";
  }

}
