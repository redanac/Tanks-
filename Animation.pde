class Explosion
{
  int count; // counts frames
  int index; // index for which animation 
  PImage explosions = loadImage("explosions.png");// sprite sheet for explosion 
  PImage[] sprites; // array that holds the sprites
  int W = explosions.width/16; // width of one sprite
  int H = explosions.height/8; // height of one sprite
  boolean anime = false; // whether animation is currently running or not
  int fps;

  Explosion(int aFPS)
  {

    fps = int(frameRate /aFPS);
    count = 0; // initialaise count 
    index = 0; // initialise index

    sprites = new PImage[16];

    // load sprites in array
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 2; j++) {
        if (j == 0)
        {
          sprites[i] = explosions.get((15-i)*W, 4*H, W, H);
        } else
        {
          sprites[i] = explosions.get(i*W, 5*H, W, H);
        }
      }
    }
  }

  void animate(int aX, int aY)
  {
    if (anime)
    {
      imageMode(CENTER);
      image(sprites[index], aX, aY);
      count ++;
      if(fps == 0);
      {
        fps = 1;
      }
      if (count % fps == 0 && index < sprites.length)
      {
        index = (index + 1);
      }
      if (index >= sprites.length)
      {
        index = 0;
        anime = false;
      }
    }
  }
}

class Smoke
{
  int count; // counts frames
  int index = 0; // index for which animation 
  PImage smoke = loadImage("smoking.png");// sprite sheet for explosion 
  PImage[] sprites; // array that holds the sprites
  int nW = 5; // number of sprites in a row
  int nH = 1; // number of sprites in a column
  int W = smoke.width/nW; // width of one sprite
  int H = smoke.height/nH; // height of one sprite
  boolean anime = false; // whether animation is currently running or not
  int fps;

  Smoke(int aFPS)
  {

    fps = int(frameRate /aFPS);
    count = 0; // initialaise count 
    index = 0; // initialise index

    sprites = new PImage[nH*nW];

    // load sprites in array
    for (int i = 0; i < nW; i++)
    {
      sprites[i] = smoke.get(i*W, 0, W, H);
    }
  }

  void animate(int aX, int aY, float ang)
  {
    if (anime)
    {
      imageMode(CENTER);
      translate(aX, aY);
      rotate(ang -PI/2);
      translate(0, -32);
      image(sprites[index], 0, 0, 32, 64);
      count ++;
      if (count % fps == 0)
      {
        index = (index + 1) % sprites.length;
      }
    }
  }
}

class Fire
{
  int count; // counts frames
  int index = 0; // index for which animation 
  PImage fire = loadImage("fire.png");// sprite sheet for explosion 
  PImage[] sprites; // array that holds the sprites
  int nW = 8; // number of sprites in a row
  int nH = 4; // number of sprites in a column
  int W = fire.width/nW; // width of one sprite
  int H = fire.height/nH; // height of one sprite
  boolean anime = false; // whether animation is currently running or not
  int fps;

  Fire(int aFPS)
  {
    fps = int(frameRate /aFPS);
    count = 0; // initialaise count 
    index = 0; // initialise index

    sprites = new PImage[nH*nW];

    // load sprites in array
    for (int j = 0; j < nH; j++) {
      for (int i = 0; i < nW; i++)
      {
        int idx = j * nW + i;
        sprites[idx] = fire.get(i*W, j*H, W, H);
        //image(sprites[idx], i*W, j*H, 32, 32);
      }
    }
  }

  void animate(int aX, int aY, float ang)
  {
    if (anime)
    {
      imageMode(CENTER);
      translate(aX, aY);
      rotate(ang);
      translate(0, -20);
      image(sprites[index], 0, 0, 32, 64);
      count ++;
      if (count % fps == 0)
      {
        index = (index + 1) % sprites.length;
      }
    }
  }
}

class levelComplete
{
  int countFrames; // counts frames
  int letterCount; // count letters currently shown
  int index; // index for which animation 
  boolean anime = false; // whether animation is currently running or not
  float fps;
  String[] text = {"LEVEL COMPLETE", "Well done soldier, \n all levels complete"};
  String[] text2 = {"Press space to continue", "RTB & crack open a cold 1 w/ the boys"};
  int idx;
  boolean gameComplete; // checks if all levels have been completed

