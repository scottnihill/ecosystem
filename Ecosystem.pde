float version = 0.4;
int timer;
int worldTime;
ArrayList<Plant> plants = new ArrayList();
ArrayList<Bug> bugs = new ArrayList();
Stats stats;
int bugsSpawned = 0;
int bugActive = 0;
PrintWriter output;

void setup() {
  
  size(800,533);
  frameRate(30);
  
  // setup the csv file for data output
  // the first line
  output = createWriter("bugData_v" + version + "_" + year() + "-"+ month()+ "-"+ day() + ".csv");
  String index = "Name, Class, Time of Death, Cause of Death";
  index += ",Parent, Age, Max Age, Max Size";
  index += ", Max Speed, Jitters, Max Rotation, Slow On Eat, Antenna Length, Antenna Spread";
  index += ", # Bugs, # PLants ";
  output.println(index);
  
  // introduce the first plant
  plants.add(new Plant(20, 20, 23, random(210,235), 25));
  
  // generate 3 bugs
  bugReproduction();
  bugReproduction();
  bugReproduction();

  
  stats = new Stats();
}

// draw all of the elements to the screen
void draw() {
  timer++;
  worldTime++;
  
  // draw the ground
  background(41, 30, 25);
  
  // If no plants then spawn one automatically
  if(plants.size() == 0){
    //print("NO PLANTS");
    plants.add(new Plant(random(width), random(height), 23, random(210,235), 25));
  }
  
  // for each plant
  for (int z = 0; z < plants.size(); z++) {
    Plant p = plants.get(z);
    p.update();
    
    // fertility Check every 60 ticks
    if(timer > 60){ 
      if(p.fertile == true){
        p.fertile = false;
        
        PVector vOffset = new PVector();
        // returns the offset of the next avaiable space
        // pass the plants current location and it's maximum size
        // the location of the next available space is returned or (0,0)
        vOffset = rotateVector(p.location, p.size_max);
        // as long as (0,0) is not returned
        if (vOffset.x != 0 && vOffset.y != 0){
          // generate a new plant 
          plants.add(new Plant(vOffset.x, vOffset.y, 23, random(210,235), 25));  
        }
      }
      // reset the timer once all the plants have been run through.
      if(z >= plants.size()-1){
        timer = 0;
      }
    }
    p.display();
  }
  
  // Bug Functions
  // create a new bug if there are less than 3
  if(bugs.size() <= 3){
    bugReproduction();
  }
  
  // loop through bugs
  for (int bs = 0; bs < bugs.size(); bs++) {
    Bug b = bugs.get(bs);
    // Add Bugs
    b.active = false;
    if(bs == bugActive){
      b.active = true;
    }

    b.update();
    b.checkEdges();
    b.display();
  }
  
  bugToBugHitTest();
 
  // Bugs eat plant
  bugEatPlant();  
  
  plantFuneral();
  bugFuneral();
  
  
  // Stats Functions
  //---------------------
  if(bugActive < bugs.size() && bugActive >= 0){
    stats.display(bugs.get(bugActive), bugActive, worldTime, bugsSpawned);
  }
}

// used by plants to determine the next position around the plant that is available
// returns 
PVector rotateVector(PVector vIn, float distance){
  // create the return vector that will store the next availble position or 0,0
  PVector vOut = new PVector(0,0);
  
  PVector vDis = new PVector(distance, 0);
  int startingAngle = floor(random(1,6))*60;
  vDis.rotate(startingAngle * PI / 180);
  // complete a full 360 sweek
  for (int a = 0; a < 6; a++) {
    vDis.rotate(60 * PI / 180);
    PVector vCheck = new PVector();
    vCheck = vIn.copy().add(vDis);
    if(hitTest(vCheck) == false){
       vOut = vCheck;
    }
  }
  return vOut;
}

void bugToBugHitTest(){
  // loop through each bug
  for (int bs1 = 0; bs1 < bugs.size(); bs1++) {
    Bug b1 = bugs.get(bs1);
    PVector sum = new PVector();
    int count = 0;
    // loop through each bug
    for (int bs2 = 0; bs2 < bugs.size(); bs2++) {
      Bug b2 = bugs.get(bs2);
      if(bs1 != bs2 || bs2 != bs1){
       
        // Bug body touches another bug body
        if(locationHitTest(b1.location, b1.size*1.5, b2.location, b2.size*1.5)){
          
          // Move bugs away from one another
          float d = PVector.dist(b1.location, b2.location);
          PVector diff = PVector.sub(b1.location, b2.location);
          diff.div(d);
          b1.location.add(diff);
          
          // Kill
          // add colors together for each bug
          int _b1Color = b1.color_red + b1.color_green + b1.color_blue;
          int _b2Color = b2.color_red + b2.color_green + b2.color_blue;
          // determine the ratio of the size between the bugs
          float sizeRatio = b1.size / b2.size;
          
          // if 
          if(_b1Color - _b2Color > 100 || _b1Color - _b2Color < -100 && sizeRatio > 1.1){
            b2.causeDeath = "murder";
            b2.alive = false;
            println("Bug 2 killed: " + sizeRatio);
            
          }
              
          // Reproduction
          if(b1.fertile && b2.fertile){
            b1.reproduce();
            b2.reproduce();
            
            int numChildren = round(b1.max_children + b2.max_children / 2);
            int i = 0;
            while (i < numChildren) {
              Bug babybug = new Bug(
                b1.location.x + random(-20, 20), 
                b2.location.y + random(-20, 20), 
                b1.color_red, 
                b2.color_red, 
                b1.color_red, 
                bugsSpawned
              );
              
              babybug.inheritDNA(b1.dna, b2.dna);
              bugs.add(babybug);
              bugsSpawned++;
              i++;
            }
          }
        }
        
        // Check to see if bug antenna 1 hits another bug
        if(locationHitTest(b1.vAntenna1, 3.0, b2.location, b2.size)){
          b1.updateSteerTo(b2.location.copy(), "bug");
          b1.desireMate = true;
          b1.antennaPing(1);
        }
        // Check to see if bug antenna 2 hits another bug
        else if(locationHitTest(b1.vAntenna2, 3.0, b2.location, b2.size)){
          b1.updateSteerTo(b2.location.copy(), "bug");
          // Set desire mate to true 
          b1.desireMate = true;
          // light up the antenna
          b1.antennaPing(2);
        }
        else{
          b1.antennaPing(0);
        }
      }
    }
    /*if (count > 0) {
      sum.div(count);
      sum.normalize();
      //sum.mult(b1.max_speed);
      PVector steer = PVector.sub(sum, b1.velocity);
      //steer.limit(maxforce);
      b1.applyForce(steer);
    }*/
  }
}

