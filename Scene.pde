class Scene{
  ArrayList<Intersectable> objList = new ArrayList<Intersectable>();
  ArrayList<Light> lights = new ArrayList<Light>();
  
  Scene(){}
  
  void addIntersectable(Intersectable obj){
    this.objList.add(obj);
  }
  
  void addLight(Light light){
    this.lights.add(light);
  }
  
  Spectrum trace(Ray ray){
    Intersection isect = findNearestIntersection(ray);
    if(!isect.hit()){return CLEAR;}

    return  lighting(isect.p, isect.n, isect.m);
  }
  
  Intersection findNearestIntersection(Ray ray){
    Intersection isect = new Intersection();
    for(int i=0; i < this.objList.size(); i++){
      Intersectable obj = this.objList.get(i);
      Intersection tisect = obj.intersect(ray);
      if(tisect.t < isect.t){isect = tisect;}
    }
    return isect;
  }
  
  Spectrum lighting(Vec3 p, Vec3 n, Material m){
    Spectrum L = BLACK;
    Light directional = new Light(new Vec3(0,1,0), new Spectrum(1,1,1));
    for (int i=0; i < lights.size(); i++){
      Light light = lights.get(i);
      Spectrum c = diffuseLighting(p, n, light, m);
      //Spectrum dir = directional(n, directional, m);
      //L = L.add(dir);
      L = L.add(c);
    }
    return L;
  }
  
  Spectrum diffuseLighting(Vec3 point, Vec3 normal, Light light, Material diffuseColor){
    Vec3 lighting = light.pos.sub(point);
    Vec3 l = lighting.normalize();
    
    float dot = normal.dot(l);
    
    if(dot > 0){
      // distance to surface
      float r = point.len();
      Spectrum surfaceIntensity = light.power.mul(diffuseColor.diffuse);
      // Decay
      return surfaceIntensity.scale(dot / (4*PI*r*r));
    }else{
      return BLACK;
    }
  }
  
  Spectrum directional(Vec3 normal, Light light, Material m){
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
