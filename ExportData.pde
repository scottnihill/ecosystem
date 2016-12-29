import java.io.*;

class ExportData{
  
  PrintWriter output;
  Table table;
  
  ExportData(String _name){
    output = createWriter(_name + "Data.txt");
    output.println("Name, Age, Max Age, Max Size, Max Speed, Indecisiveness, Max Rotation, Slow On Eat, Antenna Length, Antenna Spread");
  }
  
  void printData(Bug _bug){
    output.println(_bug.name + ", " +
                   _bug.lifetime + ", " +
                   _bug.max_lifetime + ", " +
                   _bug.max_size + ", " +
                   _bug.max_speed + ", " +
                   _bug.jitters + ", " +
                   _bug.maxRotation + ", " +
                   _bug.moveOnEat + ", " +
                   _bug.antennaLength + ", " +
                   _bug.antennaSpread + ", "
    );
  }
  
  void updateCSV(){
    print("EXPORTING CSV");
    output.flush(); 
    output.close();
  }
  
}