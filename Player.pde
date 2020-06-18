

class Player
{
  // position of player
  PVector pos; 
  float tankSize; // reference size for all components, the length of the tank
  float tankWidth;
  float barrelWidth; // self explanatory I hope
  float barrelLength;
  float circleSize; // size of circular base
  float x, y; // position that cannon is facing 
  float m; // gradient of line from origin to mouse
  float mx, my; // mouse position relative to translation
  char[] keys = {'a', 's', 'd', 'w'}; // stores directional keys
  boolean[] pressedKeys = {false, false, false, false}; // stores whether direction keys are pressed or not
  color tankColour = color(40, 150, 0); // colour of the tank 
  color barrelColour = color(100, 150, 50); // colour of barrel
  int direction = 0; // stores which direction tank is facing: 0 -> right/left ; 1 -> up/down; 2 -> diag right ; 3 -> diag left
  float ang = 0; // stores angle of tank barrel
  Bullet[] bullets; // Stores the bullets tank can shoot
  int currentBullet = 0; // stores the current bullet number
  Box2[] empty = new Box2[0];
  float tankAngle = 0; // stores the angle the tank is facing
  int vertical; // vertical velocity
  int horizontal; // horizontal velocity
  int coolDown = 200; // cooldown of a second between bullets
  int bulletTimer; // timer to recored how long since bullet was shot
  int health; // keeps track of players health
  boolean exploded = false;// checks if explosion is finished
  Explosion playerExplosion; // animations
  Smoke smoke;
  Fire fire;
  int lives; // number of lives player has
  int startHealth = 3;
  int startLives = 2; // number of lives player starts with 
  float size;
  boolean throughWalls = false;
  Mine[] mines; //holds all the mines
  int currentMine = 0; // current mine
  hitmark hitMark;
  float loudness = 0.1;

  int vel;


  Player(float aX, float aY, float aSize)
  {
    pos = new PVector(aX, aY);
    lives = startLives;
    size = aSize;

    tankSize = (width/20) * aSize; // reference size for all components, the length of the tank
    tankWidth = tankSize * 2.0/3.0;
    barrelWidth = tankSize*1.0/5.0; // self explanatory I hope
    barrelLength = tankSize*2.0/3.0;
    circleSize = tankSize*6.0/10.0; // size of circular base

    horizontal = 0;
    vertical = 0; 

    vel = width/250;

    bullets = new Bullet[100];
    mines = new Mine[3];

    bulletTimer = millis(); // starts above cooldown time so bullet can be shot

    health = startHealth; // start with three health points

    playerExplosion = new Explosion(20); // initialise explode animation 

    smoke = new Smoke(10); // initialise smoke animation
    fire = new Fire(30); // initialise fire animation
    hitMark = new hitmark(100);
  }

  void checkDir()
  { // checks direction of tank, see variable direction
    if (horizontal != 0 && vertical ==0)
    {
      direction = 0;  // left or right 
      tankAngle = 0;
    } else if (horizontal == 0 && vertical !=0)
    {
      direction = 1; // up or down
      tankAngle = PI/2;
    } else if ((horizontal > 0 && vertical < 0) || (horizontal < 0 && vertical > 0))
    {
      direction = 2; // up-right or down-left
      tankAngle = -PI/4;
    } else if ((horizontal < 0 && vertical < 0) || (horizontal > 0 && vertical > 0)) 
    {
      direction = 3; // up-left or down-right
      tankAngle = PI/4;
    }
  }


  void drawDiag(boolean right)
  {
    if (right)
    {
      pushMatrix();
      rotate(radians(45));
      rect(-tankWidth/2, -tankSize/2, tankWidth, tankSize );
      popMatrix();
    } else
    {
      pushMatrix();
      rotate(radians(-45));
      rect(-tankWidth/2, -tankSize/2, tankWidth, tankSize );
      popMatrix();
    }
  }