  levelComplete(float aFPS, boolean aGameComplete )
  {
    fps = frameRate /aFPS;
    countFrames = 0; // initialaise count 
    index = 0; // initialise index
    letterCount = 0;
    gameComplete = aGameComplete;
    if (gameComplete)
    {
      idx = 1;
    } else {
      idx = 0;
    }
  }

  void animate()
  {
    if (anime)
    {
      if (gameComplete)
      {
        idx = 1;
      } else {
        idx = 0;
      }
      textAlign(CENTER);
      textSize(48);
      fill(100, 100, 100, 100);
      rect(0, 0, width, height);
      fill(#174D00);
      text(text[idx].substring(0, letterCount), width/2, height/2 - idx/3 * height);
      countFrames ++;
      if (countFrames % fps == 0)
      {
        index = (index + 1);
        if (letterCount < text[idx].length())
        {
          letterCount ++;
        }
      }
      if (letterCount == text[idx].length())
      {
        textSize(32);
        if(gameComplete)
        {
          fill(255);
          text("Time: " +  nf(time[1], 2, 0) + ":" + nf(time[2], 2, 2), width/2, height * 7/10.0);
          if(newHighScore)
          {
            text("NEW BEST TIME!!!!!", width/2, height * 8/10);
          }
        }
        fill(#174D00);
        text(text2[idx], width/2, height * 9/10);
      }
    }
  }
}

class GameOver
{
  int countFrames; // counts frames
  int letterCount; // count letters currently shown
  int index; // index for which animation
  int dropIndex; // frame count for drop screen
  boolean anime = false; // whether animation is currently running or not
  float fps;
  String text = "GAME OVER";
  String rtb = "Pathetic, press m to RTB for resupply";
  int dropSpeed = height/10;

  GameOver(float aFPS)
  {
    fps = frameRate /aFPS;
    countFrames = 0; // initialaise count 
    index = 0; // initialise index
    letterCount = 0;
  }

  void animate()
  {
    if (anime)
    {
      textAlign(CENTER);
      textSize(60);
      fill(#B91818, 100);
      if (index*dropSpeed < height)
      {
        rect(0, - height + index * dropSpeed, width, height);
      } else {
        rect(0, 0, width, height);
        fill(#EDD0D0);
        text(text.substring(0, letterCount), width/2, height/2);
        countFrames ++;
      }
      if (countFrames % fps == 0)
      {
        index = (index + 1);
        if (letterCount < text.length() && index*dropSpeed > height)
        {
          letterCount ++;
        }
      }
      if (letterCount == text.length())
      {
        textSize(32);
        text(rtb, width/2, height * 5/6);
      }
    }
  }
}

class hitmark
{
  int count; // frame count
  PImage hitmarker;
  float duration; // number of frames to stay on
  boolean anime = false;
  int Size;

  hitmark(float aDuration) // how long to stay in milliseconds
  {
    duration = 60.0/1000.0 * aDuration;
    hitmarker = loadImage("hitmarker.png");
    Size = width/20 * 6/10;
    hitmarker.resize(Size, Size);
    
  }

  void animate(float aX, float aY)
  {
    if (anime)
    {
      image(hitmarker, aX, aY);
      count ++;
      if (count > duration)
      {
        anime = false;
        count = 0;
      }
    }
  }
}

class showLevel
{
  int count;
  float duration; // number of frames it stays for
  String level = "Level ";
  boolean anime = false;
  
  showLevel(float aDuration)
  { // how long you want it to show for in seconds
    duration = 60.0 * aDuration; // 60 fps times the seconds to show
  }
  
  void animate(int currentLevel, int aX, int aY, boolean timed)
  { // if timed false then level stays on unless told other wise 
    if(anime)
    {
      textSize(32);
      fill(0,0,0);
      textAlign(CENTER);
      text(level + str(currentLevel), aX, aY);
      if(timed)
      { // if timed this deals with timing
        count ++;
        if(count > duration)
        {
          anime = false;
          count = 0;
        }
      }
    }
  }
  
}
