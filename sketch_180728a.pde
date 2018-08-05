void setup(){
  size(256,256);
}

final float NO_HIT = Float.POSITIVE_INFINITY;
int t = 0;

Ray rayCast(Vec3 cam, float x, float y){
  float imagePlane = height;
  //Direction of ray being cast
  float dx = x + 0.5 - width / 2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;
  
  Vec3 dir = new Vec3(dx,dy,dz).normalize();
  return new Ray(cam, dir);
}

color calcPixelColor(int x, int y, Vec3 lightPos){
  Scene scene = new Scene();
  Light light = new Light(lightPos, new Spectrum(0,100,100));
  Light light2 = new Light(new Vec3(0,100,15), new Spectrum(100,100,100));
  scene.addLight(light);
  scene.addLight(light2);
  
  Material diffuseMat = new Material(new Spectrum(1,1,1));
  
  Vec3 cam = new Vec3(0, 2, 0);
  Vec3 center = new Vec3(0,0,5);
  Vec3 center2 = new Vec3(3, 0, 5);
  Vec3 center3 = new Vec3(-3,0,5);
  Ray d = rayCast(cam, x,y);
  
  Sphere sphere = new Sphere(center, 1, diffuseMat);
  Sphere sphere2 = new Sphere(center2, 1, diffuseMat);
  Sphere sphere3 = new Sphere(center3, 1, diffuseMat);
  Plane plane = new Plane(0, new Vec3(0,1,0), diffuseMat);
  
  scene.addIntersectable(sphere);
  scene.addIntersectable(sphere2);
  scene.addIntersectable(sphere3);
  scene.addIntersectable(plane);
  
  Spectrum brightness = scene.trace(d);
  
  return brightness.toColor();
}

void draw(){ 
  for(int x = 0; x < width; x++){
    for(int y=0; y < height; y++){
      Vec3 lightPos = new Vec3(cos(t/(2*PI))*10,10,sin(t/(2*PI))*10);
      color c = calcPixelColor(x, y, lightPos);
      set(x,y,c);
    }
  }
  t++;
}