// This is used to check whether or not a specified vector (plant x,y) is  
boolean hitTest(PVector v){
  boolean hit = true;
  
  // check the bounds of the application
  if(v.x < -50 || v.x > width + 50 || v.y < -50 || v.y > height +50){
    if (hit != false){
      hit = true;
    }
  }
  // check each plant
  else{
    for (int pl = 0; pl < plants.size(); pl++) {
      Plant p = plants.get(pl);
      
      if (v.x > p.location.x - p.size_max/2 && 
          v.x < p.location.x+p.size_max/2 &&
          v.y > p.location.y- p.size_max/2 &&
          v.y < p.location.y+p.size_max/2 
      ){
        hit = true;
        break;
      }
      else {
        hit = false;
      }
    }
  }
  return hit;
}

void plantFuneral(){
  for (int i = plants.size() - 1; i >= 0; i--) {
    Plant p = plants.get(i);
    if (!p.alive) {
      plants.remove(i);
    }
  }
}

void bugFuneral(){
  for (int i = bugs.size() - 1; i >= 0; i--) {
    Bug b = bugs.get(i);
    if (!b.alive) {
      int bugclass = b.color_red+b.color_green+b.color_blue;
      output.println(b.name + ", " +
                   bugclass + ", " +
                   worldTime + ", " +
                   b.causeDeath + ", " +
                   b.parent + ", " +
                   b.lifetime + ", " +
                   b.max_lifetime + ", " +
                   b.max_size + ", " +
                   b.max_speed + ", " +
                   b.jitters + ", " +
                   b.maxRotation + ", " +
                   b.moveOnEat + ", " +
                   b.antennaLength + ", " +
                   b.antennaSpread + ", " +
                   bugs.size() + ", " +
                   plants.size()
                   
    );
      bugs.remove(i);
    }
  }
}


void bugEatPlant(){
  for (int ps = 0; ps < plants.size(); ps++) {
    Plant p = plants.get(ps);
    for (int bs = 0; bs < bugs.size(); bs++) {
      Bug b = bugs.get(bs);
      if (b.location.x > p.location.x - p.size_max/2 && 
          b.location.x < p.location.x+p.size_max/2 &&
          b.location.y > p.location.y- p.size_max/2 &&
          b.location.y < p.location.y+p.size_max/2
      ){
        b.eat();
        if(b.size <= b.max_size){p.size -= 0.3;}
      }
      // Antenna 1 
      if(locationHitTest(b.vAntenna1, 3.0, p.location, p.size)){
        b.updateSteerTo(p.location, "food");
        b.antennaPing(1);
      } 
      // Antenna 2
      else if(locationHitTest(b.vAntenna2, 3.0, p.location, p.size) && !b.desireMate){
        b.updateSteerTo(p.location, "food");
        b.antennaPing(2);
      }
      else{
        b.antennaPing(0);
      }
    }
  }
}

void bugReproduction(){
  bugs.add(new Bug(random(0, 300), random(0, 300), int(random(100, 255)), int(random(100, 255)), int(random(100, 255)), bugsSpawned));
  bugsSpawned++;
}

// 
Boolean locationHitTest(PVector l1, Float s1, PVector l2, Float s2){
  Boolean hit = false;
  
  // get distances between the balls components
  PVector bVect = PVector.sub(l1, l2);

  // calculate magnitude of the vector separating the balls
  float bVectMag = bVect.mag();
  
  if (bVectMag < s1/2 + s2/2) {
    hit = true;
  }
  
  /*if (l1.x + s1 / 2 > l2.x - s2 / 2 && 
          l1.x - s1 / 2 < l2.x + s2 / 2 &&
          l1.y + s1 / 2 > l2.y - s2/2 &&
          l1.y - s1 / 2  < l2.y + s2/2 
  ){
    hit = true;
  }*/
  
  return hit;
}

void keyPressed(){
  print("KEY PRESSED ");
  if(key == 'a' || key == 'A'){
    stats.showHide("a");
  }
  else if(key == 'w' || key == 'W'){
    stats.showHide("w");
  }
  if(key == '0'){
    bugActive = 0;
  }
  else if(key == '1'){
    bugActive = 1;
  }
  else if(key == '2'){
    bugActive = 2;
  }
  else if(key == '3'){
    bugActive = 3;
  }
  if(key == '+'){
    if(bugActive < bugs.size()-1){
      bugActive ++;
    }
  }
  if(key == '-'){
    if(bugActive > 0){
      bugActive --;
    }
  }
  if(key == 'u'){
    output.flush(); 
   
  }
  if(key == 'b'){
    bugReproduction();
  }
  
}