



class Enemy
{
  PVector pos; // enemy position from centre of screen
  float tankSize; // reference size for all components, the length of the tank
  float tankWidth;
  float barrelWidth; // self explanatory I hope
  float barrelLength;
  float circleSize; // size of circular base
  float x, y; // position that cannon is facing 
  float m; // gradient of line from origin to mouse
  color tankColour = color(183, 76, 123); // colour of the tank 
  color statColour = color(255, 76, 123); // colour of a stationary tank
  color throughWallColour = #BFB668;
  color searcherColour = #5282FF;
  color bossColour = #FF1803;
  color bossBodyColour = #AA0E00;
  color barrelColour = color(133, 98, 109); // colour of barrel
  int direction = 0; // stores which direction tank is facing: 0 -> right/left ; 1 -> up/down; 2 -> diag right ; 3 -> diag left
  float ang = 0; // stores angle of tank barrel
  Bullet[] bullets; // Stores the bullets tank can shoot
  int currentBullet = 0; // stores the current bullet number
  Box2[] empty = new Box2[0];
  float tankAngle = 0; // stores the angle the tank is facing
  int vertical; // vertical velocity
  int horizontal; // horizontal velocity
  int AI; // what kind of AI the enemy has
  float target; // angle to place where the enemy wants to aim
  int coolDown = 500; // cooldown of a second between bullets
  int bulletTimer; // timer to recored how long since bullet was shot
  int dir; // stores which direction enemy is travelling: 0 -> right; 1 -> left; 2 -> up ; 3 -> down;
  int moveCount = 0; // tracks how long tank has been moving in a direction
  boolean dead = false; // checks if youre deed or not
  Explosion explosion;
  boolean exploded = false; // checks if exploded
  boolean searchHitWall = true; // true if searh enemy hits a wall
  int vel;
  int[] randomDirection = {-1, 1};
  boolean throughWalls = false; // sets whether bullets can shoot through walls or not
  boolean mineHit = false; // checks if been hit by mine 
  boolean bulletHit = false; // checks if been hit by bullet
  Mine[] mines; //holds all the mines
  int currentMine = 0; // current mine
  int health; //  health 
  int bossHealth = 5; // health for boss
  int startHealth = 1; // health for normies
  int blueHealth = 2; // heallth for searchers
  Smoke smoke;
  Fire fire;
  float size;
  hitmark hitMark;
  
  
  Enemy(float aX, float aY, int aAI, float aSize)
  {
    
    pos = new PVector(aX, aY);
    
    tankSize = width/20 * aSize; // reference size for all components, the length of the tank
    tankWidth = tankSize * 2.0/3.0;
    barrelWidth = tankSize*1.0/5.0; // self explanatory I hope
    barrelLength = tankSize*2.0/3.0;
    circleSize = tankSize*6.0/10.0; // size of circular base
    
    
    smoke = new Smoke(10); // initialise smoke animation
    fire = new Fire(30); // initialise fire animation
      
    horizontal = 0;
    vertical = 0; 
    
    vel = width/250;
    
    AI = aAI;
    
    if(AI == 5)
    {
      health = bossHealth;
    } else if(AI == 4) {
      health = blueHealth;
    } else {
      health = startHealth;
    }
    
    if(AI == 3 || AI == 5)
    { // change colour of bullets to show they can go through walls
      throughWalls = true;
    }
    
    bullets = new Bullet[50];
    mines = new Mine[5];
    
    ang = 0;
    
    target = 0;
    
    bulletTimer = millis(); // starts above cooldown time so bullet can be shot
    
    dir = 0; // going right  
    
    explosion = new Explosion(20);
    hitMark = new hitmark(100);
  }
  
  void move(float aX, float aY)
  {// moves the tank to position aX, aY
    pos.x = aX; 
    pos.y = aY; 
  }
  
