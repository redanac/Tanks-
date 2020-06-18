

class Enemies
{
  Enemy[] myEnemies; // stores ene,ies
  int AliveCount;
  Explosion explosion;
  int xs = 0; // x position of explosion
  int ys = 0; // y position of explosion

  Enemies(int aCount)
  {
    
    AliveCount = aCount;
    
    myEnemies = new Enemy[aCount];
    
    //for(int i = 0; i < myEnemies.length; i++)
    //{
    //  float x = random(100, 500);
    //  float y = random(100, 500);
    //  myEnemies[i] = new Enemy(x,y, int(random(0,3)));
    //}    
  }
  
  void Update(Box2[] walls, Bullet[] playerBullets, Mine[] playerMines)
  {
    for(int i = 0; i < myEnemies.length; i++)
     {
      if(myEnemies[i] != null)
      {
        if(myEnemies[i].dead && myEnemies[i].explosion.index == 15)
        {
          myEnemies[i] = null;
        } else {
          int collision = myEnemies[i].Update(walls, playerBullets, playerMines);
          if(collision >= 0 && !myEnemies[i].explosion.anime )
          {
            myEnemies[i].health --;
            if(!muted)
            {
              hitMarker.play();
            }
            if(myEnemies[i].health <= 0)
            {
              myEnemies[i].dead = true;
              myEnemies[i].explosion.anime = true;
              if(!muted)
              {
                explosionSound.play();
              }
              AliveCount--; 
            }
            if(myEnemies[i].bulletHit)
            {
              playerBullets[collision] = null; // if bullet hits null bullet
              myEnemies[i].bulletHit = false;
            }
            if(myEnemies[i].mineHit)
            {
              playerMines[collision] = null; // if mine hits null mine
              myEnemies[i].mineHit = false;
            }
          } 
        }
      }
    }
  }
  
  void aim(float aX, float aY)
  {
    for(int i = 0; i < myEnemies.length; i++)
    {
      if(myEnemies[i] != null)
      {
        myEnemies[i].aim(aX, aY);
      }
    }
  }
  
  void nullBullets()
  {
    for(int i = 0; i < myEnemies.length; i++)
    {
      if(myEnemies[i] != null)
      {
        myEnemies[i].nullBullets();
      }
    }
  }
  
  void Draw()
  {
    for(int i = 0; i < myEnemies.length; i++)
    {
      if(myEnemies[i] != null)
      {
        myEnemies[i].drawTank();
      }
    }
  }
}
