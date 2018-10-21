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
float L2 = 75;
float L3 = 50;
// initial angle of arm
float THETA1 = 0;
float THETA2 = 0;
float THETA3 = 0;
// define a list of points for the arm joints.     
// note that we use homogeneous coordinates in 2D.
float P[][] = {{ X, Y, 1 }, { X+L1, Y, 1 }, {X+L1+L2, Y, 1 }, {X+L1+L2+L3, Y, 1 }}; 

// define offset values so that (0,0) is in the middle of the display window.
float X_OFFSET, Y_OFFSET;

// define an object for the GUI (a ControlP5 object) and various GUI elements
ControlP5 cp5;
Textlabel x0value, y0value, theta0value, theta1value, theta2value, x1value, y1value, x2value, y2value, x3value, y3value;
Textlabel theta1label, theta2label, x2label, y2label, x3label, y3label;
Textfield x1input, y1input, x2input, y2input, x3input, y3input, theta0input, theta1input, theta2input;
float x1, y1,x2, y2, x3, y3, theta0, theta1, theta2;

// define a flag to indicate when GUI elements have been initialised
boolean init = false;
int numberOfLines;

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
    cp5.addButton( "1-LINK")
    .setValue( 0 )
    .setPosition( 10, 10 )
    .setSize( 50, 10 );
    cp5.addButton( "2-LINK")
    .setValue( 0 )
    .setPosition( 70, 10 )
    .setSize( 50, 10 );
    cp5.addButton( "3-LINK")
    .setValue( 0 )
    .setPosition( 130, 10 )
    .setSize( 50, 10 );
    cp5.addButton( "FORWARD")
    .setValue( 0 )
    .setPosition( 190, 10 )
    .setSize( 50, 10 );
  cp5.addButton( "INVERSE")
    .setValue( 0 )
    .setPosition( 250, 10 )
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
    .setPosition( 30, 60 )
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


/**
 drawArm()
 This function draws the arm.
 **/
 void drawArm1() {
   numberOfLines = 1;
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
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
   numberOfLines = 2;
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
  stroke(#00ff00);
  line(P[1][0]+X_OFFSET, Y_OFFSET-P[1][1], P[2][0]+X_OFFSET, Y_OFFSET-P[2][1]);
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
 
void drawArm3() {
  numberOfLines = 3;
  stroke( #0000ff );
  strokeWeight( 4 );
  line( P[0][0]+X_OFFSET, Y_OFFSET-P[0][1], P[1][0]+X_OFFSET, Y_OFFSET-P[1][1] );
  stroke(#00ff00);
  line(P[1][0]+X_OFFSET, Y_OFFSET-P[1][1], P[2][0]+X_OFFSET, Y_OFFSET-P[2][1]);
  stroke(#ff0000);
  line(P[2][0]+X_OFFSET, Y_OFFSET-P[2][1], P[3][0]+X_OFFSET, Y_OFFSET-P[3][1]);
  
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
          P[2][0] = (L1 + L2) * cos( radians( THETA1 ));
          P[2][1] = (L1 + L2) * sin( radians( THETA1 ));
          P[3][0] = (L1 + L2 + L3) * cos( radians( THETA1 ));
          P[3][1] = (L1 + L2 + L3) * sin( radians( THETA1 ));
          // set gui elements with computed values
          x1value.setText( str( P[1][0] ));
          y1value.setText( str( P[1][1] ));
          x2value.setText( str( P[2][0] ));
          y2value.setText( str( P[2][1] ));
          x3value.setText( str( P[3][0] ));
          y3value.setText( str( P[3][1] ));
        } 
      } else if ( theEvent.getName() == "theta1input" ) {
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
          P[2][0] = (L1 + L2) * cos( radians( THETA2 ));
          P[2][1] = (L1 + L2) * sin( radians( THETA2 ));
          P[3][0] = (L1 + L2 + L3) * cos( radians( THETA2 ));
          P[3][1] = (L1 + L2 + L3) * sin( radians( THETA2 ));
          // set gui elements with computed values
          x2value.setText( str( P[2][0] ));
          y2value.setText( str( P[2][1] ));
          x3value.setText( str( P[3][0] ));
          y3value.setText( str( P[3][1] ));
        }
      } else if ( theEvent.getName() == "theta2input" ) {
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
          P[3][0] = (L1 + L2 + L3) * cos( radians( THETA3 ));
          P[3][1] = (L1 + L2 + L3) * sin( radians( THETA3 ));
          // set gui elements with computed values
          x3value.setText( str( P[3][0] ));
          y3value.setText( str( P[3][1] ));
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


public void ONELINK() {
  println( "DRAWING 1-LINK ARM" );
  if ( init ) {
    drawArm1();
  }
}

public void TWOLINK() {
  println( "DRAWING21-LINK ARM" );
  if ( init ) {
    drawArm2();
  }
}
public void THREELINK() {
  println( "DRAWING 3-LINK ARM" );
  if ( init ) {
    drawArm3();
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