  void checkDir()
  { // checks direction of tank, see variable direction
    if(horizontal != 0 && vertical ==0)
    {
      direction = 0;  // left or right 
      tankAngle = 0;
      
    }
    else if(horizontal == 0 && vertical !=0)
    {
      direction = 1; // up or down
      tankAngle = PI/2;
    }
    else if((horizontal > 0 && vertical < 0) || (horizontal < 0 && vertical > 0))
    {
      direction = 2; // up-right or down-left
      tankAngle = -PI/4;
    }
    else if((horizontal < 0 && vertical < 0) || (horizontal > 0 && vertical > 0)) 
    {
      direction = 3; // up-left or down-right
      tankAngle = PI/4;
    }
  }
  
  
  void drawDiag(boolean right)
  {
    if(right)
    {
      pushMatrix();
      rotate(radians(45));
      rect(-tankWidth/2, -tankSize/2, tankWidth, tankSize );
      popMatrix();
    }
    else
    {
      pushMatrix();
      rotate(radians(-45));
      rect(-tankWidth/2, -tankSize/2, tankWidth, tankSize );
      popMatrix();
    }
  }
  
  void drawTank()
  {
    if(!dead)
    {
      pushMatrix();
      translate(pos.x, pos.y); // moves coordinate system so (0, 0) is the middle
       
        // colour and stroke width
        stroke(0);
        strokeWeight(2);
        if(AI == 0)
        {
          fill(statColour);
        } else if(AI == 3) {
          fill(throughWallColour); 
          direction = 1;
        } else if(AI == 5) {
          fill(bossColour); 
        } else if(AI == 4) {
          fill(searcherColour); 
        } else {
          fill(tankColour);
        }
        
        checkDir(); // check direction of tank
        
        if(direction == 0)
        {
          rect(-tankSize *1/2 , -tankWidth * 1/2, tankSize, tankWidth);
        }
        else if(direction == 1)
        {
          rect(-tankWidth*1/2, -tankSize * 1/2, tankWidth, tankSize);
        }
        else if(direction == 2)
        {
          drawDiag(true);
        }
        else if(direction == 3)
        {
          drawDiag(false);
        }
        
        drawBarrel();
        stroke(50, 50, 50);
        strokeWeight(2);
        if(AI == 0)
        {
          fill(statColour);
        } else if(AI == 3) {
          fill(throughWallColour); 
          direction = 1;
        } else if(AI == 5) {
          fill(bossBodyColour); 
        } else if(AI == 4) {
          fill(searcherColour); 
        } else {
          fill(tankColour);
        }
        circle(0, 0, circleSize);
        
        if(AI == 5)
        {
          smoke.animate(0, 0 , tankAngle);
          fire.animate(0, 0, 0);
        }
        popMatrix();
        hitMark.animate(pos.x + random(-hitMark.Size/5, -hitMark.Size/5 ), pos.y  + random(-hitMark.Size/10, -hitMark.Size/10 ));
        
    }
    if(dead)
    {
        explosion.animate(int(pos.x),int( pos.y));
    }
    
    for(Mine mine: mines)
    {
       if(mine != null)
       {
         mine.Draw();
       }
    }
    
      //  Draw bullets 
      
    for(Bullet bullet : bullets)
    {
      if(bullet != null)
      {
          
        bullet.Draw(throughWalls);
      }
    }
      
  }
  
  void drawBarrel()
  {
    // mouse position does not change with translate so this is a conversion for x and y
    
    pushMatrix();
    rotate(ang);
    fill(barrelColour);
    rect(0, -barrelWidth/2.0, barrelLength, barrelWidth);
    popMatrix();
  }
  
  void aim(float aX, float aY)
  { // set target for where to aim and calculate the necessary angle.
    float xs = aX - pos.x; // horizontal distance from target
    float ys = aY - pos.y; // vertical distance from target
    
    target = atanq(xs,ys);
  }
  
  void aimBarrel(float aX, float aY)
  { // set target for where to aim and calculate the necessary angle.
    float xs = aX - pos.x; // horizontal distance from target
    float ys = aY - pos.y; // vertical distance from target
    
    ang = atanq(xs,ys);
  }
  
