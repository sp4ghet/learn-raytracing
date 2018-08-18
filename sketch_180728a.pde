void setup(){
  size(256,256);
}

final float NO_HIT = Float.POSITIVE_INFINITY;
int t = 0;

Ray rayCast(Vec3 cam, float x, float y){
  float imagePlane = height;
  //Direction of ray being cast
  float dx = 2*x/width - 1;
  float dy = -(2*y/height - 1) ;
  float dz = 1;

  Vec3 dir = new Vec3(dx,dy,dz).normalize();
  return new Ray(cam, dir);
}

color calcPixelColor(int x, int y, float time){
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

  Material sphere1Mat = new Material(new Spectrum(0.9, 0.1, 0.5));
  Material sphere2Mat = new Material(new Spectrum(0.5, 0.9, 0.1));
  Material sphere3Mat = new Material(new Spectrum(0.1, 0.5, 0.9));

  Sphere sphere = new Sphere(center, 0.8, sphere1Mat);
  Sphere sphere2 = new Sphere(center2, 0.8, sphere2Mat);
  Sphere sphere3 = new Sphere(center3, 0.8, sphere3Mat);
  Material planeMat = new Material(new Spectrum(0.8, 0.8, 0.8));
  Plane plane = new Plane(new Vec3(0,0.1,0), new Vec3(0,1,0), planeMat);

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
      color c = calcPixelColor(x, y, t);
      set(x,y,c);
    }
  }
  noLoop();
  // t++;
}
