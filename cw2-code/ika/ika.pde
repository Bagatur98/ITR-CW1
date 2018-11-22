/**
 * ika.pde
 * sklar/12-nov-2018
 * This program animates a 3-segment arm over a series of possible positions.
 * This code provides an Analytical solution to Inverse Kinematics. 
 **/


// define offset values so that (0,0) is in the middle of the display window.
float X_OFFSET, Y_OFFSET;

// define global variables (length of each arm link)                                                                         
float L1 = 100;
float L2 = 100;
float L3 = 100;

// time counter                                                                                                     
int TC = 0;

// define arrays of data over each of 200 arm positions
float theta_total[] = new float[200];                 // total angle
float px[]  = new float[200], py[]  = new float[200]; // position of end effector, benchmark data
float l1x[] = new float[200], l1y[] = new float[200]; // computed position of end of link 1 (P1)
float l2x[] = new float[200], l2y[] = new float[200]; // computed position of end of link 2 (P2)
float l3x[] = new float[200], l3y[] = new float[200]; // computed position of end of link 3 (P3)
float pxa[] = new float[200], pya[] = new float[200]; // computed position of end effector, analytical solution (P3)
float l0x = 0, l0y = 0; // position of base of arm (P0)
float theta1[] = new float[200]; // computed angle of link 1
float theta2[] = new float[200]; // computed angle of link 2
float theta3[] = new float[200]; // computed angle of link 3


/**
 * setup()
 * This function is called once, when the program starts up. 
 */
void setup() {
  // set up drawing window
  size( 500, 500 );
  // save centre of drawing window, in pixels
  X_OFFSET = 250;
  Y_OFFSET = 250;
  // set up mode for drawing circles
  ellipseMode( CENTER );
  // slow down drawing rate so we can see what is happening
  frameRate( 10 );
  // initialise time counter for looping through arm positions
  TC = 0;
  // generate benchmark data (200 arm positions)
  generateBenchmarkData();
  // generate data using analytical approach to inverse kinematics (for 200 arm positions)
  generateAnalyticalData();
  // save the analytical data in a file (will be saved in the sketch folder)
  PrintWriter outfile = createWriter( "ika-data.txt" );
  for ( int t=0; t<200; t++ ) {
    outfile.println( t + ", " + l1x[t] + ", " + l1y[t] + ", " + l2x[t] + ", " + l2y[t] + ", " + l3x[t] + ", " + l3y[t] );
  }
  outfile.close();
} // end of setup()


/**
 * generateBenchmarkData()
 * This function generates benchmark (solution) data.
 */
void generateBenchmarkData() {
  float i = 0.0;
  for ( int t=0; t<200; t++ ) {
    // set angles                                                                                                   
    theta1[t] = i;
    theta2[t] = i;
    theta3[t] = PI - ( theta1[t] + theta2[t] ); // because theta1+theta2+theta3=pi                                                                                      
    theta_total[t] = ( theta1[t] + theta2[t] + theta3[t] );
    // set end point                                                                                                
    px[t] = ( L1*cos(theta1[t]) + L2*cos(theta1[t]+theta2[t]) + L3*cos(theta1[t]+theta2[t]+theta3[t]) );
    py[t] = ( L1*sin(theta1[t]) + L2*sin(theta1[t]+theta2[t]) + L3*sin(theta1[t]+theta2[t]+theta3[t]) );
    i += 0.0157;
  }
} // end of generateBenchmarkData()


/**
 * IK_analytical()
 * This function computes and returns three joint angles, given endpoint (px,py), 
 * lengths of 3 joints (L1, L2 and L3) and total angle (th_total).
 */
float[] IK_analytical( float px, float py, float th_total ) {
  float angles[] = new float[3];
  float pwx, pwy, c1, c2, s1, s2;
  pwx = px - L3*cos( th_total );
  pwy = py - L3*sin( th_total );
  c2  = ( pwx*pwx + pwy*pwy - L1*L1 - L2*L2 ) / ( 2 * L1 * L2 );
  s2 = sqrt( 1 - c2*c2 );
  angles[1] = atan2( s2, c2 );
  s1 = (( L1 + L2*c2 ) * pwy - L2 * s2 * pwx ) / ( pwx*pwx + pwy*pwy );
  c1 = (( L1 + L2*c2 ) * pwx + L2 * s2 * pwy ) / ( pwx*pwx + pwy*pwy );
  angles[0] = atan2( s1, c1 );
  angles[2] = th_total - atan2( s2, c2 ) - atan2( s1, c1 );
  return( angles );
} // end of IK_analytical


/**
 * generateAnalyticalData()
 * This function generates data using the analytical solution to the inverse kinematics to 
 * compute the locations of the links for display.
 */
void generateAnalyticalData() {
  float angles[];
  for ( int t=0; t<200; t++ ) {
    angles = IK_analytical( px[t], py[t], theta_total[t] );
    // set end point
    pxa[t] = ( L1*cos(angles[0]) + L2*cos(angles[0]+angles[1]) + L3*cos(angles[0]+angles[1]+angles[2]) );
    pya[t] = ( L1*sin(angles[0]) + L2*sin(angles[0]+angles[1]) + L3*sin(angles[0]+angles[1]+angles[2]) );
    // set first point                                                                                              
    l1x[t] = ( L1*cos(angles[0]) );
    l1y[t] = ( L1*sin(angles[0]) );
    // set second point                                                                                             
    l2x[t] = ( L1*cos(angles[0]) + L2*cos(angles[0]+angles[1]) );
    l2y[t] = ( L1*sin(angles[0]) + L2*sin(angles[0]+angles[1]) );
    // set third point                                                                                              
    l3x[t] = ( L1*cos(angles[0]) + L2*cos(angles[0]+angles[1]) + L3*cos(angles[0]+angles[1]+angles[2]) );
    l3y[t] = ( L1*sin(angles[0]) + L2*sin(angles[0]+angles[1]) + L3*sin(angles[0]+angles[1]+angles[2]) );
  }
} // end of generateAnalyticalData()


/**
 * draw()
 * This function is called every time the Processing drawing loop iterates.
 */
void draw() {
  background( #ffffff );
  // draw original endpoint in a black circle
  strokeWeight( 1 );
  stroke( #000000 );
  ellipse( px[TC]+X_OFFSET, Y_OFFSET-py[TC], 5, 5 );
  // draw analytical endpoint in red
  strokeWeight( 3 );
  stroke( #ff0000 );
  point( pxa[TC]+X_OFFSET, Y_OFFSET-pya[TC] );
  // draw arm
  strokeWeight( 2 );
  stroke( #0000ff );
  line( l0x+X_OFFSET, Y_OFFSET-l0y, l1x[TC]+X_OFFSET, Y_OFFSET-l1y[TC] );
  stroke( #ff00ff );
  line( l1x[TC]+X_OFFSET, Y_OFFSET-l1y[TC], l2x[TC]+X_OFFSET, Y_OFFSET-l2y[TC] );
  stroke( #00ff00 );
  line( l2x[TC]+X_OFFSET, Y_OFFSET-l2y[TC], l3x[TC]+X_OFFSET, Y_OFFSET-l3y[TC] );
  // increment time counter (TC)
  if ( TC < 199 ) {
    TC += 1;
  }
  // for debugging, print the data we are plotting in this drawing iteration
  print( "TC=", TC );
  print( " theta1=", degrees( theta1[TC] ));
  print( " theta2=", degrees( theta2[TC] ));
  print( " theta3=", degrees( theta3[TC] ));
  print( " total=", degrees( theta_total[TC] ));
  println();
} // end of draw()
