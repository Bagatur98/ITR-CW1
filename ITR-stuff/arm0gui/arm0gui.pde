/** //<>//
 * arm0gui.pde
 * sklar/12-oct-2018
 * This program draws a 1-segment arm in the middle of the window and includes GUI elements for user input.
 **/
 

/**
 import external library
 see: http://www.sojamo.de/libraries/controlP5/
 */
import controlP5.*;
String textValue = "";


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
float THETA1 = 0;
float THETA2 = 0;
float THETA3 = 0;
float DR;
// define a list of points for the arm joints.     
// note that we use homogeneous coordinates in 2D.
float P[][] = {{ X, Y, 1 }, { X+L1, Y, 1 }, {X+L1+L2, Y, 1 }, {X+L1+L2+L3, Y, 1 }}; 
float[][] rotationMatrix = {{cos(radians(DR)), 1, 0}, {1, cos(radians(DR)), 0}, {0, 0, 1}};
float[][] translationMatrix = {{ 1, 0, 1 }, { 0, 1, 1 }, { 0, 0, 1 }};
// define offset values so that (0,0) is in the middle of the display window.
float X_OFFSET, Y_OFFSET;

// define an object for the GUI (a ControlP5 object) and various GUI elements
ControlP5 cp5;
Textlabel x0value, y0value, theta0value, theta1value, theta2value, x1value, y1value, x2value, y2value, x3value, y3value;
Textlabel theta1label, theta2label, x2label, y2label, x3label, y3label;
Textfield x1input, y1input, x2input, y2input, x3input, y3input, theta0input, theta1input, theta2input;
Button FW2, FW3;
float x1, y1,x2, y2, x3, y3, theta0, theta1, theta2;

// define a flag to indicate when GUI elements have been initialised
boolean init = false;
int numberOfLines = 0;

/**
 setup()
 This function is called once, when the program starts up.
 **/
