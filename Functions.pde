void recordHighScore()
{
  if(levelDone && complete.gameComplete && !scoreRecorded)
  {
    timerEnd = millis();
    time[0] = (timerEnd - timerStart)/1000.0; // timeplayed in seconds
    time[1] = floor(time[0]/60.0); // calculates minutes
    time[2] = (time[0]) % 60.0; // calculates left over seconds
    if(time[0] < menu.bestTimeFloat[0])
    { // if new best time
      newHighScore = true;
      String[] newBestTime = {str(time[0])};
      saveStrings("data/highscore.txt" , newBestTime);
    }
    scoreRecorded = true; // makes sure tie recorded once only
  }
}


void gamedOver(char aKey) // 
{ // return to menu
  if(aKey == 'm' && lostAllLives)
  {
    mode = 'm';
    gameover.anime = false;
    lostAllLives = false;
  }
}

void lostLife(Player aPlayer)
{
  if(aPlayer.playerExplosion.index == 15)
  {
    loadedLvl.enemies.nullBullets();
    aPlayer.lives --;
    aPlayer.move(int(loadedLvl.playerPos.x), int(loadedLvl.playerPos.y));
    aPlayer.health = aPlayer.startHealth;
    aPlayer.playerExplosion.index = 0;
  }
}


void nextLevel(char aChar)
{
  if(levelDone && aChar == ' ')
  {
    playSound = false;
    if(currentLevel < arcadeLevel.length - 1 && mode == 'g')
    {
      currentLevel ++;
      levelNo.anime = true; // print the level youre on
      if(currentLevel == 8)
      {
        player.lives ++;
        player.health = player.startHealth;
      }
      loadedLvl = new Level(arcadeLevel[currentLevel]);
      player.move(loadedLvl.playerPos.x, loadedLvl.playerPos.y); 
      player.nullBullets();
      if(currentLevel == arcadeLevel.length - 1)
      {
        complete.gameComplete = true;
      }
    } else {
      mode = 'm';
    }
    levelDone = false;
    complete.anime = false;
    complete.letterCount = 0;
  }
}


void pause(char aKey, int aX, int aY)
{ 
  if(aKey == 'p')
  {
    if(paused && !mousePressed)
    {
      paused = false;
      if(!muted)
      {
        movingSound.loop(1, 0.1);
      }
      levelNo.anime = true;
      levelNo.anime = false;
      howToPlay.move(width - howToPlay.boxWidth/2 - 1.25 * width/40, howToPlay.boxHeight/2 + 1.25 * width/40);
    } else if(!paused && !mousePressed){
      paused = true;
      movingSound.stop();
      levelNo.anime = true;
      howToPlay.move(width - howToPlay.boxWidth/2 - 1.25 * width/40, height - howToPlay.boxHeight/2 - 1.25 * width/40); 
    } else if(paused && mousePressed) {
      if(isPointInsideBox(aX, aY, speakerBox))
      {
        speakerIdx = (speakerIdx + 1) % 2;
        if(muted)
        {
          muted = false;
          movingSound.loop(1, 0.1);
        } else {
          muted = true;
          movingSound.stop();
        }
      }
    } 
  }
  
  if(paused && aKey == 'm')
  {
    mode = 'm';
    paused = false;
    howToPlay.move(width - howToPlay.boxWidth/2 - 1.25 * width/40, howToPlay.boxHeight/2 + 1.25 * width/40);
  }
}

void drawPaused()
{ // draws pause screen 
  fill(100,100,100, 100);
  rect(0, 0, width, height);
  textAlign(CENTER);
  fill(0);
  textSize(32);
  text("Paused", width/2, height/2);
  textSize(18);
  text("Press 'm' to return to main menu", width/2, height/2 + 2*textAscent());
  imageMode(CENTER);
  image(speaker[speakerIdx], speakerIconPosX, speakerIconPosY, speakerBoxSize, speakerBoxSize );
  
}


void showCorners(float aX, float aY, float aWidth, float aHeight, float aAng)
{ // draws circles at corners of tank that go into collision detection
  float theta = - atan(aHeight/aWidth); // angle between x axis and the corners
  float d = sqrt(sq(aHeight/2) + sq(aWidth/2)); // length of diagonal of tank base from centre
  
  circle(aX + d * cos(theta + aAng), aY + d * sin(theta + aAng), 10); // top right 
  circle(aX + d * cos(-theta + aAng), aY + d * sin(-theta + aAng), 10); // bottom right
  circle(aX + d * cos(PI - theta + aAng), aY + d * sin(PI - theta + aAng), 10); // top left
  circle(aX + d * cos(PI + theta + aAng), aY + d * sin(PI + theta + aAng), 10); // bottom left
}

