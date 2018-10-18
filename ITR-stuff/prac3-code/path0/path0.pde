/**
 * path0.pde
 * sklar/11-oct-2018
 * This program draws a 2D grid and a "robot" that navigates around the grid.
 **/

/**
 declare constants
 */
int DELTA = 25; // this is the size of a grid square in pixels
PVector A = new PVector( 0, 0 ); // coordinates of starting point (in grid coordinates)
PVector Z = new PVector( 0, 0 ); // coordinates of target point (in grid coordinates)
PVector R = new PVector( 0, 0 ); // coordinates of robot's current location (in grid coordinates)
PVector[] hood = new PVector[8]; // coordinates of neighbourhood around robot (in grid coordinates)
boolean moving = true; // this flag indicates if the robot is still moving to its target location


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
}


/**
 * mouseClicked()
 * This function sets the starting and ending points for a new path.
 */
void mouseClicked() {
  A.x = mouseX / DELTA;
  A.y = mouseY / DELTA;
  R = A.copy();
  setHood( R );
  Z = pickRandomPoint();
  moving = true;
}


/**
 * keyTyped()
 * This function moves the robot to the adjacent grid cell that is closest to its target location.
 */
void keyTyped() {
  int c;
  if ( moving ) {
    c = closestPoint();
    R = hood[c].copy();
    if (( R.x == Z.x ) && ( R.y == Z.y )) {
      moving = false;
      println( "done!" );
    } else {
      setHood( R );
      println( "moved robot!" );
    }
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
int closestPoint() {
  int c = 0;
  float cd = dist2Target
    ( hood[0] ), cd0;
  for ( int i=1; i<8; i++ ) {
    cd0 = dist2Target( hood[i] );
    if ( cd0 < cd ) {
      cd = cd0;
      c = i;
    }
  }
  return( c );
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


/**
 * drawHood()
 * This function shades in the grid cells surrounding the robot's cell.
 */
void drawHood() {
  for ( int i=0; i<8; i++ ) {
    drawGridCell( hood[i], #cccccc );
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
  for ( int i=0; i<width/DELTA; i++ ) {
    line( i*DELTA, 0, i*DELTA, height );
  }
  for ( int i=0; i<height/DELTA; i++ ) {
    line( 0, i*DELTA, width, i*DELTA );
  }
  // plot points on grid
  drawGridCell( A, #009900 ); // starting point
  drawGridCell( Z, #990000 ); // end point
  drawGridCell( R, #000000 ); // robot's current location
  if ( moving ) {
    drawHood(); // robot's neighbourhood
  }
  // draw line-of-sight line
  stroke( #000000 );
  line( (R.x+0.5)*DELTA, (R.y+0.5)*DELTA, (Z.x+0.5)*DELTA, (Z.y+0.5)*DELTA );
  // find closest point
  int c = closestPoint();
  drawGridCell( hood[c], #ffff00 );
}