  void drawTank()
  {
    if (health > 0)
    {
      for (Mine mine : mines)
      {
        if (mine != null)
          mine.Draw();
      }
      pushMatrix();
      translate(pos.x, pos.y); // moves coordinate system so (0, 0) is the middle

      // colour and stroke width
      stroke(0);
      strokeWeight(2);
      fill(tankColour);

      checkDir(); // check direction of tank

      if (direction == 0)
      {
        rect(-tankSize *1/2, -tankWidth * 1/2, tankSize, tankWidth);
      } else if (direction == 1)
      {
        rect(-tankWidth*1/2, -tankSize * 1/2, tankWidth, tankSize);
      } else if (direction == 2)
      {
        drawDiag(true);
      } else if (direction == 3)
      {
        drawDiag(false);
      }

      drawBarrel();
      stroke(50, 50, 50);
      strokeWeight(2);
      fill(red(tankColour)+(2-health)*50, green(tankColour)-(2-health)*50, blue(tankColour));
      circle(0, 0, circleSize);
      fill(0);
      textSize(18 * size);
      textAlign(CENTER);
      text(lives, 0, size*textAscent()/2);
      smoke.animate(0, 0, tankAngle);
      fire.animate(0, 0, 0);
      //hitMark.animate(0, 0);
      popMatrix();
      hitMark.animate(pos.x + random(-hitMark.Size/5, -hitMark.Size/5 ), pos.y  + random(-hitMark.Size/10, -hitMark.Size/10 ));

      //  Draw bullets 

      for (Bullet bullet : bullets)
      {
        if (bullet != null)
        {

          bullet.Draw(throughWalls);
        }
      }
    }

    if (health <= 0)
    {
      playerExplosion.animate(int(pos.x), int(pos.y));
    }
  }

  void move(float aX, float aY)
  {// moves the tank to position aX, aY
    pos.x = aX; 
    pos.y = aY;
  }

  void drawBarrel()
  {

    pushMatrix();
    rotate(ang);
    fill(barrelColour);
    rect(0, -barrelWidth/2.0, barrelLength, barrelWidth);
    popMatrix();
  }

  void nullBullets()
  { // gets rid of all current player bullets and mines,
    for (int i = 0; i < bullets.length; i++)
    {
      bullets[i] = null;
    }
    for (int i = 0; i < mines.length; i++)
    {
      mines[i] = null;
    }
  }




  void OnKeyTyped(char aKey)
  {
    if (aKey == 'd')
    {
      horizontal = vel;
    } else if (aKey == 'a')
    {
      horizontal = -vel;
    } else if (aKey == 'w')
    {
      vertical = -vel;
    } else if (aKey == 's')
    {
      vertical = vel;
    } else if (aKey == 'c') {
      setMine();
    }


    //for(int i=0; i < keys.length; i++)
    //{
    //  if(aKey == keys[i])
    //  {
    //    pressedKeys[i] = true;
    //  }
    //}
  }

  void OnKeyReleased(char aKey)
  {
    if (aKey == 'd' && horizontal > 0)
    {
      horizontal = 0;
    } else if (aKey == 'a' && horizontal < 0)
    {
      horizontal = 0;
    } else if (aKey == 'w' && vertical < 0)
    {
      vertical = 0;
    } else if (aKey == 's' && vertical > 0)
    {
      vertical = 0;
    }

    //for(int i=0; i < keys.length; i++)
    //{
    //  if(aKey == keys[i])
    //  {
    //    pressedKeys[i] = false;
    //  }
    //}
  }

  void shootBullet()
  {
    if (millis() - bulletTimer > coolDown)
    {
      bulletTimer = millis(); // reset timer 
      // shoots bullet 
      bullets[currentBullet] = new Bullet(pos.x + barrelLength * cos(ang), pos.y + barrelLength * sin(ang), barrelWidth* 8/10.0, barrelWidth*1.5); // creates bullet
      bullets[currentBullet].ang = ang; // gives bullet angle the angle of the barrel
      bullets[currentBullet].setVelocity(5); // sets bullet velocity 
      currentBullet = (currentBullet + 1) % bullets.length;
      if(!muted)
      {
        shootSound.play();
      }
    }
  }

