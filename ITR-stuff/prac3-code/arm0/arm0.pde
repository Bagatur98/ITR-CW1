/**
 * arm0.pde
 * sklar/10-oct-2018
 * This program draws a 1-segment arm in the middle of the window.
 **/

/**
 declare constants
 */
// coordinates of arm origin
float X = 0, Y = 0;
// length of arm segment
float L = 100;
// initial angle of arm
float THETA = 0;

// define a list of points for the arm joints.     
// note that we use homogeneous coordinates in 2D.
float P[][] = {{ X, Y, 1 }, { X+L, Y, 1 }}; 

// define offset values so that (0,0) is in the middle of the display window.
float X_OFFSET, Y_OFFSET;


/**
 setup()
 This function is called once, when the program starts up.
 **/
void setup() {
  size( 500, 500 );
  X_OFFSET = width / 2.0;
  Y_OFFSET = height / 2.0;
  strokeWeight( 4 );
  printArm();
} // end of setup()


/**
 printArm()
 */
void printArm() {
  for ( int i=0; i<2; i++ ) {
    println( "P", i, "=(", P[i][0], ",", P[i][1], ")" );
  }
  println( "THETA=", THETA );
} // end of printArm()


/**
 drawArm()
 This function draws the arm.
 **/
void drawArm() {
  stroke( #0000ff );
  line( P[0][0]+X_OFFSET, P[0][1]+Y_OFFSET, P[1][0]+X_OFFSET, P[1][1]+Y_OFFSET );
} // end of drawArm()


/**
 draw()
 This function draws the canvas. It is called once per frame.
 **/
void draw() {
  background( #cccccc );
  drawArm();
}
