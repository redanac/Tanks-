import processing.sound.*;
SoundFile explosionSound;
SoundFile shootSound;
SoundFile lvlCompleteSound;
SoundFile canonSound;
SoundFile hitMarker;
SoundFile damageSound;
SoundFile setMine;
SoundFile missionFailed;
SoundFile movingSound;
SoundFile menuMusic;
SoundFile gameWinMusic;



Player player;
int[] level; // stores binary for level
levelEditor edit;
Level loadedLvl; // level that is currently going to be played
Level playerLvl; // level from the level editer
Level gameLevel; // level made for arcade mode
Menu menu;
String file = "level.txt"; // stores the level to be loaded
String[] arcadeLevel; // stores the level to be loaded
char mode = 'm'; // which mode are we in. 'l' for level editor and 'g' for game
boolean paused = false;
int currentLevel = 0;
levelComplete complete;
boolean levelDone = false; 
boolean lostAllLives = false;
GameOver gameover;
legend howToPlay;
legend howToMine;
boolean gameComplete = false;
int numberOfLevels = 10;
boolean playSound = false;
boolean missionFailPlayed = false;
boolean menuPlayed = false;
showLevel levelNo;
boolean muted = false;
PImage[] speaker = new PImage[2];
int speakerIdx;
float speakerBoxSize = 30;
Box2 speakerBox;
float speakerIconPosX;
float speakerIconPosY;
float timerStart;
float timerEnd;
float time[] = new float[3]; // at 0 has the whole time in seconds, at 1 and 2 it keeps minutes and the leftover seconds respectively
String[] timeString = new String[1];
boolean scoreRecorded = false;
boolean newHighScore = false; // if theres been a new highscore

void setup()
{
  //fullScreen();
  size(800,580);
  frameRate(60);
  menu = new Menu();
  //playerLvl = new Level(file);
  //gameLevel = new Level(arcadeLevel);
  player = new Player(0, 0, 1);  
  edit = new levelEditor();
  complete = new levelComplete(20, false);
  gameover = new GameOver(20);
  howToPlay = new legend(0, 0, 1);
  howToMine = new legend(0, 0, 2);
  howToPlay.move(width - howToPlay.boxWidth/2 - 1.25 * width/40, howToPlay.boxHeight/2 + 1.25 * width/40);
  howToMine.move(width - howToPlay.boxWidth/2 - 1.25 * width/40, howToPlay.boxHeight/2 + 1.25 * width/40);
  arcadeLevel = new String[numberOfLevels];
  for(int i = 0; i < arcadeLevel.length; i++)
  { // put alll the level names in string array
    arcadeLevel[i] = "level_" + str(i+1) + ".txt";
  }
  levelNo = new showLevel(3);  
   
  
  // sound handling 
  
  explosionSound = new SoundFile(this, "tank_explosion.wav");
  shootSound = new SoundFile(this, "projectile.wav");
  lvlCompleteSound = new SoundFile(this, "levelComplete.wav");
  canonSound = new SoundFile(this, "canonSound.wav");
  canonSound.rate(2);
  canonSound.amp(0.25);
  hitMarker = new SoundFile(this, "hitMarker.mp3");
  damageSound = new SoundFile(this, "cracked.wav");
  setMine = new SoundFile(this, "setMine.wav");
  setMine.rate(2);
  missionFailed = new SoundFile(this, "mission_failed.mp3");
  movingSound = new SoundFile(this, "engineSound.wav");
  menuMusic = new SoundFile(this, "menuMusic.wav");
  gameWinMusic = new SoundFile(this, "gameComplete.mp3");
  gameWinMusic.rate(2);
  speaker[0] = loadImage("speaker.png");
  speaker[1] = loadImage("speaker-off.png");
  speakerIconPosX = 1.25 * speakerBoxSize;
  speakerIconPosY = height - 1.25 * speakerBoxSize;
  speakerBox = new Box2(speakerIconPosX, speakerIconPosY, speakerBoxSize, speakerBoxSize, 0);
}