  void moveBarrel()
  { // checks where barrel is aiming and moves it to aim at target. If target aimed at, shoot a bullet
    if(ang < 0) // if the angle is negative, translate to positive angle  
    {
      ang = 2 * PI + ang;
    }
    float diffAng = (target - ang) ; // angle between current barrel position and target
    if(abs(diffAng) < PI) // which direction to move if difference in angle is less than 180 degrees
    {
      if(diffAng > 0)
      {
        ang = (ang + PI/100) % (2*PI);
      }
      else if(diffAng < 0)
      {
        ang = (ang - PI/100)  % (2*PI) ;
      }
    } else if(abs(diffAng) > PI) { // which direction to move if difference in angle is more than 180 degrees
      if(diffAng < 0)
      {
        ang = (ang + PI/100) % (2*PI);
      }
      else if(diffAng > 0)
      {
        ang = (ang - PI/100) % (2*PI);
      }
    }
    
    // check if enemy is roughly aiming at target
    if(abs(diffAng) < PI/320)
    {
      shootBullet();
    }
  }
  
  void setHorizontal(int aVel)
  {
    horizontal = aVel;
  }
  
  void setVertical(int aVel)
  {
    vertical = aVel;
  }
  
    void nullBullets()
  { // gets rid of all current player bullets,
    for(int i = 0; i < bullets.length; i++)
    {
      bullets[i] = null;
    }
  }
  
  void search(Box2[] aCollision)
  { // if a wall is hit chooses a random direction and moves that way till it hits a wall then chooses another random direction
    if(horizontal == 0 && vertical == 0)
    { // if stationary generate initial direction 
      // generate random horizontal and vertical directions
      int h = round(random(-1,1)) * width/400;
      int v;
      if(h == 0)
      {
        int idx = int(random(0,1));
        v = randomDirection[idx] * width/ 400;
      } else {
        v = round(random(-1,1)) * width/400;
      }
       horizontal = h;
       vertical = v;
    }
    
    if(isBoxInsideBoxes(new Box2(pos.x, pos.y  + vertical, tankWidth, tankSize, tankAngle), aCollision))
    { // if next vertical step hits a wall
      pos.y -= vertical; // push away from the wall
      vertical = round(random(0, -1)) * vertical; // next vertical motion is either nothing or the opposite way
      //horizontal = round(random(0, -1)) * horizontal;
    } else { // if not hitting a wall move
      pos.y += vertical;
    }
    if(isBoxInsideBoxes(new Box2(pos.x + horizontal, pos.y, tankWidth, tankSize, tankAngle), aCollision))
    { // if next vertical step hits a wall
      pos.x -= horizontal; // push away from the wall
      horizontal = round(random(0, -1)) * horizontal; // next horizontal motion is either nothing or the opposite way
      //vertical = round(random(0, -1)) * vertical;
    } else { //if not hitting a wall move
      pos.x += horizontal;
    }
    
    if(random(0,1) < 0.01)
    { // random chance of flipping direction
      horizontal = round(random(-1,1)) * vertical;
    } else if(random(0,1) < 0.01) {
    // random chance of flipping direction
      vertical = round(random(-1,1)) * horizontal;
    } else if(random(0,1) < 0.01) {
     // random chance of flipping direction
      vertical = round(random(-1,0)) * vertical;
    } else if(random(0,1) < 0.01) {
     // random chance of flipping direction
      horizontal = round(random(-1,0)) * horizontal;
    } else if(random(0,1) < 0.005) {
     // random chance of flipping direction
      vertical = width/400;
    } else if(random(0,1) < 0.005) {
     // random chance of flipping direction
      horizontal = width/400;
    }
     
  }
  
