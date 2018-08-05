  class Vec3{
  float x,y,z;
  
  Vec3(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }  
  
  Vec3 add(Vec3 v){
    return new Vec3(this.x + v.x, this.y + v.y, this.z + v.z);
  }
  
  Vec3 sub(Vec3 v){
    return new Vec3(this.x - v.x, this.y - v.y, this.z - v.z);
  }
  
  Vec3 scale(float s){
    return new Vec3(this.x*s, this.y*s, this.z*s);
  }
  
  Vec3 neg(){
    return new Vec3(-this.x, -this.y, -this.z);
  }
  
  Vec3 normalize(){
    return scale(1.0/len());
  }
  
  Vec3 cross(Vec3 v){
    return new Vec3(this.y * v.z - v.y * this.z,
                    this.z * v.x - v.z * this.x,
                    this.x * v.y - v.x * this.y);
  }
  
  float len(){
    return sqrt(this.square());
  }
  
  float square(){
    return sq(this.x) + sq(this.y) + sq(this.z);
  }
  
  float dot(Vec3 v){
    return this.x*v.x + this.y*v.y + this.z*v.z;
  }
  
  String toString(){
    return "Vec3(" + this.x + ", " + this.y + ", " + this.z + ")";
  }
  
}
