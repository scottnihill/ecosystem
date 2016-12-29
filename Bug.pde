class Bug{
  int name;
  int parent;
  DNA dna;
  String causeDeath;
  Boolean alive = true;
  float lifetime = 0;
  int generation;
  
  // GUI
  Boolean active = false; // determines whether a bug is active or not
  
  // Physical Properties
  float size;
  int color_red = 0, color_green = 0, color_blue = 0;
  PVector location;
  
  // Antenna
  int lastAntennaPing; // Used to determine when new input can be received
  PVector vAntenna1 = new PVector();
  Boolean antenna1Hit = false;
  PVector vAntenna2 = new PVector();
  Boolean antenna2Hit = false;
  
  // Movement
  Boolean steering = false;
  int timeSinceLastSteer = 0;
  PVector velocity;
  PVector acceleration;
  PVector steerTo;
  
  // Consumption
  float timeSinceLastEat = 0;
  
  // Reproduction
  Boolean fertile = false;
  float fertility = 0;
  Boolean desireMate = false;

  // DNA based variables
  float max_lifetime;
  float max_size;
  float start_speed;
  float max_speed;
  float moveOnEat;
  float antennaLength;
  float antennaSpread;
  float maxRotation;
  int max_children;
  int num_antenna;
  float jitters; // the amount of time until the bug turns
  float reproductionPriority;
  
  Bug (float x, float y, int r, int g, int b, int bugName){
    name = bugName;
    dna = new DNA(name);
    max_lifetime = dna.max_lifetime;
    max_size = dna.max_size;
    start_speed = dna.start_speed;
    max_speed = dna.max_speed;
    moveOnEat = dna.moveOnEat;
    antennaLength = dna.antennaLength;
    antennaSpread = dna.antennaSpread;
    maxRotation = dna.maxRotation;
    max_children = dna.max_children;
    num_antenna = dna.num_antenna;
    jitters = dna.jitters; 
    reproductionPriority = dna.reproductionPriority;

    location = new PVector(x,y);
    acceleration = new PVector(0,0);
    color_red = r+ceil(random(-10,10));
    color_green = g+ceil(random(-10,10));
    color_blue = b+ceil(random(-10,10));
    size = 10;
    velocity = new PVector(start_speed, start_speed);
  }
  
  void inheritDNA(DNA dna1, DNA dna2){
    dna.inherit(dna1, dna2);
    parent = dna.parent;
    max_size = dna.max_size;
    max_speed = dna.max_speed;
    moveOnEat = dna.moveOnEat;
    antennaLength = dna.antennaLength;
    antennaSpread = dna.antennaSpread;
    maxRotation = dna.maxRotation;
    start_speed = dna.start_speed;
    max_lifetime = dna.max_lifetime;
  }
  
  void display() {
    noStroke();
    
    // Red cirlce around bug to indicate the bug data is currently being focussed on
    if(active){
      fill(255, 0, 0);
      ellipse(location.x,location.y,size+5,size+5);
    }
    
    
    
    // Draw antenna's
    vAntenna1 = velocity.copy().rotate(-PI*antennaSpread*2).copy().normalize().mult(antennaLength*size).add(location.x, location.y);
    vAntenna2 = velocity.copy().rotate(PI*antennaSpread*2).copy().normalize().mult(antennaLength*size).add(location.x, location.y);
    stroke(126);
    line(location.x, location.y, vAntenna1.x, vAntenna1.y);
    line(location.x, location.y, vAntenna2.x, vAntenna2.y);
    
    if(antenna1Hit){
      fill(240, 245, 246);
      ellipse(vAntenna1.x,vAntenna1.y,5,5);
    }
    if(antenna2Hit){
      fill(240, 245, 246);
      ellipse(vAntenna2.x,vAntenna2.y,5,5);
    }
    
    // Draw body
    fill(color_red, color_green, color_blue);
    ellipse(location.x,location.y,size,size);
    
    // Draw link showing direct the bug is travelling too
    /*if(steering && steerTo != null){ 
       stroke(0);
       line(location.x, location.y, steerTo.x, steerTo.y);
       noFill();
       stroke(0);
       ellipse(location.x,location.y,size,size);
    }*/
    
    // Draw circle in center of the bug to indicate it's fertile
    if(fertile){
      fill(255);
      noStroke();
      ellipse(location.x,location.y,size/4,size/4);
    }
  }
  
  void update(){
    lifetime++;
    dna.lifetime = lifetime;
    if(lifetime > max_lifetime){
       alive = false; 
    }
    
    size -= 0.02; // health decreases every frame
    if (size <= 0){
      alive = false;
      causeDeath = "starve";
    }
    // bugs must be a certain size to mate
    if(size<max_size * 2 / 10){
      desireMate = false;
    }
    if(size > max_size * 8 / 10){
      fertile = true;
    }
    else{
      fertile = false;
    }
    
    if(steerTo != null){
      steer();
    }
    
    velocity.add(acceleration);
    velocity.limit(max_speed);
    
    // If bug has not eaten after n seconds then change direction
    timeSinceLastEat++;
    if(timeSinceLastEat > jitters){
      timeSinceLastEat = 0;
      PVector newForce = new PVector(random(-0.1,0.1),random(-0.1,0.1));
      newForce.rotate(maxRotation*PI/180);
      applyForce(newForce);
    }
    
    location.add(velocity);
    
    // ??? note sure why this has no effect
    acceleration.mult(0);
  }
  
  // change the point the bug steers to
  // 'type' = the thing that is directing the bugs attention
  void updateSteerTo(PVector destination, String type){
    // 
    if(fertile && type == "bug" || !fertile && type == "food"){
      if(millis() - timeSinceLastSteer > jitters){
        //println("STEER: change direction");
        steerTo = destination;
        timeSinceLastSteer = millis();
        steering = true;
      }
    }
  }
  
  // controls the movement of the bug
  void steer(){
    // Get the vector between the current location and point to steer to
    PVector diff = PVector.sub(location, steerTo); 
    // If reached target turn off steering
    /*if(active){
      println(diff.mag() + " " + size/2);
    }*/
    
    // if the magnitude of the destination is snaller than the radius 
    if(diff.mag() < size/2){
      // stop steering
      steering = false;
      timeSinceLastSteer = 0;
    }
    // stop steering after n seconds without additional contact with an object
    if(millis() - timeSinceLastSteer > jitters){
      steering = false;
    }
    if(steering){
      diff.normalize();
      diff.setMag(max_speed);
      PVector steer = PVector.add(diff,velocity);
      applyForce(steer);
    }
  }
  
  void eat(){
    size += 0.1;
    timeSinceLastEat = 0;
    if(size>= max_size){
      size = max_size;
    }
    PVector newForce = new PVector(random(moveOnEat * -1, moveOnEat), random(moveOnEat * -1, moveOnEat));
    applyForce(newForce);
  }
  
  void reproduce(){
    if(fertile){
      fertile = false;
      size /= 3;
    }
  }
  
  void antennaPing(int antennaNum){
   if(millis() - lastAntennaPing >= 500){
      antenna1Hit=false;
      antenna2Hit=false;
    }
 
    if(antennaNum == 1){
      antenna1Hit=true;
      antenna2Hit=false;
      lastAntennaPing = millis();
    }
    if(antennaNum == 2){
      antenna2Hit=true;
      antenna1Hit=false;
      lastAntennaPing = millis();
    }
  }
  
  // this is the main function that controls steering
  void applyForce(PVector force) {
    PVector f = force.copy();
    // size of bug affects affects speed
    f.div(size);
    // the new acceleration is set and applied during update() 
    acceleration.sub(f);
  }
  
  // wrap bug to other side of the screen
  // 
  void checkEdges() {
    if (location.x > width + 100) {
      location.x = 0;
    } else if (location.x < -100) {
      location.x = width;
    }
 
    if (location.y > height + 100) {
      location.y = 0;
      
    } else if (location.y < -100) {
      location.y = height;
    }
  }
  
  
}