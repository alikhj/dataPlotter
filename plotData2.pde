//x and y coordinates that reference the dataTable
int dataTableX;
int dataTableY;
int dataTableZ;

float x, y, z;

float dataTableXValue;
float dataTableYValue;
String dataTableZValue;

//a switch to plot data only when all axes have values
boolean indicesAreDefined = false;
  
int canvasWidth = 1000;
int canvasHeight = 1000;
int canvasBorder = 100;

int topBorder = 50;
int columnHeaderXPos = 50;
int headerButtonWidth = 200;
int headerButtonHeight = 25;
int headerButtonXPos = columnHeaderXPos - 5;


//dataRows holds each row of csv data as an item in an array
String[] dataRows;

//dataTable emulates the data in a 2D array
String[][] dataTable; //String[i][j]

int numberOfColumns;
int numberOfRows;

//declare xlength and ylength


void setup(){
  
  background(255);
  
  size(canvasWidth, canvasHeight);
  //frameRate(10);
  smooth();
  
   
  //load all csv rows into dataRows
  dataRows = loadStrings("1000.csv");

  numberOfColumns = split(dataRows[0],',').length;
  numberOfRows = dataRows.length;
  
  //initialize dataTable
  //length is number of csv in first row,
  //height is number of dataRows
  dataTable = new String[numberOfColumns][numberOfRows];


  for(int y = 0; y < numberOfRows; y++){
   //separate csv values and store each csv in dataRow[y] in data Points[]
     String[] dataPoints = split(dataRows[y], ',');
     
     //transfer each dataPoint its corresponding location dataTable
     for(int x = 0; x < numberOfColumns; x++) {
       dataTable[x][y] = dataPoints[x];
     }//end for loop
 }//for loop
 
 println(numberOfColumns + "  " + numberOfRows);
  
  int columnHeaderYPos = topBorder;
  
  for(int x = 0; x < numberOfColumns; x++){
    
    String columnHeaderString = dataTable[x][0];
    
    int headerButtonYPos = columnHeaderYPos - 16;
    fill(200); noStroke();
    rect(headerButtonXPos, headerButtonYPos, headerButtonWidth, headerButtonHeight);
     
    fill(0);
    text(columnHeaderString, 50, columnHeaderYPos);
     
    columnHeaderYPos += 30;

  }//end for loop
 
 
} //end setup

void draw(){
  
  int columnHeaderYPos = topBorder;
  int headerButtonYPos = topBorder - 16;
  for(int i = 0; i < numberOfColumns; i++){
    
    String columnHeaderString = dataTable[i][0];
    
      if((mouseX > headerButtonXPos) && (mouseX < headerButtonXPos + headerButtonWidth) &&
           (mouseY > headerButtonYPos) && (mouseY < headerButtonYPos + headerButtonHeight) &&
            mousePressed && mouseButton == LEFT){
        dataTableY = i;
        fill(255);
        text(columnHeaderString, 50, columnHeaderYPos);
        fill(0);
                    
      }
      else if((mouseX > headerButtonXPos) && (mouseX < headerButtonXPos + headerButtonWidth) &&
               (mouseY > headerButtonYPos) && (mouseY < headerButtonYPos + headerButtonHeight) &&
                mousePressed && mouseButton == RIGHT){
        dataTableX = i;
        fill(255);
        text(columnHeaderString, 50, columnHeaderYPos);
        fill(0);
      }
      else if((mouseX > headerButtonXPos) && (mouseX < headerButtonXPos + headerButtonWidth) &&
              (mouseY > headerButtonYPos) && (mouseY < headerButtonYPos + headerButtonHeight) &&
               mousePressed && mouseButton == CENTER){
        dataTableZ = i;
        fill(255);
        text(columnHeaderString, 50, columnHeaderYPos);
        fill(0);
        
        
        indicesAreDefined = true;
      }
       
       columnHeaderYPos += 30;
       headerButtonYPos += 30;
     
     
   }//end for loop
   
   if(indicesAreDefined == true){
     background(255);
     //draw axes
     stroke(0);
     line(0, height/2, width, height/2);
     line(width/2, 0, width/2, height);
     //label axes
     fill(0);
     text(dataTable[dataTableX][0], (width/2) + 5, 25);
     text(dataTable[dataTableY][0], 25, (height/2) - 10);    
     
     float scaleFactorX = (width)/findMaximumValue(dataTableX);
     float scaleFactorY = (height)/findMaximumValue(dataTableY);
          
     //FOR RANK
     //scaleFactorX = 0.5;
     //scaleFactorY = 0.5;
      
     for(int i = 0; i < numberOfRows; i++) {
        
                   
        dataTableXValue = float(dataTable[dataTableX][i]);
        dataTableYValue = float(dataTable[dataTableY][i]);
        dataTableZValue = dataTable[dataTableZ][i];
        
          x = (dataTableXValue * scaleFactorX) + (width/2);
          y = (-dataTableYValue  * scaleFactorY) + (height/2);
          
       
        //String zLabelString = x + ", " + y;
        String zLabelString = dataTable[dataTableZ][0] + ": " + dataTableZValue;
        
        
        float distanceBetweenEllipseAndMouse = dist(x, y, mouseX, mouseY);
        
        ellipseMode(CENTER);
        
        if(distanceBetweenEllipseAndMouse < 7){ 
          fill(255);
          rect(x - 5, y - 40, 300, 25);
          fill(0);
          text(zLabelString, x, y - 20);
          fill(0);
          ellipse(x, y, 15, 15);

        }
        
        else {
         stroke(0); 
          fill(255);
          ellipse(x, y, 7, 7);
        }
  
     }
   }

} //end draw



void plotData(int xRef, int yRef){
 
  for(int i = 0; i < numberOfRows; i++) {

    float dataTableX = float(dataTable[xRef][i]);
    float dataTableY = float(dataTable[yRef][i]);
    
    x = dataTableX + (width/2);
    y = -dataTableY + (height/2);
    
    
    float distanceBetweenEllipseAndMouse = dist(x, y, mouseX, mouseY);
  
    ellipseMode(CENTER);
      
    if(distanceBetweenEllipseAndMouse < 7){ 
    fill(0);
    ellipse(x, y, 15, 15);
    }
  
    else { 
    fill(255);
    ellipse(x, y, 7, 7);
    }

    //ellipse(x, y, 7, 7);

    //draw axes
    stroke(0);
    line(0, height/2, width, height/2);
    line(width/2, 0, width/2, height);

  }
}

float findMaximumValue(int xRef){
  float tempArray[] = new float[numberOfRows];
  for (int i = 1; i < numberOfRows; i++){
    tempArray[i] = float(dataTable[xRef][i]);
     //println(tempArray[i]); 
  }
 
 float maximum = max(tempArray);
 //println(max(tempArray));
 return maximum;
  
}

boolean isMinimumLessThanZero(int xRef){
  float tempArray[] = new float[numberOfRows];
  for (int i = 1; i < numberOfRows; i++){
    tempArray[i] = float(dataTable[xRef][i]);
     //println(tempArray[i]); 
  }
 
 if(min(tempArray) < 0) {return true;}
 
 return false;
 
}
