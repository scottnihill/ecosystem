class Plant{
  
  PVector location;
  float size;
  float size_max = 50;
  float color_red = 0, color_green = 0, color_blue = 0;
  boolean fertile = false;
  boolean alive = true;
  float fertility = 0;
  
  Plant (float x, float y, float r, float g, float b){
    //print("PLANT CREATED");
    location = new PVector(x,y);
    color_red = r;
    color_green = g;
    color_blue = b;
    size = 0.01;
  }
  
  void display() {
    noStroke();
    fill(color_red, color_green, color_blue);
    ellipse(location.x,location.y,size,size);
  }
  
  void update(){
    grow();
    reproduce();
  }
 
  void grow(){
    size += 0.2;
    if(size > size_max){
      size = size_max;
    }
    else if(size < 0){
      size = 0;
    }
    if(size<=0){
      alive = false;
    }
  }
  
  void reproduce(){
    if(size >= 30 && fertile == false){
      fertility ++;
    }
    if(fertility> 50){
      fertile = true;
    }
  }
}