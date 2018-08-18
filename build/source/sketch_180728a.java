import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_180728a extends PApplet {

public void setup(){
  
}

final float NO_HIT = Float.POSITIVE_INFINITY;
int t = 0;

public Ray rayCast(Vec3 cam, float x, float y){
  float imagePlane = height;
  //Direction of ray being cast
  float dx = 2*x/width - 1;
  float dy = -(2*y/height - 1) ;
  float dz = 1;

  Vec3 dir = new Vec3(dx,dy,dz).normalize();
  return new Ray(cam, dir);
}

public int calcPixelColor(int x, int y, float time){
  Scene scene = new Scene();
  Light light = new Light(new Vec3(0,100,0), new Spectrum(10000,10000,10000));
  Light light2 = new Light(
    new Vec3(100, 100, -100), // 位置
    new Spectrum(400000, 100000, 400000) // パワー（光源色）
  );
  Light light3 = new Light(
    new Vec3(-100, 100, -100), // 位置
    new Spectrum(100000, 400000, 100000) // パワー（光源色）
  );
  Light light4 = new Light(new Vec3(-2, 2, 4), new Spectrum(0,100,0));
  scene.addLight(light);
  scene.addLight(light2);
  scene.addLight(light3);
  // scene.addLight(light4);

  Vec3 cam = new Vec3(0, 1, -4);
  Vec3 center = new Vec3(-2,1,0);
  Vec3 center2 = new Vec3(0,1,0);
  Vec3 center3 = new Vec3(2,1,0);
  Ray d = rayCast(cam, x,y);

  Material sphere1Mat = new Material(new Spectrum(0.9f, 0.1f, 0.5f));
  Material sphere2Mat = new Material(new Spectrum(0.5f, 0.9f, 0.1f));
  Material sphere3Mat = new Material(new Spectrum(0.1f, 0.5f, 0.9f));

  Sphere sphere = new Sphere(center, 0.8f, sphere1Mat);
  Sphere sphere2 = new Sphere(center2, 0.8f, sphere2Mat);
  Sphere sphere3 = new Sphere(center3, 0.8f, sphere3Mat);
  Material planeMat = new Material(new Spectrum(0.8f, 0.8f, 0.8f));
  Plane plane = new Plane(new Vec3(0,0.1f,0), new Vec3(0,1,0), planeMat);

  scene.addIntersectable(sphere);
  scene.addIntersectable(sphere2);
  scene.addIntersectable(sphere3);
  scene.addIntersectable(plane);

  Spectrum brightness = scene.trace(d);

  return brightness.toColor();
}

public void draw(){
  for(int x = 0; x < width; x++){
    for(int y=0; y < height; y++){
      int c = calcPixelColor(x, y, t);
      set(x,y,c);
    }
  }
  noLoop();
  // t++;
}
class Intersection{
  float t = NO_HIT;
  Vec3 p;
  Vec3 n;
  Material m;
  
  Intersection(){}
  
  public boolean hit() {return this.t != NO_HIT;}
}

interface Intersectable{
  public Intersection intersect(Ray ray);
}
class Light{
  Vec3 pos;
  Spectrum power;
  
  Light(Vec3 pos, Spectrum power){
    this.pos = pos; this.power = power;
  }

}
class Material{
  Spectrum diffuse;
  
  Material(Spectrum diffuse){
    this.diffuse = diffuse;
  }
}
class Plane implements Intersectable{
  Vec3 p;
  Vec3 n;
  Material m;

   Plane(Vec3 pos, Vec3 normal, Material material){
     this.n = normal.normalize(); this.p = pos; this.m = material;
   }

  public Intersection intersect(Ray ray){
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
float EPSILON = 0.001f;

class Ray{
  Vec3 origin;
  Vec3 dir;

  Ray(Vec3 origin, Vec3 dir){
    this.dir = dir.normalize();
    this.origin = origin;
  }
}
class Scene{
  ArrayList<Intersectable> objList = new ArrayList<Intersectable>();
  ArrayList<Light> lights = new ArrayList<Light>();

  Scene(){}

  public void addIntersectable(Intersectable obj){
    this.objList.add(obj);
  }

  public void addLight(Light light){
    this.lights.add(light);
  }

  public Spectrum trace(Ray ray){
    Intersection isect = findNearestIntersection(ray);
    if(!isect.hit()){return BLACK;}

    return  lighting(isect.p, isect.n, isect.m);
  }

  public Intersection findNearestIntersection(Ray ray){
    Intersection isect = new Intersection();
    for(int i=0; i < this.objList.size(); i++){
      Intersectable obj = this.objList.get(i);
      Intersection tisect = obj.intersect(ray);
      if(tisect.t < isect.t){isect = tisect;}
    }
    return isect;
  }

  public Spectrum lighting(Vec3 p, Vec3 n, Material m){
    Spectrum L = BLACK;
    for (int i=0; i < lights.size(); i++){
      Light light = lights.get(i);
      Spectrum c = diffuseLighting(p, n, light, m);
      L = L.add(c);
    }
    return L;
  }

  public Spectrum diffuseLighting(Vec3 point, Vec3 normal, Light light, Material diffuseColor){
    Vec3 lighting = light.pos.sub(point);
    Vec3 l = lighting.normalize();

    float dot = normal.dot(l);

    if(dot > 0){
      if(visible(point, light.pos)){
        // distance to surface
        float r = lighting.len();
        Spectrum surfaceIntensity = light.power.scale(dot / (4*PI*r*r));
        // Decay
        return surfaceIntensity.mul(diffuseColor.diffuse);
      }
    }
    return BLACK;
  }

  public boolean visible(Vec3 point, Vec3 target){
    Vec3 v = point.sub(target).normalize();
    Ray shadowRay = new Ray(point, v);
    for(int i = 0; i < this.objList.size(); i++){
      Intersectable obj = this.objList.get(i);
      float t = obj.intersect(shadowRay).t;
      if(abs(t) > 0.001f && t < v.len()){
        return false;
      }
    }
    return true;
  }

  public Spectrum directional(Vec3 normal, Light light, Material m){
    Vec3 l = light.pos.normalize();

    float dot = normal.dot(l);
    if(dot > 0){
      Spectrum surfaceIntensity = light.power.mul(m.diffuse);
      return surfaceIntensity.scale(dot/PI);
    }else{
      return BLACK;
    }
  }

}
class Spectrum{
  float r,g,b;
  
  Spectrum(float r, float g, float b){
    this.r = r; this.g = g; this.b = b;
  }
  
  public Spectrum add(Spectrum v){
    return new Spectrum(this.r+v.r, this.g+v.g, this.b+v.b);
  }
  
  public Spectrum mul(Spectrum v){
    return new Spectrum(this.r*v.r, this.g*v.g, this.b*v.b);
  }
  
  public Spectrum scale(float s){
    return new Spectrum(this.r*s, this.g*s, this.b*s);
  }
  
  public int toColor(){
    int ir = (int)min(this.r*255,255);
    int ig = (int)min(this.g*255,255);
    int ib = (int)min(this.b*255,255);
    return color(ir,ig,ib);
  }
}

final Spectrum BLACK = new Spectrum(0,0,0);
final Spectrum CLEAR = new Spectrum(1,0,1);
class Sphere implements Intersectable{
  Vec3 center;
  float radius;
  Material material;

  Sphere(Vec3 center, float radius, Material material){
    this.center = center;
    this.radius = radius;
    this.material = material;
  }

  public Intersection intersect(Ray ray){
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
  class Vec3{
  float x,y,z;

  Vec3(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public Vec3 add(Vec3 v){
    return new Vec3(x + v.x, y + v.y, z + v.z);
  }

  public Vec3 sub(Vec3 v){
    return new Vec3(x - v.x, y - v.y, z - v.z);
  }

  public Vec3 scale(float s){
    return new Vec3(x*s, y*s, z*s);
  }

  public Vec3 neg(){
    return new Vec3(-x, -y, -z);
  }

  public Vec3 normalize(){
    return scale(1.0f/len());
  }

  public Vec3 cross(Vec3 v){
    return new Vec3(y * v.z - v.y * z,
                    z * v.x - v.z * x,
                    x * v.y - v.x * y);
  }

  public float len(){
    return sqrt(square());
  }

  public float square(){
    return sq(x) + sq(y) + sq(z);
  }

  public float dot(Vec3 v){
    return x*v.x + y*v.y + z*v.z;
  }

  public String toString(){
    return "Vec3(" + x + ", " + y + ", " + z + ")";
  }

}
  public void settings() {  size(256,256); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180728a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
