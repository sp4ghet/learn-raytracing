class Spectrum{
  float r,g,b;
  
  Spectrum(float r, float g, float b){
    this.r = r; this.g = g; this.b = b;
  }
  
  Spectrum add(Spectrum v){
    return new Spectrum(this.r+v.r, this.g+v.g, this.b+v.b);
  }
  
  Spectrum mul(Spectrum v){
    return new Spectrum(this.r*v.r, this.g*v.g, this.b*v.b);
  }
  
  Spectrum scale(float s){
    return new Spectrum(this.r*s, this.g*s, this.b*s);
  }
  
  color toColor(){
    int ir = (int)min(this.r*255,255);
    int ig = (int)min(this.g*255,255);
    int ib = (int)min(this.b*255,255);
    return color(ir,ig,ib);
  }
}

final Spectrum BLACK = new Spectrum(0,0,0);
final Spectrum CLEAR = new Spectrum(1,0,1);
