class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  float mass;
  
  Mover(float m, float x, float y) {
    location = new PVector(x,y);
    velocity = new PVector(0,0);
    topspeed = 4;
    mass = m;
    acceleration = new PVector(0,0);
  }
  
  void update() {
    PVector mouse = new PVector(mouseX,mouseY);
   
    //acceleration = PVector.random2D();
    
    /*PVector dir = PVector.sub(mouse,location);
    dir.normalize();
    dir.mult(random(0.5));
    //acceleration = dir;
    applyForce(dir);*/
    

    
    velocity.add(acceleration);
    velocity.limit(10);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acceleration.add(f);
  }
 
  void display() {
    stroke(0);
    fill(175);
    ellipse(location.x,location.y,mass*mass*PI,mass*mass*PI);
  }
  
  void checkEdges() {
    if (location.x > width) {
      //location.x = 0;
      PVector moveLeft = new PVector(0,-0.1);
      applyForce(moveLeft);
    } else if (location.x < 0) {
      //location.x = width;
      PVector moveRight = new PVector(0,0.1);
      applyForce(moveRight);
    }
 
    if (location.y > height) {
      velocity.y *= -1;
      location.y = height;
      
    } else if (location.y < 0) {
      
      //velocity.y *= -1;
    }
  }
  boolean isInside(Liquid l) {
    if (location.x>l.x && location.x<l.x+l.w && location.y>l.y && location.y<l.y+l.h)
    {
      return true;
    } else {
      return false;
    }  
  }
  
  void drag(Liquid l) {
    float speed = velocity.mag();
    float dragMagnitude = l.c * speed * speed;
     
    PVector drag = velocity.copy();
    drag.mult(-1);
    drag.normalize();
     
    drag.mult(dragMagnitude);
    applyForce(drag);
  }
}