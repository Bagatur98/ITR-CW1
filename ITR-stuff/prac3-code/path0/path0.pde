/**
 * path0.pde
 * sklar/11-oct-2018
 * This program draws a 2D grid and a "robot" that navigates around the grid.
 **/
import java.util.Arrays;
/**
 declare constants
 */
int n;
int detectedIndex = 0;
int DELTA = 25;                  // this is the size of a grid square in pixels
PVector A = new PVector( 0, 0 ); // coordinates of starting point (in grid coordinates)
PVector Z = new PVector( 0, 0 ); // coordinates of target point (in grid coordinates)
PVector R = new PVector( 0, 0 ); // coordinates of robot's current location (in grid coordinates)
PVector[] detected;              //coordinates of detected obstacles
PVector[] obstacles;             //coordinates of obstacles
PVector[] hood = new PVector[8]; // coordinates of neighbourhood around robot (in grid coordinates)
PVector[] movable = new PVector[4];
boolean moving = true;           // this flag indicates if the robot is still moving to its target location
boolean starting = true;
boolean found = false;

/**
 setup()
 This function is called once, when the program starts up.
 **/
void setup() {
  size( 500, 500 );
  background( #ffffff );
  for ( int i=0; i<8; i++ ) {
    hood[i] = new PVector( 0, 0 );
  }
  for(int i = 0; i < 4; i++){
    movable[i] = new PVector(0, 0);
  }
}


/**
 * mouseClicked()
 * This function sets the starting and ending points for a new path.
 */
void mouseClicked() {
  n = int(random(100));
  detectedIndex = 0;
  obstacles = new PVector[n];
  detected = new PVector[n];
  starting = true;
  A.x = mouseX / DELTA;
  A.y = mouseY / DELTA;
  R = A.copy();
  setHood( R );
  setMovable(R);
  Z = pickRandomPoint();
  moving = true;
  populate();
  scan();
  System.out.println("generated " + n + " obstacles");
}


/**
 * keyTyped()
 * This function moves the robot to the adjacent grid cell that is closest to its target location.
 */
void keyTyped() {
  int m;
  if ( moving ) {
    m = closestPointM();
    move(m);
    scan();
  }
}



/**
 * pickRandomPoint()
 * This function picks a random point within the grid and returns it.
 */
PVector pickRandomPoint() {
  PVector P = new PVector();
  P.x = int( random( width/DELTA ));
  P.y = int( random( height/DELTA ));
  return( P );
}


/**
 * dist2Target()
 * This function computes the distance from the argument point (p) to the robot's target (Z).
 * The computed distance value is returned by the function.
 */
float dist2Target( PVector p ) {
  float d;
  // compute distance from q to p
  d = sqrt( sq( p.x - Z.x ) + sq( p.y - Z.y ));
  return( d );
}


/**
 * closestPoint()
 * This function finds the point in the robot's neighbourhood that is closest to the robot's target (Z).
 * The function returns the index in the array of neighbourhood points of the closet point to Z.
 */
 int closestPointH(){
  int c = 0;
  int m = 0;
  float cd = dist2Target
    ( hood[0] ), cd0;
  for ( int i=1; i<8; i++ ) {
    cd0 = dist2Target( hood[i] );
    if ( cd0 < cd ) {
      cd = cd0;
      c = i;
    }
  }
  return c;
}
 
 
int closestPointM() {
  int c = 0;
  int m = 0;
  float cd = dist2Target
    ( hood[0] ), cd0;
  for ( int i=1; i<8; i++ ) {
    cd0 = dist2Target( hood[i] );
    if ( cd0 < cd ) {
      cd = cd0;
      c = i;
    }
  }
  switch(c){
    case 1:
      m = 0;
      break;
    case 4:
      m = 1;
      break;
    case 6:
      m = 2;
      break;
    case 3:
      m = 3;
      break;
    case 0:
      if((R.x - Z.x) > (R.y - Z.y)){
        m = 3;
      }else{
        m = 0; 
      }
      break;
    case 2:
      if((Z.x - R.x) > (R.y - Z.y)){
        m = 1;
      }else{
        m = 0; 
      }
      break;
    case 5:
      if((R.x - Z.x) > (Z.y - R.y)){
        m = 3;
      }else{
        m = 2; 
      }
      break;
    case 7:
      if((Z.x - R.x) > (Z.y - R.y)){
        m = 1;
      }else{
        m = 2; 
      }
      break;
    
  }
  return( m );
}



/**
 * drawGridCell()
 * This function fills in the grid cell corresponding to the argument point "p", with the argument colour.
 */
void drawGridCell( PVector p, int colour ) {
  fill( colour );
  rect( p.x*DELTA, p.y*DELTA, DELTA, DELTA );
}


/**
 * setHood()
 * This function sets the robot's neighbourhood array of points, in grid coordinates.
 */
void setHood( PVector p ) {
  hood[0].set( p.x-1, p.y-1 );
  hood[1].set( p.x, p.y-1 );
  hood[2].set( p.x+1, p.y-1 );
  hood[3].set( p.x-1, p.y );
  hood[4].set( p.x+1, p.y );
  hood[5].set( p.x-1, p.y+1 );
  hood[6].set( p.x, p.y+1 );
  hood[7].set( p.x+1, p.y+1 );
}

void setMovable(PVector p){
  movable[0].set(p.x, p.y-1);
  movable[1].set(p.x+1, p.y);
  movable[2].set(p.x, p.y+1);
  movable[3].set(p.x-1, p.y);
}

/**
 * drawHood()
 * This function shades in the grid cells surrounding the robot's cell.
 */
void drawHood() {
  for ( int i=0; i<8; i++ ) {
    drawGridCell( hood[i], #cccccc );
  }
}

void populate(){
  if(starting){ 
    starting = false;
    for(int i = 0; i< n; i++){
      PVector obst = pickRandomPoint();
      PVector check1 = A.copy();
      PVector check2 = Z.copy();
      PVector check3 = R.copy();
      if(obst.equals(check1) || obst.equals(check2) || obst.equals(check3)){
        i--;
      }else{
        obstacles[i] = obst;
        drawGridCell(obst, #000099);
      }
    }
  }
}

void scan(){
  boolean alreadyIn = false;
  for(int i = 0; i < 8; i++){
    for(int yeet = 0; yeet < n; yeet++){
      if(obstacles[yeet].equals(hood[i])){
        for(int swag = 0; swag < detectedIndex; swag++){
          if(obstacles[yeet].equals(detected[swag])){
            alreadyIn = true;
          }
        }        
        if(!alreadyIn){
          detected[detectedIndex] = obstacles[yeet];
          detectedIndex++;
          found = true;
        }
      }
    }
  }
}

void move(int m){
  boolean canMove = true;
  int h = closestPointH();
  //System.out.println(m);
  for(int i = 0; i < n; i++){
     if(movable[m].equals(obstacles[i])){
       canMove = false;
       if(m == 0){
         switch(h){
           case 0:
             move(3);
             break;
           case 1:
             move(3);
             break;
           case 2:
             move(1);
             break;
         }
       }else if(m == 1){
         switch(h){
           case 2:
             move(0);
             break;
           case 4:
             move(0);
             break;
           case 7:
             move(2);
             break;
         }
       }else if(m == 2){
         switch(h){
           case 5:
             move(3);
             break;
           case 6:
             move(3);
             break;
           case 7:
             move(1);
             break;
         }
       }else if( m == 3){
         switch(h){
           case 0:
             move(0);
             break;
           case 3:
             move(0);
             break;
           case 5:
             move(2);
             break;
         }
       }
       return;
     }
  }
  if(canMove){
    R = movable[m].copy();
    if (R.equals(Z)) {
      moving = false;
      println( "done!" );
    } else {
      setHood( R );
      setMovable(R);
      println( "moved robot!" );
    }
  }
}

/**
 draw()
 This function draws the canvas. It is called once per frame.
 **/
void draw() {
  background( #ffffff );
  // draw grid
  stroke( #999999 );
  strokeWeight(1);
  for ( int i=0; i<width/DELTA; i++ ) {
    line( i*DELTA, 0, i*DELTA, height );
  }
  for ( int i=0; i<height/DELTA; i++ ) {
    line( 0, i*DELTA, width, i*DELTA );
  }
  if ( moving ) {
    drawHood(); // robot's neighbourhood
  }
  
   // plot points on grid
  drawGridCell( A, #009900 ); // starting point
  drawGridCell( Z, #990000 ); // end point
  drawGridCell( R, #000000 ); // robot's current location
  
  if(!starting){
    for(int i = 0; i < n; i++){
      drawGridCell(obstacles[i], #000099);
    }
  }
  
    for(int i = 0; i < n; i++){
      if(detected[i] !=null){
        //drawGridCell(detected[i], #990099);
        stroke(#ff0000);
        strokeWeight(4);
        line(detected[i].x*DELTA + 3, detected[i].y*DELTA + 3, detected[i].x*DELTA + DELTA - 3, detected[i].y*DELTA + DELTA - 3);
        line(detected[i].x*DELTA + DELTA - 3, detected[i].y*DELTA + 3, detected[i].x*DELTA + 3, detected[i].y*DELTA + DELTA - 3);
      }
    }
    strokeWeight(1);
    stroke( #000000 );
  // find closest point
  int c = closestPointM();
  drawGridCell( movable[c], #ffff00 );
  // draw line-of-sight line
  line( (R.x+0.5)*DELTA, (R.y+0.5)*DELTA, (Z.x+0.5)*DELTA, (Z.y+0.5)*DELTA );
}
