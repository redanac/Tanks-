class Bullet 
{
  Box2 hitBox; // stores dimensions and position of bullet
  float vel = 0; // velocity of bullet
  color bulletColour = color(169,169,169);
  color throughWallColour = #FF0D0D; // colour if bullets can travel through wall
  float ang = 0;
  float theta = 0;
  
  Bullet(float aX, float aY, float aHeight, float aWidth)
  {
    hitBox = new Box2(aX, aY, aHeight, aWidth, ang);
  }
  
  void setVelocity(float aVel)
  {
   vel = aVel; 
   
  }
  
  void Draw(boolean throughWalls)
  {
    if (throughWalls)
    {
      fill(throughWallColour);
    } else {
      fill(bulletColour);
    }
    stroke(0);
    hitBox.Draw();
  }
  
  void Update()
  { 
    hitBox.ang = ang;
    hitBox.UpdateCorners();
    // update bullet position according to direction its going
    hitBox.x += vel * cos(ang); //+vel*cos(theta); 
    hitBox.y += vel * sin(ang); //+vel * sin(theta);
    //theta += 0.1;
  }
}