void keyTyped()
{ 
  
  if(mode == 'g' || mode == 'c')
  {
    if(!paused)
    {
      player.OnKeyTyped(key);
    }
    pause(key, mouseX, mouseY);
    nextLevel(key);
    gamedOver(key);
  }
  
  if(mode == 'l')
  {
    edit.saveLevel(key); 
    edit.onKeyTyped(key);
  }
}

void keyReleased()
{
  if(mode == 'g' || mode == 'c')
  {
    player.OnKeyReleased(key);
  }
}

void mouseDragged()
{ 
  // Game
  if(mode == 'g' || mode == 'c')
  {
    if(!paused)
    {
      player.shootBullet();
    }
  }
  
  if(mode == 'l')
  {
    if(edit.saveScreen ==false)
    {
      // Makes sure it wont crash when mouse is dragged out of bound 
      // Level Editor
      edit.onLeftClick(mouseButton); // adds a block   
      edit.onRightClick(mouseButton); // removes a block
      
      
    }
  }
}

void mousePressed()
{
  // Menu 
  
  if(mode == 'm')
  {
    menu.onMouseClick(mouseX, mouseY);
  }
  
  // Game
  if(mode == 'g' || mode == 'c')
  {
    if(!paused)
    {
      player.shootBullet(); 
    } else {
      pause(key, mouseX, mouseY);
    }
  }
  if(mode == 'l')
  {
    if(edit.saveScreen ==false)
    {
       // Level Editor
      edit.onLeftClick(mouseButton);    
      edit.onRightClick(mouseButton);
    }
  }
}

void draw()
{ 
  if(mode == 'm')
  {
    clear();
    if(!menuPlayed)
    {
      if(!muted)
      {
        menuMusic.loop(1.5, 0.1);
      }
      menuPlayed = true;
    }
    movingSound.stop();
    menu.Draw();
    menu.Update(mouseX, mouseY);
    
  }
  if(mode == 'g' || mode == 'c')
  {
    if(mode == 'g')
    {
      recordHighScore();
    }
    //println(loadedLvl.enemies.AliveCount);
    if(loadedLvl.enemies.AliveCount != 0 && player.lives >= 0)
    {
    clear();
    if(!paused)
    {
      player.Update(loadedLvl.walls, loadedLvl.enemies);
      loadedLvl.enemies.Update(loadedLvl.walls, player.bullets, player.mines);
      loadedLvl.enemies.aim(player.pos.x, player.pos.y);
      lostLife(player);
    
    }
    loadedLvl.Draw(); // level needs to be drawn first
    loadedLvl.enemies.Draw();
    player.drawTank();
    complete.animate();
    if(currentLevel == 0 && mode == 'g')
    {
      howToPlay.Draw(mouseX, mouseY);
    }
    if(currentLevel == 7 && mode == 'g')
    {
      howToMine.Draw(mouseX, mouseY);
    }
    if(currentLevel == 8 && mode == 'g')
    {
      howToMine.changeMode(3);
      howToMine.Draw(mouseX, mouseY);
    }
    levelNo.animate(currentLevel + 1, width/2, height/8, true);
    
    
    
    if(paused)
    {
      drawPaused();
      howToPlay.Draw(mouseX, mouseY); 
      levelNo.animate(currentLevel + 1, width/2, height/8, false);
    }
    
    } else {
      clear();
      loadedLvl.Draw(); // level needs to be drawn first
      loadedLvl.enemies.Draw();
      complete.animate();
      loadedLvl.enemies.Update(loadedLvl.walls, player.bullets, player.mines);
      if(loadedLvl.enemies.AliveCount <= 0)
      {
        player.drawTank();
        complete.anime = true;
        if(!playSound)
        {
          if(currentLevel != numberOfLevels - 1)
          {
            if(!muted)
            {
              lvlCompleteSound.play();
            }
          } else {
            if(!muted)
            {
              gameWinMusic.play();
            }
          }
          playSound = true;
        }
        player.nullBullets();
        levelDone = true;
        
      } else {
        gameover.anime = true;
        if(!missionFailPlayed)
        {
          if(!muted)
            {
               missionFailed.play();
            }
          missionFailPlayed = true;
        }
        lostAllLives = true;
        gameover.animate();
      }
    }  
  }
  
  if(mode == 'l')
  {
    clear();
    edit.Draw(mouseX, mouseY);
  }
}
