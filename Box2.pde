
class Box2
{
  float  x; // x posistion of centre of box
  float  y; // y position of centre of box
  
  float  Height; // height of box
  float  Width; // width of box
  
  float ang; // angle of box from x-axis
  
  PVector[] cnrs = new PVector[4];
  
  Box2(float aX, float aY, float aHeight, float aWidth, float aAng)
  {
    x = aX;
    y = aY;
    
    Height = aHeight;
    Width = aWidth;
    
    ang = aAng; 
    
    float theta = - atan(Height/Width); // angle between x axis and the corners
    float d = sqrt(sq(Height/2) + sq(Width/2)); // length of diagonal of tank base from centre
    
    cnrs[0] = new PVector(x + d * cos(theta + ang), y + d * sin(theta + ang)); // top right 
    cnrs[1] = new PVector(x + d * cos(-theta + ang), y + d * sin(-theta + ang)); // bottom right
    cnrs[2] = new PVector(x + d * cos(PI + theta + ang), y + d * sin(PI + theta + ang)); // bottom left
    cnrs[3] = new PVector(x + d * cos(PI - theta + ang), y + d * sin(PI - theta + ang)); // top left
    
  }
  
  void move(float aX, float aY)
  { // moves box to new position
    x = aX;
    y = aY;
  }
  
  void UpdateCorners()
  {
    float theta = - atan(Height/Width); // angle between x axis and the corners
    float d = sqrt(sq(Height/2) + sq(Width/2)); // length of diagonal of tank base from centre
    
    cnrs[0].x = x + d * cos(theta + ang); cnrs[0].y = y + d * sin(theta + ang);
    cnrs[1].x = x + d * cos(-theta + ang); cnrs[1].y =  y + d * sin(-theta + ang);
    cnrs[2].x = x + d * cos(PI + theta + ang); cnrs[2].y = y + d * sin(PI + theta + ang);
    cnrs[3].x = x + d * cos(PI - theta + ang); cnrs[3].y = y + d * sin(PI - theta + ang);
    
  }
  
  void Draw()
  { 
    UpdateCorners();
    quad(cnrs[0].x, cnrs[0].y, // top right 
        cnrs[1].x, cnrs[1].y, //bottom right
        cnrs[2].x, cnrs[2].y, // bottom left
        cnrs[3].x, cnrs[3].y); //top left
  }

}

  