  void setMine()
  {
    mines[currentMine] = new Mine(pos.x, pos.y, tankSize/2, false);
    currentMine = (currentMine +1) % mines.length;
    if(!muted)
    {
      setMine.play();
    }
  }

  void Update(Box2[] walls, Enemies enemies)
  { 
    // mouse position does not change with translate so this is a conversion for x and y
    // check where mouse is pointing
    mx = mouseX - pos.x; 
    my = mouseY - pos.y; 

    ang = atanq(mx, my);

    if (health > 0)
    {
       if(vertical != 0 || horizontal != 0)
       {
         if(loudness < 0.2)
         {
           loudness += 0.01;
         }
         movingSound.amp(loudness);
       } else {
         if(loudness > 0.1)
         {
           loudness -= 0.01;
         }
         movingSound.amp(loudness);
       }
       
         
       
     
      for (Mine mine : mines)
      {
        if (mine != null)
        {
          mine.Update();
        }
      }
      if (health > 2)
      { // sorts out for coming out of menu and going back in
        smoke.anime = false;
        fire.anime = false;
      }
      // check if next step will cause collision, if so push back a little

      if (!isBoxInsideBoxes(new Box2(pos.x + horizontal, pos.y, tankWidth, tankSize, tankAngle), walls))
      {
        pos.x += horizontal;
      } else
      {
        pos.x -= horizontal;
      }

      if (!isBoxInsideBoxes(new Box2(pos.x, pos.y+vertical, tankWidth, tankSize, tankAngle), walls))
      {
        pos.y += vertical;
      } else
      {
        pos.y -= vertical;
      }

      if (bulletTimer == coolDown)
      {
        println("Bullets ready!");
      }

      // update bullet location
      for (int i = 0; i < bullets.length; i++)
      {
        if (bullets[i] != null) // skip if bullet is null
        { 
          if (isBoxInsideBoxes(bullets[i].hitBox, walls)) // if the bullet hits a wall dissappear
          {
            bullets[i] = null;
          } else
          {
            bullets[i].Update();
          }
        }
      }


      for (int i = 0; i < enemies.myEnemies.length; i ++)
      {
        if (enemies.myEnemies[i] != null)
        {
          if (enemies.myEnemies[i].AI == 5)
          {
            int mineCollision = isMinesInsideBox(new Box2(pos.x, pos.y, tankWidth, tankSize, tankAngle), enemies.myEnemies[i].mines);
            if (mineCollision >= 0) // if bullets hit, remove health point and bullet
            {
              health--;
              hitMark.anime = true;
              if(!muted)
              {
                damageSound.play();
              }
              enemies.myEnemies[i].mines[mineCollision] = null;
            }
          }
          int collision = isBulletsInsideBox(new Box2(pos.x, pos.y, tankWidth, tankSize, tankAngle), enemies.myEnemies[i].bullets);
          //println(collision);
          if (collision >= 0) // if bullets hit, remove health point and bullet
          {
            health--;
            hitMark.anime = true;
            if(!muted)
            {
              damageSound.play();
            }
            enemies.myEnemies[i].bullets[collision] = null;
          }
          if (health == 2)
          { // if hit once some smoke comes out
            smoke.anime = true;
          }
          if (health == 1)
          { // if health on one tank starts to fire
            smoke.anime = false;
            fire.anime = true;
          }
        }
      }

      if (health <= 0)
      {
        playerExplosion.anime = true;
        if(!muted)
        {
          explosionSound.play();
        }
        fire.anime = false;
      }
      //if(explosion.index == 15)
      // {
      //   println("shit");
      //   //lives --;
      //   //move(int(loadedLvl.playerPos.x), int(loadedLvl.playerPos.y));
      //   //health = 5;
      // }
    }
  }
}
