class DNA {
  int name;
  int parent;
  float lifetime;
  float max_lifetime = 8000;
  float mutation = 0.01;
  
  float max_size = random(15, 40);
  float start_speed = random(0.5, 2);
  float max_speed = random(0.5, 5);
  float moveOnEat = random(0.1,0.2); // 0.99 to 0.6
  float antennaLength = random(0.5,3);
  float antennaSpread = random(0.1,1);
  float maxRotation = random(0,360);
  int max_children = int(random(1,4));
  int num_antenna = int(random(1,4));
  float jitters = random(1000, 20000); // the amount of time until the bug turns
  float reproductionPriority = random(0,1);
  
  DNA(int _name){
    name = _name;
  }
  
  void inherit(DNA dna1, DNA dna2){
    //printDNA(dna1, dna2);
     
    float chance1 = dna1.lifetime / (dna2.lifetime + dna1.lifetime);
    
    // MAX SIZE
    if(chance1 > random(0,1)){
      parent = dna1.name;
    }
    else{
      parent = dna2.name;
    }
    
    // MAX SIZE
    if(chance1 > random(0,1)){
      max_size = dna1.max_size + (dna1.max_size * random(mutation * -1, mutation));
    }
    else{
      max_size = dna2.max_size + (dna2.max_size * random(mutation * -1, mutation));
    }
    
    // START SPEED
    if(chance1 > random(0,1)){
      start_speed = dna1.start_speed + (dna1.start_speed * random(mutation * -1, mutation));
    }
    else{
      start_speed = dna2.start_speed + (dna2.start_speed * random(mutation * -1, mutation));
    }
    
    // MAX SPEED
    if(chance1 > random(0,1)){
      max_speed = dna1.max_speed + (dna1.max_speed * random(mutation * -1, mutation));
    }
    else{
      max_speed = dna2.max_speed + (dna2.max_speed * random(mutation * -1, mutation));
    }
    
    // MOVE ON EAT
    if(chance1 > random(0,1)){
      moveOnEat = dna1.moveOnEat + (dna1.moveOnEat * random(mutation * -1, mutation));
    }
    else{
      moveOnEat = dna2.moveOnEat + (dna2.moveOnEat * random(mutation * -1, mutation));
    }
    
    // ANTENNA LENGTH
    if(chance1 > random(0,1)){
      antennaLength = dna1.antennaLength + (dna1.antennaLength * random(mutation * -1, mutation));
    }
    else{
      antennaLength = dna2.antennaLength + (dna2.antennaLength * random(mutation * -1, mutation));
    }
    
    // ANTENNA SPREAD
    if(chance1 > random(0,1)){
      antennaSpread = dna1.antennaSpread + (dna1.antennaSpread * random(mutation * -1, mutation));
    }
    else{
      antennaSpread = dna2.antennaSpread + (dna2.antennaSpread * random(mutation * -1, mutation));
    }
    
    // MAX ROTATION
    if(chance1 > random(0,1)){
      maxRotation = dna1.maxRotation + (dna1.maxRotation * random(mutation * -1, mutation));
    }
    else{
      maxRotation = dna2.maxRotation + (dna2.maxRotation * random(mutation * -1, mutation));
    }
    
    // MAX LIFESPAN
    if(chance1 > random(0,1)){
      max_lifetime = dna1.max_lifetime + (dna1.max_lifetime * random(mutation * -1, mutation));
    }
    else{
      max_lifetime = dna2.max_lifetime + (dna2.max_lifetime * random(mutation * -1, mutation));
    }

  }
  
  void printDNA(DNA dna1, DNA dna2){
    println("#################################");
    println("___________________1________________2________________");
    println("lifetime       "+dna1.lifetime+"   |   "+dna2.lifetime);
    println("max_lifetime  "+dna1.max_lifetime+"   |   "+dna2.max_lifetime);
    println("max_size       "+dna1.max_size+"   |   "+dna2.max_size);
    println("max_speed      "+dna1.max_speed+"   |   "+dna2.max_speed);
    println("moveOnEat      "+dna1.moveOnEat+"   |   "+dna2.moveOnEat);
    println("antennaLength  "+dna1.antennaLength+"   |   "+dna2.antennaLength);
    println("antennaSpread  "+dna1.antennaSpread+"   |   "+dna2.antennaSpread);
    println("maxRotation  "+dna1.maxRotation+"   |   "+dna2.maxRotation);

    
  }
}