void setup() {
  size( 520, 590 );
  X_OFFSET = 260;
  Y_OFFSET = 330;
  
  noStroke();
  // create GUI object
  cp5 = new ControlP5( this );
  
  
  // create buttons
    cp5.addButton( "ONE_LINK")
    .setValue( 0 )
    .setPosition( 10, 10 )
    .setSize( 50, 10 );
    cp5.addButton( "TWO_LINK")
    .setValue( 0 )
    .setPosition( 70, 10 )
    .setSize( 50, 10 );
    cp5.addButton( "THREE_LINK")
    .setValue( 0 )
    .setPosition( 130, 10 )
    .setSize( 50, 10 );
    cp5.addButton( "FORWARD_1")
    .setValue( 0 )
    .setPosition( 190, 10 )
    .setSize( 50, 10 );
  FW2 = cp5.addButton( "FORWARD_2")
    .setValue( 0 )
    .setPosition( 250, 10 )
    .setSize( 50, 10 );
  FW3 = cp5.addButton( "FORWARD_3")
    .setValue( 0 )
    .setPosition( 310, 10 )
    .setSize( 50, 10 );
  cp5.addButton( "INVERSE")
    .setValue( 0 )
    .setPosition( 370, 10 )
    .setSize( 50, 10 );
  cp5.addButton("RESET")
    .setValue(0)
    .setPosition(430, 10)
    .setSize(50, 10);
    
    
  cp5.addTextlabel( "x0label" )
    .setText( "X0=" )
    .setPosition( 10, 30 );
  cp5.addTextlabel( "x0value" )
    .setPosition( 30, 30 )
    .setText( "0" )
    .setColor( #000000 );
  cp5.addTextlabel( "y0label" )
    .setText( "Y0=" )
    .setPosition( 90, 30 );
  cp5.addTextlabel( "y0value" )
    .setPosition( 110, 30 )
    .setText( "0" )
    .setColor( #000000 );
    
    
 
  // create P1 labels and values
  cp5.addTextlabel( "X1label" )
    .setText( "X1=" )
    .setPosition( 10, 40 );
  x1value = cp5.addTextlabel( "x1value" )
    .setPosition( 30, 40 )
    .setText( "0" )
    .setColor( #000000 );
  x1input = cp5.addTextfield( "x1input" )
    .setPosition( 30, 40 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
  cp5.addTextlabel( "Y1label" )
    .setText( "Y1=" )
    .setPosition( 90, 40 );
  y1value = cp5.addTextlabel( "y1value" )
    .setPosition( 110, 40 )
    .setText( "0" )
    .setColor( #000000 );
  y1input = cp5.addTextfield( "y1input" )
    .setPosition( 110, 40 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
    
    
     // create P2 labels and values
  x2label = cp5.addTextlabel( "X2label" )
    .setText( "X2=" )
    .setPosition( 10, 50 );
  x2value = cp5.addTextlabel( "x2value" )
    .setPosition( 30, 50 )
    .setText( "0" )
    .setColor( #000000 );
  x2input = cp5.addTextfield( "x2input" )
    .setPosition( 30, 50 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
  y2label = cp5.addTextlabel( "Y2label" )
    .setText( "Y2=" )
    .setPosition( 90, 50 );
  y2value = cp5.addTextlabel( "y2value" )
    .setPosition( 110, 50 )
    .setText( "0" )
    .setColor( #000000 );
  y2input = cp5.addTextfield( "y2input" )
    .setPosition( 110, 50 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
    
    
    // create P3 labels and values
  x3label = cp5.addTextlabel( "X3label" )
    .setText( "X3=" )
    .setPosition( 10, 60 );
  x3value = cp5.addTextlabel( "x3value" )
    .setPosition( 30, 60 )
    .setText( "0" )
    .setColor( #000000 );
  x3input = cp5.addTextfield( "x3input" )
    .setPosition( 30, 60 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
  y3label = cp5.addTextlabel( "Y3label" )
    .setText( "Y3=" )
    .setPosition( 90, 60 );
  y3value = cp5.addTextlabel( "y3value" )
    .setPosition( 110, 60 )
    .setText( "0" )
    .setColor( #000000 );
  y3input = cp5.addTextfield( "y3input" )
    .setPosition( 110, 60 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
    
    cp5.addTextlabel( "theta0label" )
    .setText( "theta0=" )
    .setPosition( 170, 30 );
  theta0value = cp5.addTextlabel( "theta0value" )
    .setPosition( 210, 30 )
    .setText( "0" )
    .setColor( #000000 );
  theta0input = cp5.addTextfield( "theta0input" )
    .setPosition( 210, 30 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
    
    
    theta1label = cp5.addTextlabel( "theta1label" )
    .setText( "theta1=" )
    .setPosition( 170, 40 );
  theta1value = cp5.addTextlabel( "theta1value" )
    .setPosition( 210, 40 )
    .setText( "0" )
    .setColor( #000000 );
  theta1input = cp5.addTextfield( "theta1input" )
    .setPosition( 210, 40 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
    
    
    theta2label = cp5.addTextlabel( "theta2label" )
    .setText( "theta2=" )
    .setPosition( 170, 50 );
  theta2value = cp5.addTextlabel( "theta2value" )
    .setPosition( 210, 50 )
    .setText( "0" )
    .setColor( #000000 );
  theta2input = cp5.addTextfield( "theta2input" )
    .setPosition( 210, 50 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
} // end of setup()

void matrixMult( float[][] M1, float[][] M2, int q) {
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


void loseFocus(){
  x1input.setFocus( false );
  x1input.setVisible( false );
  x1value.setVisible( true );
  x2input.setFocus( false );
  x2input.setVisible( false );
  x2value.setVisible( true );
  x3input.setFocus( false );
  x3input.setVisible( false );
  x3value.setVisible( true );
  y1input.setFocus( false );
  y1input.setVisible( false );
  y1value.setVisible( true );
  y2input.setFocus( false );
  y2input.setVisible( false );
  y2value.setVisible( true );
  y3input.setFocus( false );
  y3input.setVisible( false );
  y3value.setVisible( true );
  theta0input.setFocus( false );
  theta0input.setVisible( false );
  theta0value.setVisible( true );
  theta1input.setFocus( false );
  theta1input.setVisible( false );
  theta1value.setVisible( true );
  theta2input.setFocus( false );
  theta2input.setVisible( false );
  theta2value.setVisible( true );
}


/**
 drawArm()
 This function draws the arm.
 **/
 void drawArm1() {
   numberOfLines = 1;
   
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
  
 /* x1value.setText( str( P[1][0] ));
  y1value.setText( str( P[1][1] ));
  x2value.setText( str( P[2][0] ));
  y2value.setText( str( P[2][1] ));
  x3value.setText( str( P[3][0] ));
  y3value.setText( str( P[3][1] ));
 */ 
 
  x2label.setVisible(false);
  x2value.setVisible(false);
  y2label.setVisible(false);
  y2value.setVisible(false);
  x3label.setVisible(false);
  x3value.setVisible(false);
  y3label.setVisible(false);
  y3value.setVisible(false);
  theta1label.setVisible(false);
  theta1value.setVisible(false);
  theta2label.setVisible(false);
  theta2value.setVisible(false);
 }
 
 void drawArm2() {
   
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
  stroke(#00ff00);
  line(P[1][0]+X_OFFSET, Y_OFFSET-P[1][1], P[2][0]+X_OFFSET, Y_OFFSET-P[2][1]);
  
/*  x1value.setText( str( P[1][0] ));
  y1value.setText( str( P[1][1] ));
  x2value.setText( str( P[2][0] ));
  y2value.setText( str( P[2][1] ));
  x3value.setText( str( P[3][0] ));
  y3value.setText( str( P[3][1] ));
*/
  if(numberOfLines != 2){
    x2label.setVisible(true);
    x2value.setVisible(true);
    y2label.setVisible(true);
    y2value.setVisible(true);
    x3label.setVisible(false);
    x3value.setVisible(false);
    y3label.setVisible(false);
    y3value.setVisible(false);
    theta1label.setVisible(true);
    theta1value.setVisible(true);
    theta2label.setVisible(false);
    theta2value.setVisible(false);
  }
  numberOfLines = 2;
}
 
void drawArm3() {

  
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
  stroke(#00ff00);
  line(P[1][0]+X_OFFSET, Y_OFFSET-P[1][1], P[2][0]+X_OFFSET, Y_OFFSET-P[2][1]);
  stroke(#ff0000);
  line(P[2][0]+X_OFFSET, Y_OFFSET-P[2][1], P[3][0]+X_OFFSET, Y_OFFSET-P[3][1]);
  
 /* x1value.setText( str( P[1][0] ));
  y1value.setText( str( P[1][1] ));
  x2value.setText( str( P[2][0] ));
  y2value.setText( str( P[2][1] ));
  x3value.setText( str( P[3][0] ));
  y3value.setText( str( P[3][1] ));
  */
  if(numberOfLines != 3){
    x2label.setVisible(true);
    x2value.setVisible(true);
    y2label.setVisible(true);
    y2value.setVisible(true);
    x3label.setVisible(true);
    x3value.setVisible(true);
    y3label.setVisible(true);
    y3value.setVisible(true);
    theta1label.setVisible(true);
    theta1value.setVisible(true);
    theta2label.setVisible(true);
    theta2value.setVisible(true);
  }
    numberOfLines = 3;
} // end of drawArm()

void reset(){
  loseFocus();
  if(numberOfLines != 0){
    P[0][0] = 0;
    P[0][1] = 0;
    P[1][0] = 100;
    P[1][1] = 0;
    P[2][0] = 175;
    P[2][1] = 0;
    P[3][0] = 225;
    P[3][1] = 0;
    theta0 = 0;
    theta1 = 0;
    theta2 = 0;
    theta0value.setText(str(0));
    theta1value.setText(str(0));
    theta2value.setText(str(0));
    
    
    if(numberOfLines == 1){
      drawArm1(); 
    }else if(numberOfLines == 2){
      drawArm2();
    }else if(numberOfLines == 3){
      drawArm3(); 
    }
  }
  
  
}
/**
 controlEvent()
 This is the main event handler for ControlP5 objects.
 */
public void controlEvent( ControlEvent theEvent ) {
  if ( theEvent.isAssignableFrom( Textfield.class )) {
    if ( theEvent.getStringValue().length() > 0 ) {
      println( "controlEvent: accessing a string from controller '" +
        theEvent.getName() + "': " + theEvent.getStringValue() );
      if ( theEvent.getName() == "x1input" ) {
        x1 = float( theEvent.getStringValue() );
        if ( Float.isNaN( x1 )) {
          println( "ERROR in x1 value" );
          x1input.setFocus( false );
          x1input.setVisible( false );
          x1value.setVisible( true );
        } else {
          x1input.setFocus( false );
          x1input.setVisible( false );
          x1value.setVisible( true );
          x1value.setText( str( x1 ));
          y1value.setVisible( false );
          y1input.setVisible( true );
          y1input.setFocus( true );
        }
      } else if ( theEvent.getName() == "y1input" ) {
        y1 = float( theEvent.getStringValue() );
        if ( Float.isNaN( y1 )) {
          println( "ERROR in y1 value" );
          y1input.setFocus( false );
          y1input.setVisible( false );
          y1value.setVisible( true );
        }else{
          y1input.setFocus( false );
          y1input.setVisible( false );
          y1value.setVisible( true );
          y1value.setText( str( y1 ));

          // compute THETA --> Inverse Kinematics!!
          THETA1 = degrees( atan(y1 / x1));
          
          // set P1 from user
          float currentTheta = theta0;
          if(currentTheta < THETA1){
            
            rotationMatrix[0][0] = cos(radians(THETA1 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA1 - currentTheta));
            rotationMatrix[0][1] = -sin(radians(THETA1 - currentTheta));
            rotationMatrix[1][0] = sin(radians(THETA1 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA1));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA1));
            rotationMatrix[0][1] = sin(radians(currentTheta - THETA1));
            rotationMatrix[1][0] = -sin(radians(currentTheta - THETA1));
          }
          
          matrixMult(P, rotationMatrix, 1);
          
          translationMatrix[0][2] = x1 - P[1][0];
          translationMatrix[1][2] = y1 - P[1][1];
          matrixMult(P, translationMatrix, 1);
          
          // set gui element with computed value
          theta0value.setText( str( THETA1 ));
          theta0 = THETA1;
          if(numberOfLines > 1){
            x2value.setVisible( false );
            x2input.setVisible( true );
            x2input.setFocus( true );
          }
        }
      }else if ( theEvent.getName() == "x2input" ) {
        x2 = float( theEvent.getStringValue() );
        if ( Float.isNaN( x2 )) {
          println( "ERROR in x2 value" );
          x2input.setFocus( false );
          x2input.setVisible( false );
          x2value.setVisible( true );
        } else {
          x2input.setFocus( false );
          x2input.setVisible( false );
          x2value.setVisible( true );
          x2value.setText( str( x2 ));
          y2value.setVisible( false );
          y2input.setVisible( true );
          y2input.setFocus( true );
        }
      } else if ( theEvent.getName() == "y2input" ) {
        y2 = float( theEvent.getStringValue() );
        if ( Float.isNaN( y2 )) {
          println( "ERROR in y2 value" );
          y2input.setFocus( false );
          y2input.setVisible( false );
          y2value.setVisible( true );
        }else {
          y2input.setFocus( false );
          y2input.setVisible( false );
          y2value.setVisible( true );
          y2value.setText( str( y2 ));
          // compute THETA --> Inverse Kinematics!!
          float deltaX = x2 - P[1][0];
          float deltaY = y2 - P[1][1];
          if(deltaX == 0 && deltaY == 0){
            THETA2 = 0;
          }else{
            THETA2 = degrees( atan( deltaY / deltaX)) - theta0;      //TWO PISSOBILITES FOR ANGLE : X AND X+180
          }
          System.out.println("x2 " +x2 + ", y2 " + y2);
          System.out.println("p[1][0] " + P[1][0] + ", P[1][1] " + P[1][1]);
;          // set P2 from user
          float currentTheta = theta1;
          float oldX = P[1][0];
          float oldY = P[1][1];
          translationMatrix[0][2] = -oldX;
          translationMatrix[1][2] = -oldY;
          matrixMult(P, translationMatrix, 1);
          if(currentTheta < THETA2){            //CHECK FOR X AND STORE COORDINATES
            
            rotationMatrix[0][0] = cos(radians(THETA2 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA2 - currentTheta));
            rotationMatrix[0][1] = -sin(radians(THETA2 - currentTheta));
            rotationMatrix[1][0] = sin(radians(THETA2 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA2));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA2));
            rotationMatrix[0][1] = sin(radians(currentTheta - THETA2));
            rotationMatrix[1][0] = -sin(radians(currentTheta - THETA2));
          }
          
          matrixMult(P, rotationMatrix, 1);
          
           translationMatrix[0][2] = oldX;
          translationMatrix[1][2] = oldY;
          matrixMult(P, translationMatrix, 1);
          
          float deltaX1 = abs(x2 - P[2][0]);
          float deltaY1 = abs(y2 - P[2][1]);
          
          translationMatrix[0][2] = -oldX;
          translationMatrix[1][2] = -oldY;
          matrixMult(P, translationMatrix, 1);
          
          if(currentTheta < THETA2){            //CHECK FOR X+180 AND STORE COORDINATES
            
            rotationMatrix[0][0] = cos(radians(THETA2 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA2 - currentTheta));
            rotationMatrix[0][1] = sin(radians(THETA2 - currentTheta));
            rotationMatrix[1][0] = -sin(radians(THETA2 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA2));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA2));
            rotationMatrix[0][1] = -sin(radians(currentTheta - THETA2));
            rotationMatrix[1][0] = sin(radians(currentTheta - THETA2));
          }
          
          matrixMult(P, rotationMatrix, 1);
          
           translationMatrix[0][2] = oldX;
          translationMatrix[1][2] = oldY;
          matrixMult(P, translationMatrix, 1);
          
          float THETA2_2 = THETA2 + 180;
          
          translationMatrix[0][2] = -oldX;
          translationMatrix[1][2] = -oldY;
          matrixMult(P, translationMatrix, 1);
          
          if(currentTheta < THETA2){            //CHECK FOR X+180 AND STORE COORDINATES
            
            rotationMatrix[0][0] = cos(radians(THETA2_2 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA2_2 - currentTheta));
            rotationMatrix[0][1] = -sin(radians(THETA2_2 - currentTheta));
            rotationMatrix[1][0] = sin(radians(THETA2_2 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA2_2));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA2_2));
            rotationMatrix[0][1] = sin(radians(currentTheta - THETA2_2));
            rotationMatrix[1][0] = -sin(radians(currentTheta - THETA2_2));
          }
          
          matrixMult(P, rotationMatrix, 1);
          
           translationMatrix[0][2] = oldX;
          translationMatrix[1][2] = oldY;
          matrixMult(P, translationMatrix, 1);
          
          float deltaX2 = abs(x2 - P[2][0]);
          float deltaY2 = abs(y2 - P[2][1]);
          
          if(deltaX1 > deltaX2 || deltaY1 > deltaY2){      //COMPARE BOTH RESULTS AND PICK THE CORRECT ONE
            THETA2 = THETA2_2;
          }
          
          translationMatrix[0][2] = x2 - P[2][0];
          translationMatrix[1][2] = y2 - P[2][1];
          matrixMult(P, translationMatrix, 2);
          
          
          // set gui element with computed value
          theta1value.setText( str( THETA2 ));
          theta1 = THETA2;
          if(numberOfLines > 2){
            x3value.setVisible( false );
            x3input.setVisible( true );
            x3input.setFocus( true );
          }
        }
      }else if ( theEvent.getName() == "x3input" ) {
        x3 = float( theEvent.getStringValue() );
        if ( Float.isNaN( x3 )) {
          println( "ERROR in x3 value" );
          x3input.setFocus( false );
          x3input.setVisible( false );
          x3value.setVisible( true );
        } else {
          x3input.setFocus( false );
          x3input.setVisible( false );
          x3value.setVisible( true );
          x3value.setText( str( x3 ));
          y3value.setVisible( false );
          y3input.setVisible( true );
          y3input.setFocus( true );
        }
      } else if ( theEvent.getName() == "y3input" ) {
        y3 = float( theEvent.getStringValue() );
        if ( Float.isNaN( y3 )) {
          println( "ERROR in y3 value" );
        } else{
          y3input.setFocus( false );
          y3input.setVisible( false );
          y3value.setVisible( true );
          y3value.setText( str( y3 ));
          
          // compute THETA --> Inverse Kinematics!!
          float deltaX = x3 - P[2][0];
          float deltaY = y3 - P[2][1];
          if(deltaX ==0 && deltaY ==0){
            THETA3 = 0;
          }else{
            THETA3 = degrees( atan( deltaY / deltaX)) - theta0 - theta1; //THERE ARE 2 POSSIBLE ANGLES BECAUSE ATAN IS NOT 100% TRUE
          }
;         // set P2 from user
          float currentTheta = theta2;
          float oldX = P[2][0];
          float oldY = P[2][1];
          translationMatrix[0][2] = -oldX;
          translationMatrix[1][2] = -oldY;
          matrixMult(P, translationMatrix, 2); //TEST FIRST ANGLE AND STORE THE COORDINATES OF THE ROTATED POINTS
          if(currentTheta < THETA3){
            
            rotationMatrix[0][0] = cos(radians(THETA3 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA3 - currentTheta));
            rotationMatrix[0][1] = -sin(radians(THETA3 - currentTheta));
            rotationMatrix[1][0] = sin(radians(THETA3 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA3));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA3));
            rotationMatrix[0][1] = sin(radians(currentTheta - THETA3));
            rotationMatrix[1][0] = -sin(radians(currentTheta - THETA3));
          }
          
          matrixMult(P, rotationMatrix, 2);
          
           translationMatrix[0][2] = oldX;
          translationMatrix[1][2] = oldY;
          matrixMult(P, translationMatrix, 2);
          
          float deltaX1 =abs( x3 - P[3][0]);
          float deltaY1 =abs( y3 - P[3][1]);
          
          translationMatrix[0][2] = -oldX;
          translationMatrix[1][2] = -oldY;
          matrixMult(P, translationMatrix, 2);      //RETURN TO STARTING POSITION
          if(currentTheta < THETA3){
            
            rotationMatrix[0][0] = cos(radians(THETA3 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA3 - currentTheta));
            rotationMatrix[0][1] = sin(radians(THETA3 - currentTheta));
            rotationMatrix[1][0] = -sin(radians(THETA3 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA3));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA3));
            rotationMatrix[0][1] = -sin(radians(currentTheta - THETA3));
            rotationMatrix[1][0] = sin(radians(currentTheta - THETA3));
          }
          
          matrixMult(P, rotationMatrix, 2);
          
           translationMatrix[0][2] = oldX;
          translationMatrix[1][2] = oldY;
          matrixMult(P, translationMatrix, 2);
          
          float THETA3_2 = THETA3 + 180;
          
          translationMatrix[0][2] = -oldX;
          translationMatrix[1][2] = -oldY;
          matrixMult(P, translationMatrix, 2);          //CHECK SECOND ANGLE
          if(currentTheta < THETA3_2){      
            
            rotationMatrix[0][0] = cos(radians(THETA3_2 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA3_2 - currentTheta));
            rotationMatrix[0][1] = -sin(radians(THETA3_2 - currentTheta));
            rotationMatrix[1][0] = sin(radians(THETA3_2 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA3_2));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA3_2));
            rotationMatrix[0][1] = sin(radians(currentTheta - THETA3_2));
            rotationMatrix[1][0] = -sin(radians(currentTheta - THETA3_2));
          }
          
          matrixMult(P, rotationMatrix, 2);
          
           translationMatrix[0][2] = oldX;
          translationMatrix[1][2] = oldY;
          matrixMult(P, translationMatrix, 2);
          
          float deltaX2 =abs( x3 - P[3][0]);
          float deltaY2 =abs( y3 - P[3][1]);
          
          if(deltaX1 > deltaX2 || deltaY1 > deltaY2){      //COMPARE BOTH RESULTS AND PICK THE CORRECT ONE
            THETA3 = THETA3_2;
          }
          
          translationMatrix[0][2] = x3 - P[3][0];
          translationMatrix[1][2] = y3 - P[3][1];
          matrixMult(P, translationMatrix, 3);
          
          
          // set gui element with computed value
          theta2value.setText( str( THETA3 ));
          theta2 = THETA3;
        }
      }else if ( theEvent.getName() == "theta0input" ) {
        float currentTheta = theta0;
        System.out.println(currentTheta);
        theta0 = float( theEvent.getStringValue() );
        if ( Float.isNaN( theta0 )) {
          println( "ERROR in theta0 value" );
        } else {
          theta0input.setFocus( false );
          theta0input.setVisible( false );
          theta0value.setVisible( true );
          theta0value.setText( str( theta0 ));
          // set THETA from user
          THETA1 = theta0;
          // compute P1 --> Forward Kinematics!!
          if(currentTheta < THETA1){
            rotationMatrix[0][0] = cos(radians(THETA1 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA1 - currentTheta));
            rotationMatrix[0][1] = -sin(radians(THETA1 - currentTheta));
            rotationMatrix[1][0] = sin(radians(THETA1 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA1));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA1));
            rotationMatrix[0][1] = sin(radians(currentTheta - THETA1));
            rotationMatrix[1][0] = -sin(radians(currentTheta - THETA1));
          }
          
          matrixMult(P, rotationMatrix, 1);
        } 
      } else if ( theEvent.getName() == "theta1input" ) {
        float currentTheta = theta1;
        theta1 = float( theEvent.getStringValue() );
        if ( Float.isNaN( theta1 )) {
          println( "ERROR in theta1 value" );
        } else {
          theta1input.setFocus( false );
          theta1input.setVisible( false );
          theta1value.setVisible( true );
          theta1value.setText( str( theta1 ));
          // set THETA from user
          THETA2 = theta1;
          // compute P2 --> Forward Kinematics!!
          float oldX = P[1][0];
          float oldY = P[1][1];
          translationMatrix[0][2] = -oldX;
          translationMatrix[1][2] = -oldY;
          matrixMult(P, translationMatrix, 1);
          
          if(currentTheta < THETA1){
            rotationMatrix[0][0] = cos(radians(THETA2 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA2 - currentTheta));
            rotationMatrix[0][1] = -sin(radians(THETA2 - currentTheta));
            rotationMatrix[1][0] = sin(radians(THETA2 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA2));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA2));
            rotationMatrix[0][1] = sin(radians(currentTheta - THETA2));
            rotationMatrix[1][0] = -sin(radians(currentTheta - THETA2));
          }
          matrixMult(P, rotationMatrix, 1);
          
          translationMatrix[0][2] = oldX;
          translationMatrix[1][2] = oldY;
          matrixMult(P, translationMatrix, 1);
          
        //  drawArm2();
        }
      } else if ( theEvent.getName() == "theta2input" ) {
        float currentTheta = theta2;
        theta2 = float( theEvent.getStringValue() );
        if ( Float.isNaN( theta2 )) {
          println( "ERROR in theta2 value" );
        } else {
          theta2input.setFocus( false );
          theta2input.setVisible( false );
          theta2value.setVisible( true );
          theta2value.setText( str( theta2 ));
          // set THETA from user
          THETA3 = theta2;
          // compute P2 --> Forward Kinematics!!
          float oldX = P[2][0];
          float oldY = P[2][1];
          translationMatrix[0][2] = -oldX;
          translationMatrix[1][2] = -oldY;
          matrixMult(P, translationMatrix, 2);
          
          if(currentTheta < THETA1){
            rotationMatrix[0][0] = cos(radians(THETA3 - currentTheta));
            rotationMatrix[1][1] = cos(radians(THETA3 - currentTheta));
            rotationMatrix[0][1] = -sin(radians(THETA3 - currentTheta));
            rotationMatrix[1][0] = sin(radians(THETA3 - currentTheta));
          }else{
            rotationMatrix[0][0] = cos(radians(currentTheta - THETA3));
            rotationMatrix[1][1] = cos(radians(currentTheta - THETA3));
            rotationMatrix[0][1] = sin(radians(currentTheta - THETA3));
            rotationMatrix[1][0] = -sin(radians(currentTheta - THETA3));
          }
          matrixMult(P, rotationMatrix, 2);
          
          translationMatrix[0][2] = oldX;
          translationMatrix[1][2] = oldY;
          matrixMult(P, translationMatrix, 2);
        }
      }
    }
  }
} // end of controlEvent()


/**
 FORWARD()
 This callback function is called when the "FORWARD button is clicked.
 For Forward Kinematics, we have P0 and we ask for THETA from the user.
 Then we calculate P1.
 */
public void FORWARD_1( int theValue ) {
  println( "FORWARD KINEMATICS! Enter THETA0." );
  if ( init ) {
    loseFocus();
    
    theta0value.setVisible( false );
    theta0input.setVisible( true );
    theta0input.setFocus( true );
  }
} 

public void FORWARD_2( int theValue ) {
  println( "FORWARD KINEMATICS! Enter THETA1." );
  if ( init ) {
    loseFocus();
    theta1value.setVisible( false );
    theta1input.setVisible( true );
    theta1input.setFocus( true );
  }
} 

public void FORWARD_3( int theValue ) {
  println( "FORWARD KINEMATICS! Enter THETA2." );
  if ( init ) {
    loseFocus();
    theta2value.setVisible( false );
    theta2input.setVisible( true );
    theta2input.setFocus( true );
  }
} // end of FORWARD callback function()


public void ONE_LINK(int theValue) {
  println( "DRAWING 1-LINK ARM" );
  if ( init ) {
    loseFocus();
    drawArm1();
    
  }
}

public void TWO_LINK(int theValue) {
  println( "DRAWING 2-LINK ARM" );
  if ( init ) {
    loseFocus();
    drawArm2();
  }
}
public void THREE_LINK(int theValue) {
  println( "DRAWING 3-LINK ARM" );
  if ( init ) {
    loseFocus();
    drawArm3();
  }
}
public void RESET(int theValue){
  println("RESETTING");
  if(init){
    reset();
  }
}
  

/**
 INVERSE()
 This callback function is called when the "INVERSE" button is clicked.
 For Inverse Kinematics, we have P0 and we ask for P1 from the user.
 Then we calculate THETA.
 */
public void INVERSE( int theValue ) {
  println( "INVERSE KINEMATICS! Enter (X1,Y1)." );
  if ( init ) {
    loseFocus();
    x1value.setVisible( false );
    x1input.setVisible( true );
    x1input.setFocus( true );  
  }
} // end of INVERSE callback function()


/**
 draw()
 This function draws the canvas. It is called once per frame.
 **/
void draw() {
  init = true;
  background( #aaaaaa );
  fill( #ffffff );
  stroke( #ffffff );
  rect( 10, 80, 500, 500 );
  // draw axes
  stroke( #000000 );
  strokeWeight( 1 );
  line( 10, 330, 510, 330 );
  line( 260, 80, 260, 580 );
  // draw arm
  if(numberOfLines == 1 || numberOfLines == 0 ){
    drawArm1();
    x2value.setVisible(false);
    x3value.setVisible(false);
    y2value.setVisible(false);
    y3value.setVisible(false);
    theta1value.setVisible(false);
    theta2value.setVisible(false);
    FW2.setVisible(false);
    FW3.setVisible(false);
  }else if(numberOfLines == 2){
    drawArm2();
    x2value.setVisible(true);
    x3value.setVisible(false);
    y2value.setVisible(true);
    y3value.setVisible(false);
    theta1value.setVisible(true);
    theta2value.setVisible(false);
    FW2.setVisible(true);
    FW3.setVisible(false);
  }else if(numberOfLines == 3){
    drawArm3();
    x2value.setVisible(true);
    x3value.setVisible(true);
    y2value.setVisible(true);
    y3value.setVisible(true);
    theta1value.setVisible(true);
    theta2value.setVisible(true);
    FW2.setVisible(true);
    FW3.setVisible(true);
  }
  x1value.setText( str( P[1][0] ));
  y1value.setText( str( P[1][1] ));
  x2value.setText( str( P[2][0] ));
  y2value.setText( str( P[2][1] ));
  x3value.setText( str( P[3][0] ));
  y3value.setText( str( P[3][1] ));
  //drawArm1();
} // end of draw()