  void patrol(boolean rightLeft, Box2[] aCollision)
  { // moves right/left or up/down between walls 
    if(rightLeft == true)
    {// if set to patrol left and right
      if(horizontal == 0) // if not already moving left or roght start moving right
      {
        horizontal =width/400;
      }
      if(vertical != 0) // if moving up or down, stop
      {
        vertical = 0;
      }
      
      if(!isBoxInsideBoxes(new Box2(pos.x + horizontal, pos.y , tankWidth, tankSize, tankAngle), aCollision)) // check for collision, if none move
      {
        pos.x += horizontal;
      }
      else // if collision change direction
      {
        horizontal = -horizontal;
      }
    }
    else
    {// if set to patrol left and right
      if(horizontal != 0) // if not already moving left or roght start moving right
      {
        horizontal = 0;
      }
      if(vertical == 0) // if moving up or down, stop
      {
        vertical = width/400;
      }
      
      if(!isBoxInsideBoxes(new Box2(pos.x, pos.y  + vertical, tankWidth, tankSize, tankAngle), aCollision)) // check for collision, if none move
      {
        pos.y += vertical;
      }
      else // if collision change direction
      {
        vertical = - vertical;
      }
      
    }
    
  }
  
  void setMine()
  {
    mines[currentMine] = new Mine(pos.x, pos.y, tankSize/2, true);
    currentMine = (currentMine +1) % mines.length;
    if(!muted)
    {
      setMine.play();
    }
  }
    
  void shootBullet()
    {
      if(millis() - bulletTimer > coolDown)
      {
        bulletTimer = millis(); // reset timer 
        // shoots bullet 
        bullets[currentBullet] = new Bullet(pos.x + barrelLength * cos(ang), pos.y + barrelLength * sin(ang), barrelWidth* 8/10.0, barrelWidth*1.5); // creates bullet
        bullets[currentBullet].ang = ang; // gives bullet angle the angle of the barrel
        bullets[currentBullet].setVelocity(1); // sets bullet velocity 
        currentBullet = (currentBullet + 1)%bullets.length;
        if(AI == 3 || AI == 5)
        {
          if(!muted)
          {
            canonSound.play();
          }
        }
      }
    }
  
  int Update(Box2[] walls, Bullet[] playerBullets, Mine[] playerMines)
  {
    if(!dead)
    {
       // move towards target
       moveBarrel(); 
       
       if(AI == 1)
       {
         patrol(true, walls);
       } 
       
       if(AI == 2)
       {
         patrol(false, walls);
       }
       if(AI == 4 || AI == 5)
       {
         search(walls);
       }
    }
    
    if(AI == 5)
    { // if boss, handle animations 
      if(health == 2)
      {
        smoke.anime = true;
      } else if(health == 1){
        smoke.anime = false;
        fire.anime = true;
      }
      
      if(random(0,1) < 0.01)
      {
        setMine();
      }
       
      for(Mine mine: mines)
      {
        if(mine != null)
        {
          mine.Update();
        }
      }
    }
   
    
     // update bullet location
    for(int i = 0; i < bullets.length ; i++)
    {
      if(bullets[i] != null) // skip if bullet is null
      { 
        if(isBoxInsideBoxes(bullets[i].hitBox, walls) && AI != 3 && AI !=5) // if the bullet hits a wall dissappear
        {
          bullets[i] = null;
        }
        else
        {
          bullets[i].Update();
        }
      }
    }
    
    // handeling being hit by a bullet or mine 
    int bulletCollision = isBulletsInsideBox(new Box2(pos.x, pos.y , tankWidth, tankSize, tankAngle), playerBullets);
    int mineCollision = isMinesInsideBox(new Box2(pos.x, pos.y , tankWidth, tankSize, tankAngle), playerMines);
    
    if(bulletCollision >= 0)
    {
      hitMark.anime = true;
      bulletHit = true;
      return bulletCollision;
    } else if(mineCollision >= 0) {
      hitMark.anime = true;
      mineHit = true;
      return mineCollision;
    } else {
      return bulletCollision;
    }
  }
}
