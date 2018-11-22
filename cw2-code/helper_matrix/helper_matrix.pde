// returns determinant of 2x2 matrix M
float det2( float M[][] ) {
  return( M[0][0] * M[1][1] - M[0][1] * M[1][0] );
} // end of det2()


// returns determinant of 3x3 matrix M
float det3( float M[][] ) {
  float tmpM1[][] = {{ M[1][1], M[1][2] }, { M[2][1], M[2][2] }};
  float tmpM2[][] = {{ M[1][0], M[1][2] }, { M[2][0], M[2][2] }};
  float tmpM3[][] = {{ M[1][0], M[1][1] }, { M[2][0], M[2][1] }};
  float d1 = det2( tmpM1 );
  float d2 = det2( tmpM2 );
  float d3 = det2( tmpM3 );
  return( M[0][0] * d1 - M[0][1] * d2 + M[0][2] * d3 );
} // end of det3()


// returns inverse of argument 3x3 matrix M                                                                                  
float[][] inv3( float M[][] ) {
  float d = det3( M );
  float IM[][] = new float[3][3];
  float M00[][] = {{ M[1][1], M[1][2] }, { M[2][1], M[2][2] }};
  float M01[][] = {{ M[0][2], M[0][1] }, { M[2][2], M[2][1] }};
  float M02[][] = {{ M[0][1], M[0][2] }, { M[1][1], M[1][2] }};
  float M10[][] = {{ M[1][2], M[1][0] }, { M[2][2], M[2][0] }};
  float M11[][] = {{ M[0][0], M[0][2] }, { M[2][0], M[2][2] }};
  float M12[][] = {{ M[0][2], M[0][0] }, { M[1][2], M[1][0] }};
  float M20[][] = {{ M[1][0], M[1][1] }, { M[2][0], M[2][1] }};
  float M21[][] = {{ M[0][1], M[0][0] }, { M[2][1], M[2][0] }};
  float M22[][] = {{ M[0][0], M[0][1] }, { M[1][0], M[1][1] }};
  IM[0][0] = ( 1 / d ) * det2( M00 );
  IM[0][1] = ( 1 / d ) * det2( M01 );
  IM[0][2] = ( 1 / d ) * det2( M02 );
  IM[1][0] = ( 1 / d ) * det2( M10 );
  IM[1][1] = ( 1 / d ) * det2( M11 );
  IM[1][2] = ( 1 / d ) * det2( M12 );
  IM[2][0] = ( 1 / d ) * det2( M20 );
  IM[2][1] = ( 1 / d ) * det2( M21 );
  IM[2][2] = ( 1 / d ) * det2( M22 );
  return( IM );
} // end of inv3()


// computes global variable Delta as M * V where argument M is a 3x3 matrix and argument V is a 3x1 matrix                                                     
float[] multiply3x1( float M[][], float V[] ) {
  float[] MM = new float[3];
  MM[0] = M[0][0] * V[0] + M[0][1] * V[1] + M[0][2] * V[2];
  MM[1] = M[1][0] * V[0] + M[1][1] * V[1] + M[1][2] * V[2];
  MM[2] = M[2][0] * V[0] + M[2][1] * V[1] + M[2][2] * V[2];
  return( MM );
} // end of multiply3x1()