boolean isPointInsideBox(float aX, float aY, Box2 aBox)
{
  float r = sqrt(sq(aX - aBox.x) + sq(aY - aBox.y)); // gives you the distance between new origin after translation and the point
  float theta = atanq((aX - aBox.x),(aY - aBox.y)); // angle between point and the x axis after translation
  
  // new x and y point corresponding to new coordinate system
  float x = r * cos(theta - aBox.ang); 
  float y = r * sin(theta - aBox.ang);
  
  pushMatrix();
  translate(aBox.x, aBox.y);
  rotate(aBox.ang); 
  
  // check if X and Y are in box
  boolean isXInside = x >= - aBox.Width/2 && x <= aBox.Width/2;
  boolean isYInside = y >= - aBox.Height/2 && y <= aBox.Height/2;

  popMatrix();
  
  // return true only if bothe x and y in box
  return isXInside && isYInside;

}

boolean isBoxInsideBox(Box2 aBox1, Box2 aBox2)
{ 
  if(tooFarAway(aBox1, aBox2))
  {
    return false;
  }
  
  // checks if two boxes collide
  for(PVector cnr: aBox1.cnrs)
  {
    if(isPointInsideBox(cnr.x,cnr.y,aBox2))
    {
      return true;
    }
  }
  
  for(PVector cnr: aBox2.cnrs)
  {
    if(isPointInsideBox(cnr.x,cnr.y,aBox1))
    {
      return true;
    }
  }
  
  return false;
}

boolean isBoxInsideBoxes(Box2 aBox,Box2[] aCollision)
{
  boolean collision = false;
      
  for(Box2 box: aCollision)
  {
    if(isBoxInsideBox(aBox, box))
    {
      collision = true;
      return collision;
    }
  }
  return collision; 
}

int isBulletsInsideBox(Box2 aBox, Bullet[] bullets)
{     
  for(int i = 0; i < bullets.length; i++)
  {
    if(bullets[i] != null)
    {
      if(isBoxInsideBox(bullets[i].hitBox, aBox))
      {
        return i ;
      }
    }
  }
  return -1; 
}

int isMinesInsideBox(Box2 aBox, Mine[] mines)
{     
  for(int i = 0; i < mines.length; i++)
  {
    if(mines[i] != null)
    {
      if(isBoxInsideBox(mines[i].hitBox, aBox))
      {
        return i ;
      }
    }
  }
  return -1; 
}


  
  
boolean tooFarAway(Box2 aBox1, Box2 aBox2)
{
  
  float  maxDistance = sqrt(sq(0.5 * aBox1.Width) + sq(0.5 * aBox1.Height)) + sqrt(sq(0.5 * aBox2.Width) + sq(0.5 * aBox2.Height)); // over max distance possible between centres that one box can still be in another 
  float  actualDist = sqrt(sq(aBox1.x - aBox2.x) + sq(aBox1.y - aBox2.y));
  
  if(maxDistance < actualDist) // if actual distance is less than the max distance between centres then one can't be in another and the boxes are too far away.
  {
    return true;
  }
  
  return false;
}




    
float atanq(float aX, float aY)
// takes x and y coordinate and returns angle positive from the real axis 
{
  float ang;
  // edge case when aX = 0
  if(aX == 0)
  {
    if(aY>0)
    {
      ang = radians(90);
    }
    else
    {
      ang = radians(270);
    }
  } 
  // dealing with different quadrants
  else if(aX > 0)
  {
    if(aY > 0)
    {
      ang = atan(aY/aX);
    }
    else
    {
      ang = 2*PI + atan(aY/aX);
    }
  }
  else 
  {
    //if(aX < 0)
    float theta = atan(aY/aX);
    ang = PI + theta;
  }
  return ang;
}

void grid(float dx, float dy)
// Draws a grid with column width dx and row height dy 
{ 
  strokeWeight(1);
  stroke(0);
  for(int i = 0 ; i < width/dx ; i++)
  {
    line(i * dx, 0, i * dx, height);
  }
  
   for(int i = 0 ; i < height/dy ; i++)
  {
    line(0, i * dy,  width, i * dy);
  }
  
}
