/** //<>// //<>//
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
float L2 = 0;
float L3 = 0;
// initial angle of arm
float THETA1 = 0;
float THETA2 = 0;
float THETA3 = 0;
// define a list of points for the arm joints.     
// note that we use homogeneous coordinates in 2D.
float P[][] = {{ X, Y, 1 }, { X+L1, Y, 1 },{X+L1+L2, Y, 1 },{X+L1+L2+L3, Y, 1 }}; 

// define offset values so that (0,0) is in the middle of the display window.
float X_OFFSET, Y_OFFSET;

// define an object for the GUI (a ControlP5 object) and various GUI elements
ControlP5 cp5;
Textlabel x0value, y0value, theta0value, x1value, y1value;
Textfield x1input, y1input, theta0input;
float x1, y1, theta0;

// define a flag to indicate when GUI elements have been initialised
boolean init = false;


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
  cp5.addButton( "FORWARD")
    .setValue( 0 )
    .setPosition( 10, 10 )
    .setSize( 50, 10 );
  cp5.addButton( "INVERSE")
    .setValue( 0 )
    .setPosition( 70, 10 )
    .setSize( 50, 10 );
  cp5.addTextlabel( "x0label" )
    .setText( "X0=" )
    .setPosition( 10, 30 );
  cp5.addTextlabel( "x0value" )
    .setPosition( 30, 30 )
    .setText( "0" )
    .setColor( #000000 );
  cp5.addTextlabel( "y0label" )
    .setText( "Y0=" )
    .setPosition( 50, 30 );
  cp5.addTextlabel( "y0value" )
    .setPosition( 70, 30 )
    .setText( "0" )
    .setColor( #000000 );
  cp5.addTextlabel( "theta0label" )
    .setText( "theta0=" )
    .setPosition( 90, 30 );
  theta0value = cp5.addTextlabel( "theta0value" )
    .setPosition( 130, 30 )
    .setText( "0" )
    .setColor( #000000 );
  theta0input = cp5.addTextfield( "theta0input" )
    .setPosition( 130, 30 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
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
    .setPosition( 50, 40 );
  y1value = cp5.addTextlabel( "y1value" )
    .setPosition( 70, 40 )
    .setText( "0" )
    .setColor( #000000 );
  y1input = cp5.addTextfield( "y1input" )
    .setPosition( 70, 40 )
    .setSize( 20, 10 )
    .setCaptionLabel( "" )
    .setFocus( false )
    .setVisible( false )
    .setColor( #ffffff );
} // end of setup()


/**
 drawArm()
 This function draws the arm.
 **/
 void drawArm1() {
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
 }
 
 void drawArm2() {
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
  stroke(#00ff00);
  line(P[1][0]+X_OFFSET, Y_OFFSET-P[1][1], P[2][0]+X_OFFSET, Y_OFFSET-P[2][1]);
}
 
void drawArm3() {
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
  stroke(#00ff00);
  line(P[1][0]+X_OFFSET, Y_OFFSET-P[1][1], P[2][0]+X_OFFSET, Y_OFFSET-P[2][1]);
  stroke(#ff0000);
  line(P[2][0]+X_OFFSET, Y_OFFSET-P[2][1], P[3][0]+X_OFFSET, Y_OFFSET-P[3][1]);
} // end of drawArm()


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
        } else {
          y1input.setFocus( false );
          y1input.setVisible( false );
          y1value.setVisible( true );
          y1value.setText( str( y1 ));
          // set P1 from user
          P[1][0] = x1;
          P[1][1] = y1;
          // compute THETA --> Inverse Kinematics!!
          THETA1 = degrees( atan( ( P[1][1] - P[0][1] ) / ( P[1][0] - P[0][0] )));
          // set gui element with computed value
          theta0value.setText( str( THETA1 ));
        }
      } else if ( theEvent.getName() == "theta0input" ) {
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
          P[1][0] = L1 * cos( radians( THETA1 ));
          P[1][1] = L1 * sin( radians( THETA1 ));
          // set gui elements with computed values
          x1value.setText( str( P[1][0] ));
          y1value.setText( str( P[1][1] ));
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
public void FORWARD( int theValue ) {
  println( "FORWARD KINEMATICS! Enter THETA0." );
  if ( init ) {
    theta0value.setVisible( false );
    theta0input.setVisible( true );
    theta0input.setFocus( true );
  }
} // end of FORWARD callback function()


/**
 INVERSE()
 This callback function is called when the "INVERSE" button is clicked.
 For Inverse Kinematics, we have P0 and we ask for P1 from the user.
 Then we calculate THETA.
 */
public void INVERSE( int theValue ) {
  println( "INVERSE KINEMATICS! Enter (X1,Y1)." );
  if ( init ) {
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
  drawArm1();
} // end of draw()
