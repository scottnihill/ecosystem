class Stats{
  Boolean show = false;
  int value = 0;
  int timer = 0;
  String displayType = "na";
  int xpos = 20;
  int ypos = 100;
  
  Stats(){
    
  }
  
  void display(Bug b, int n, int worldTime, int bugsSpawned){
    
    if(show){
      noStroke();
      fill(240, 240, 240, 120);
      rect(0, 0, width, height);
      
      PFont f;
      f = createFont("Arial",8,true);
      textFont(f,12);
      fill(0);
      
      if(displayType == "w"){
        // World stats
        // ---------------------
        text("WORLD                             stat   ", 10, 20);
        text("===========================", 10, 35);
        ypos = 50;
        displayText("Time", clockDisplay(worldTime));
        displayText("Bugs Spawned", str(bugsSpawned));
        
      }
      else if(displayType == "a"){
        text("BUG         #" + n + "                  stat   ", 10, 20);
        text("===========================", 10, 35);
        ypos = 50;
        displayText("Lifetime", clockDisplay(int(b.lifetime)) + " / " + clockDisplay(int(b.max_lifetime)));
        displayText("Size", nf(int(b.size), 2) + " / " +nf(int(b.max_size),2));
        displayText("Speed", nf(mag(b.velocity.x, b.velocity.y), 1, 2) + " / " + nf(b.max_speed, 1, 2) + " (start " + nf(b.start_speed, 1, 2)+")");
        displayText("Steering", str(b.steering));
        displayText("Indecisiveness",  nf(b.timeSinceLastSteer, 1) + " / " + nf(int(b.jitters),1));
        displayText("Max Rotation", nf(int(b.maxRotation), 3));
        displayText("Slow On Eat", nf(b.moveOnEat, 1, 2) + " * Speed");
        displayText("Antenna * " + str(b.num_antenna), "Length: " + nf(b.antennaLength, 1, 2) +"  Spread: "+nf(b.antennaSpread, 1, 2)); 
        
        displayText("Fertile", b.fertile + " (" + nf(b.reproductionPriority, 1, 2) +")");
        displayText("Max Children", str(b.max_children));
      }
    }
  } 
  
  void displayText(String _title, String _stat){
    PFont f;
    f = createFont("Arial",8,true);
    textFont(f,12);
    fill(0);
    text(_title, xpos, ypos);
    text(_stat, xpos + 100, ypos);
    ypos += 20;      
  }
  
  void showHide(String _key){
    
    if(displayType == _key){
      if(show){
        show = false;
      }
      else{
        println("JOKER");
        show = true; 
      }
    }
    else{
      displayType = _key;
      if(!show){
        show = true;
      }
    }
  }
  
  String clockDisplay(int input){
    String timeDisplay;
    int elapsedSec = round(input/30);
    int min = round(elapsedSec / 60);
    int sec = elapsedSec - min * 60;
    if(sec < 10){
      timeDisplay = min + " : 0" + sec;
    }
    else{
      timeDisplay = min + " : " + sec;  
    }
    return timeDisplay;
  }
}