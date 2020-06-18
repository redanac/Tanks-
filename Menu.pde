class Menu 
{
  PImage menuPic;
  PFont menuFont;
  Box2[] options;
  color bgcolour = color(134, 180, 126); // background colour for now 
  String[] menuText = {"Start", "Level Editor", "Load Level"};
  int menuTextWidth = width/ 15; 
  int titleWidth = width/10;
  String title = "TANKS";
  float[] Scale = {1, 1, 1};
  int mouseOver = -1; // which option is the mouse currently over
  float grow = 0;
  float posX; // x position of menu options
  PFont mono;
  String signature = "A Game By Redha Nacef";
  PImage[] speaker = new PImage[2];
  //int speakerIdx;
  float speakerBoxSize = 30;
  Box2 speakerBox;
  float speakerIconPosX;
  float speakerIconPosY;
  String bestTimeString; //contains string to display in menu
  float[] bestTimeFloat = new float[3]; // contains the best time as a float in seconds at 0, at 1 contains best time minutes and at 2 contains the left over seconds
  String[] bestTime; // contains current best time in string form in seconds
  String bestTimeFile = "highscore.txt";

  Menu()
  {
    speaker[0] = loadImage("speaker.png");
    speaker[1] = loadImage("speaker-off.png");
    speakerIconPosX = 1.25 * speakerBoxSize;
    speakerIconPosY = height - 1.25 * speakerBoxSize;
    speakerBox = new Box2(speakerIconPosX, speakerIconPosY, speakerBoxSize, speakerBoxSize, 0);
    mono = createFont("Arial", 48, true);
    menuFont = createFont("Stencil", 48, true);
    options = new Box2[menuText.length];
    textFont(menuFont, menuTextWidth);
    posX = width * 6.8/10.0;
    for (int i = 0; i < options.length; i++)
    {
      options[i] = new Box2(posX, height*(2*i+4)/10, height/15, textWidth(menuText[i]), 0);
    }
    menuPic = loadImage("tanksMenuScreen.png");
    bestTime = loadStrings(bestTimeFile);
    bestTimeFloat[0] = float(bestTime[0]); // store best time seconds 
    bestTimeFloat[1] = floor(bestTimeFloat[0]/60.0); // calculates minutes
    bestTimeFloat[2] = (bestTimeFloat[0]) % 60.0; // calculates left over seconds
    bestTimeString = "Best Time: " +  nf(bestTimeFloat[1], 2, 0) + ":" + nf(bestTimeFloat[2], 2, 2); 
  }

  void Draw()
  {
    if(newHighScore)
    {
      bestTime = loadStrings(bestTimeFile);
      bestTimeFloat[0] = float(bestTime[0]); // store best time seconds 
      bestTimeFloat[1] = floor(bestTimeFloat[0]/60.0); // calculates minutes
      bestTimeFloat[2] = (bestTimeFloat[0]) % 60.0; // calculates left over seconds
      bestTimeString = "Best Time: " +  nf(bestTimeFloat[1], 2, 0) + ":" + nf(bestTimeFloat[2], 2, 2); 
      newHighScore = false;
    }
    gameWinMusic.stop();
    imageMode(CORNER);
    image(menuPic, 0, 0);
    textAlign(CENTER);
    fill(255);
    textFont(menuFont, titleWidth);
    text(title, width/5, height/5);
    textFont(menuFont, menuTextWidth);
    //fill(255,0,0);
    for (int i = 0; i < menuText.length; i++)
    {
      fill(255);
      options[i].Height = textAscent() * Scale[i]; // scales box to text size
      options[i].Width = textWidth(menuText[i]) * Scale[i]; // scales box to text size
      pushMatrix();
      translate(posX, height*(2*i+4)/10 + textAscent()/2 * Scale[i]);
      scale(Scale[i]); // scale text
      fill(0);
      text(menuText[i], 0, 0);
      popMatrix();
    }
    textFont(mono, 18);
    text(signature, width - textWidth(signature)/1.5, height - textAscent() );
    imageMode(CENTER);
    image(speaker[speakerIdx], speakerIconPosX, speakerIconPosY, speakerBoxSize, speakerBoxSize );
    textSize(24);
    text(bestTimeString, width - 0.5*textWidth(bestTimeString) - width/40, textAscent());
    textFont(menuFont);
    
  }

  void whenMouseOver(int aX, int aY)
  { // changes mouseOver to what ever mouse is currently hovering over
    boolean isOnOption = false; // is mouse currently over an option
    for (int i = 0; i < options.length; i++)
    {
      if (isPointInsideBox(aX, aY, options[i]))
      {
        isOnOption = true; // mouse is over an option
        mouseOver = i; // store which option mouse is over
      }
    }
    if(!isOnOption)
    {
      mouseOver = -1;
    }
  }
  
  void onMouseClick(int aX, int aY) // what to do when mouse is clicked on menu 
  {
    if(mouseOver == 0) // if start is selected 
    {
      scoreRecorded = false;
      timerStart = millis();
      currentLevel = 0;
      mode = 'g';
      menuPlayed = false;
      gameLevel = new Level(arcadeLevel[currentLevel]);
      loadedLvl = gameLevel;
      player.health = player.startHealth;
      player.lives = player.startLives;
      player.move(int(loadedLvl.playerPos.x), int(loadedLvl.playerPos.y)); 
      player.nullBullets();
      player.fire.anime = false;
      player.smoke.anime = false;
      gameover.anime = false;
      gameover.countFrames = 0;
      gameover.index = 0;
      gameover.dropIndex = 0;
      gameover.letterCount = 0;
      complete.gameComplete = false;
      missionFailPlayed = false;
      if(!muted)
      {
        movingSound.loop(1, 0.1);
      }
      menuMusic.stop();
      levelNo.anime = true;
    }
    
    if(mouseOver == 1)
    {
       mode = 'l';
       menuMusic.stop();
       menuPlayed = false;
    }
    
    if(mouseOver == 2) // if load level is selected 
    {
      mode = 'c';
      menuMusic.stop();
      menuPlayed = false;
      playerLvl = new Level(file);
      loadedLvl = playerLvl;
      player.health = player.startHealth;
      player.lives = player.startLives;
      player.move(int(loadedLvl.playerPos.x), int(loadedLvl.playerPos.y)); 
      player.nullBullets();
      player.fire.anime = false;
      player.smoke.anime = false;
      gameover.anime = false;
      gameover.countFrames = 0;
      gameover.index = 0;
      gameover.dropIndex = 0;
      gameover.letterCount = 0;
      complete.gameComplete = false;
      missionFailPlayed = false;
      if(!muted)
      {
        movingSound.loop(1, 0.1);
      }
    }
     if(isPointInsideBox(aX, aY, speakerBox))
    {
      speakerIdx = (speakerIdx + 1) % 2;
      if(muted)
      {
        muted = false;
        menuMusic.loop(1.5, 0.1);
      } else {
        muted = true;
        menuMusic.pause();
      }
    }
  }

  void expandText(int aIndex)
  {// Quickly expand text and hitbox then shrink a little
    if (aIndex >= 0 && aIndex <= 2)
    { // animation for expanding text
      if(Scale[aIndex] == 1)
      {
        grow = 0.1;
      }
      if(Scale[aIndex] > 1.6)
      {
        grow = -0.02;
      }
      if(Scale[aIndex] < 1.4 && grow < 0)
      {
        grow = 0;
      }
      Scale[aIndex] += grow;
    }
    for(int i = 0; i < menuText.length; i++)
    { // if mouse is not over you, reset scale
      if(i != aIndex)
      {
        Scale[i] = 1;
      }
    }
  }

  void Update(int aX, int aY)
  {
    //println(mouseOver);
    whenMouseOver(aX, aY);
    expandText(mouseOver);
  }
}
