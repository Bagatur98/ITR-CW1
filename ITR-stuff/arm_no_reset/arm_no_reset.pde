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
float L1 = 100;
float L2 = 75;
float L3 = 50;
// initial angle of arm
float THETA = 0;
float DR = 5;
float oldX;
float oldY;
// define a list of points for the arm joints.     
// note that we use homogeneous coordinates in 2D.
float P[][] = {{ X, Y, 1 }, { X+L1, Y, 1 },{X+L1+L2, Y, 1},{X+L1+L2+L3, Y, 1 }}; 
float[][] rotationMatrix = {{cos(radians(DR)), 1, 0}, {1, cos(radians(DR)), 0}, {0, 0, 1}};
float[][] translationMatrix = {{ 1, 0, 1 }, { 0, 1, 1 }, { 0, 0, 1 }};
// define offset values so that (0,0) is in the middle of the display window.
float X_OFFSET, Y_OFFSET;
int rotationC1 = 0;
int rotationC2 = 0;
int rotationC3 = 0;

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
  for ( int i=0; i<4; i++ ) {
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
  line( P[0][0]+X_OFFSET, P[0][1]+Y_OFFSET, P[1][0]+X_OFFSET, P[1][1]+Y_OFFSET);
  stroke(#ff03b8);
  line(P[1][0]+X_OFFSET, P[1][1]+Y_OFFSET, P[2][0]+X_OFFSET, P[2][1]+Y_OFFSET);
  stroke(#00ffd9);
  line(P[2][0]+X_OFFSET, P[2][1]+Y_OFFSET, P[3][0]+X_OFFSET, P[3][1]+Y_OFFSET);
} // end of drawArm()


/**
 draw()
 This function draws the canvas. It is called once per frame.
 **/
void draw() {
  background( #cccccc );
  drawArm();
}

void matrixMult( float[][] M1, float M2[][] , int q) {
  float[][] newM1 = {{ 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }}; 
  for ( int i=q; i<4; i++ ) {
    for ( int j=0; j<3; j++ ) {
      newM1[i][j] = (M1[i][0]*M2[j][0]) + (M1[i][1]*M2[j][1]) + (M1[i][2]*M2[j][2]);
    }
  }
  for ( int i=q; i<4; i++ ) {
    for ( int j=0; j<3; j++ ) {
      M1[i][j] = newM1[i][j];
    }
  }
} // end of matrixMult()

void keyPressed(){
  if(key == '1'){
    oldX = P[0][0];
    oldY = P[0][1];
    translationMatrix[0][2] = -oldX;
    translationMatrix[1][2] = -oldY;
    matrixMult(P, translationMatrix, 0);
    
    rotationMatrix[0][1] = -sin(radians(DR));
    rotationMatrix[1][0] = sin(radians(DR));
    matrixMult(P, rotationMatrix, 0);
    rotationC1++;
    
    translationMatrix[0][2] = oldX;
    translationMatrix[1][2] = oldY;
    matrixMult(P, translationMatrix, 0);
    printArm();
  }else if(key == 'Q' || key == 'q'){
    oldX = P[0][0];
    oldY = P[0][1];
    translationMatrix[0][2] = -oldX;
    translationMatrix[1][2] = -oldY;
    matrixMult(P, translationMatrix, 0);
    
    rotationMatrix[0][1] = sin(radians(DR));
    rotationMatrix[1][0] = -sin(radians(DR));
    matrixMult(P, rotationMatrix,0 );
    rotationC1--;
    
    translationMatrix[0][2] = oldX;
    translationMatrix[1][2] = oldY;
    matrixMult(P, translationMatrix, 0);
    printArm();
    
    
    
    
    
  }else if(key == '2'){
    oldX = P[1][0];
    oldY = P[1][1];
    translationMatrix[0][2] = -oldX;
    translationMatrix[1][2] = -oldY;
    matrixMult(P, translationMatrix, 1);
    
    rotationMatrix[0][1] = -sin(radians(DR));
    rotationMatrix[1][0] = sin(radians(DR));
    matrixMult(P, rotationMatrix, 1);
    rotationC2++;
    
    translationMatrix[0][2] = oldX;
    translationMatrix[1][2] = oldY;
    matrixMult(P, translationMatrix, 1);
    printArm();
  }else if(key == 'W' || key == 'w'){
    oldX = P[1][0];
    oldY = P[1][1];
    translationMatrix[0][2] = -oldX;
    translationMatrix[1][2] = -oldY;
    matrixMult(P, translationMatrix, 1);
    
    rotationMatrix[0][1] = sin(radians(DR));
    rotationMatrix[1][0] = -sin(radians(DR));
    matrixMult(P, rotationMatrix, 1);
    rotationC2--;
    
    translationMatrix[0][2] = oldX;
    translationMatrix[1][2] = oldY;
    matrixMult(P, translationMatrix, 1);
    printArm();
    
    
    
    
    
  }else if(key == '3'){
    oldX = P[2][0];
    oldY = P[2][1];
    translationMatrix[0][2] = -oldX;
    translationMatrix[1][2] = -oldY;
    matrixMult(P, translationMatrix, 2);
    
    rotationMatrix[0][1] = -sin(radians(DR));
    rotationMatrix[1][0] = sin(radians(DR));
    matrixMult(P, rotationMatrix, 2);
    rotationC3++;
    
    translationMatrix[0][2] = oldX;
    translationMatrix[1][2] = oldY;
    matrixMult(P, translationMatrix, 2);
    printArm();
  }else if(key == 'E' || key == 'e'){
    oldX = P[2][0];
    oldY = P[2][1];
    translationMatrix[0][2] = -oldX;
    translationMatrix[1][2] = -oldY;
    matrixMult(P, translationMatrix, 2);
    
    rotationMatrix[0][1] = sin(radians(DR));
    rotationMatrix[1][0] = -sin(radians(DR));
    matrixMult(P, rotationMatrix, 2);
    rotationC3--;
    
    translationMatrix[0][2] = oldX;
    translationMatrix[1][2] = oldY;
    matrixMult(P, translationMatrix, 2);
    printArm();
  }
}
