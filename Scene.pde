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
    if(!isect.hit()){return BLACK;}

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
    for (int i=0; i < lights.size(); i++){
      Light light = lights.get(i);
      Spectrum c = diffuseLighting(p, n, light, m);
      L = L.add(c);
    }
    return L;
  }

  Spectrum diffuseLighting(Vec3 point, Vec3 normal, Light light, Material diffuseColor){
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

  boolean visible(Vec3 point, Vec3 target){
    Vec3 v = point.sub(target).normalize();
    Ray shadowRay = new Ray(point, v);
    for(int i = 0; i < this.objList.size(); i++){
      Intersectable obj = this.objList.get(i);
      float t = obj.intersect(shadowRay).t;
      if(abs(t) > 0.001 && t < v.len()){
        return false;
      }
    }
    return true;
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
