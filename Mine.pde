class Mine
{
  Box2 hitBox; // hit box for mine
  color mineColour = #939393; //mine body colour
  color[][] bleeperColour = {{#FF0303, #F9FA05}, {#0805FF, #23FF03}}; // colours for flashing light on mine 
  int bleepIdx = 0; // stores which colour led is currently on
  int count; // counts frames
  float ang = 0;
  float radius; // size of mine
  boolean enemyMine; // if true the enemy laid the mine and the blinker flashes a different colour
  
  Mine(float aX, float aY, float aRadius, boolean aEnemyMine)
  {
    hitBox = new Box2(aX, aY, aRadius, aRadius, ang);
    radius = aRadius;
    enemyMine = aEnemyMine;
  }
  
  void Draw()
  {
    stroke(0);
    fill(mineColour);
    circle(hitBox.x, hitBox.y, radius);
    if(!enemyMine)
    {
      fill(bleeperColour[1][bleepIdx]);
    }
    else
    {
      fill(bleeperColour[0][bleepIdx]);
    }
    circle(hitBox.x, hitBox.y, radius/3);
  }
  
  void Update()
  {
    count++;
    if(count% 30 == 0)
    { //every second change blinker colour
      bleepIdx = (bleepIdx + 1) % 2;
    }
  }
}
