class levelEditor
  // If called, enters level editor mode
{
  float dx; // coloumn width of grid
  float dy; // row height of grid 
  int[] level; // stores binary for level
  int cols; // stores the number of columns
  int rows; // stores the number of rows
  int col; // the column that is in right now 
  int row; // the row that mouse is in right now
  int idx; // element in the level array that corresponds to the chosen grid square
  String[] lvlStr = new String[1];
  boolean saveScreen = false;
  int blockType = 1; // tracks what kind of block is being placed, 0 nothing, 1 -> block, 2 -> horizontal moving enemy, 3 -> vertical moving enemy, 4 -> stationary enemy
  Enemy enemy;
  Player player; // to draw player
  color wallColour = color(181, 77, 77);
  boolean saved = false; // cheeck if saved once in save screen
  int playerPos = -1; // logs where the players starting position is in terms of the index of the level array
  boolean wantToReset = false; //if the reset button is pressed
  legend howToEdit;
  boolean placePlayerWarning = false;
  boolean enemyPlaced = false;
  int warningCount = 0;
  int warningTime = 3*60; // time to show message, 3 seconds so 3 * 60 fps = 300 frames

  levelEditor()
  {
    dx = width/40; // column width
    dy = dx; // row height
    cols = int(width/dx); 
    rows = int(height/dy);

    level = new int[cols*rows]; // initialise array to house level
    
    howToEdit = new legend(0, 0, 0);
    howToEdit.move(width - howToEdit.boxWidth/2 - 1.25 * width/40, howToEdit.boxHeight/2 + 1.25 * width/40);

    enemy = new Enemy(0, 0, 0, 1);
    player = new Player(-10, -10, 1);

    for (int i = 0; i < level.length; i++)
    {
      if (i < cols || i % cols == 0 ||  i % cols == cols - 1 ||  i > (rows - 1)*cols)
      {
        level[i] = 1;
      }
    }
  }
  
  void loadLevel(String aFile)
  { // loads level and makes it the level for editor
    lvlStr = loadStrings(aFile); // load level string
    if(lvlStr[0].charAt(0)=='B') // check if the text file is actually a level
    {// counnt the enemies in the level
      for(int i = 1; i < lvlStr[0].length()-1 ; i++)
      {
        level[i-1] = int(str(lvlStr[0].charAt(i)));
        if(level[i-1] == 9)
        {
          playerPos = i-1;
        }
        //print(int(str(lvlStr[0].charAt(i))));
      }
    }
    
  }

  void Reset()
  { // resets everything on level editor
    for (int i = 0; i < level.length; i++)
    {
      if (i < cols || i % cols == 0 ||  i % cols == cols - 1 ||  i > (rows - 1)*cols)
      {
        level[i] = 1;
      } else {
        level[i] = 0;
      }
    }
  }

  void Draw(int aX, int aY)
  {
    if (saveScreen == false)
    {
      if(!wantToReset)
      {
        background(200);
        grid(dx, dy); // draws grid
        int enemyCount = 0;
        for (int i = 0; i < level.length; i++)
        { // Checking what to draw on grid
          if (level[i] > 0) // checks if block in grid square
          {
            col = i % cols; // which column are we on
            row = floor(i / cols); // which row are we on
            if (level[i] == 1)
            {
              // Draw rectangle
              pushMatrix();
              translate(col*dx, row*dy); // move grid system for ease
              fill(wallColour); // colour of block 
              strokeWeight(1);
              rect(0, 0, dx, dy); // draw a rectangle to show wall
              popMatrix();
            }
            if (level[i] == 9) // if up down
            {
              player.move(int(col * dx + 0.5*dx), int(row * dy + 0.5*dy));
              player.drawTank();
            }
            if (level[i] > 1 && level[i] != 9)
            { // if theres an enemy in grid square
              enemyCount ++; // counts number of enemies placed
              enemy.move(int(col * dx + 0.5*dx), int(row * dy + 0.5*dy));
              enemy.aimBarrel(aX, aY);
              if (level[i] == 2 || level[i] == 4 || level[i] == 6 || level[i] == 7) // if stationary enemy or left right
              {
                if (level[i] == 4)
                {
                  enemy.AI = 0;
                } else if (level[i] == 2) {
                  enemy.AI = 1;
                } else if(level[i] == 6) {
                  enemy.AI = 4;
                } else if(level[i] == 7) {
                  enemy.AI = 5;
                }
                enemy.direction = 0;
                enemy.drawTank();
              }
              if (level[i] == 3 || level[i] == 5) // if up down
              {
                if(level[i] == 5)
                {
                  enemy.AI = 3; // shoot through walls boi
                } else {
                  enemy.AI = 2; // AI change for colour
                }
                enemy.direction = 1;
                enemy.drawTank();
              }
            }
          }
        }
        if(enemyCount > 0)
        { // make enemy placed equal true if there are enemies
          enemyPlaced = true;
        } else { // else enemyPLaced is false
          enemyPlaced = false;
        }
        // draw whatever block currently selected on the mouse
        if (blockType == 1) 
        {
          fill(wallColour); // colour of block 
          strokeWeight(1);
          rect(aX -0.5*dx, aY -0.5*dy, dx, dy);
        } else if (blockType == 2) 
        {
          enemy.move(aX, aY);
          enemy.AI = 1; // AI change for colour
          enemy.direction = 0;
          enemy.drawTank();
        } else if (blockType == 3) 
        {
          enemy.move(aX, aY);
          enemy.AI = 2;
          enemy.direction = 1;
          enemy.drawTank();
        } else if (blockType == 4) 
        {
          enemy.move(aX, aY);
          enemy.AI = 0;
          enemy.direction = 0;
          enemy.drawTank();
        } else if (blockType == 5) 
        {
          enemy.move(aX, aY);
          enemy.AI = 3;
          enemy.direction = 1;
          enemy.drawTank();
        } else if (blockType == 6) 
        {
          enemy.move(aX, aY);
          enemy.AI = 4;
          enemy.direction = 0;
          enemy.drawTank();
        } else if (blockType == 7) {
          enemy.move(aX, aY);
          enemy.AI = 5;
          enemy.direction = 0;
          enemy.drawTank();
        } else if (blockType == 9) 
        { // draw player
          player.move(aX, aY);
          player.drawTank();
        }
        howToEdit.Draw(mouseX, mouseY);
        placePlayerScreen();
      } else {
        background(0);
        fill(255);
        textSize(35);
        textAlign(CENTER);
        text("Would you like to reset this level?", width/2, height/2);
        textSize(25);
        text("Yes (Y)", width/4, height/2 +150);
        text("No (N)", width*3/4, height/2 +150);
      }
    } else {
      if (!saved)
      {
        background(0);
        fill(255);
        textSize(35);
        textAlign(CENTER);
        if(playerPos > 0 && enemyPlaced)
        {
          text("Would you like to save this level?", width/2, height/2);
          textSize(25);
          text("Yes (Y)", width/4, height/2 +150);
          text("No (N)", width*3/4, height/2 +150);
          text("press (m) to return to menu", width/2, height/2 + 4*textAscent());
        } else {
          text("Player starting position and at least one \n enemy must be placed  to save a level", width/2, height/3);
          text("press (n) to return to level editor", width/2, height/2 + 6*textAscent());
          text("press (m) to return to menu", width/2, height/2 + 4*textAscent());
        }
      } else {
        background(0);
        fill(255);
        textSize(35);
        textAlign(CENTER);
        text("Level saved ", width/2, height/2);
        text("press (n) to return to level editor", width/2, height/2 + 2*textAscent());
        text("press (m) to return to menu", width/2, height/2 + 4*textAscent());
      }
    }
  }



    void onKeyTyped(char aKey)
    {
      if (aKey == 'w') // 'w' for wall
      {
        blockType = 1;
      } else if (aKey == 'e') // 'e' for enemy right left 
      {
        blockType = 2;
      } else if (aKey == 'r') // 'r' for enemy up down 
      {
        blockType = 3;
      } else if (aKey == 't') // 't' for enemy stationary 
      {
        blockType = 4;
      } else if (aKey == 'i') // 'i' for shoot through walls enemy
      {
        blockType = 5;
      } else if (aKey == 'u') // 'u' for search enemies
      {
        blockType = 6;
      } else if (aKey == 'b') { // 'b' for big boss
        blockType = 7;
      } else if (aKey == 'p') // 'p' for player starting position
      {
        blockType = 9;
      } else if (aKey == 'x' && !saveScreen) {
        wantToReset = true;
      } else if (wantToReset) {
        if (aKey == 'y')
        {
          Reset();
          wantToReset = false;
        } else if (aKey == 'n') {
          wantToReset = false;
        }
      }
      if(aKey == 'l')
      {
        loadLevel("level.txt");
      }
    }


    void onLeftClick(int aMouseButton)
    {
      if (aMouseButton == LEFT && mouseX > 0 && mouseY > 0)
      {
        col = floor(mouseX / dx); // find which column we in
        row = floor(mouseY / dy); // find which row we in 
        idx = row*cols + col; // figure out which index in level array corresponds to grid point chosen 
        if (idx < cols*rows && level[idx] != blockType) // make sure its in screen before storing value
        {
          if (blockType == 9) // if its a player being placed
          {
            if (playerPos > 0) // if player has been assigned before
            {
              level[playerPos] = 0; // remove last assignment
            }
            playerPos = idx; // store new assignment of player
            //playerPlaced = true; // stores that player has been placed
          }
          level[idx] = blockType; // assign block to respective index
        }
      }
    }

    void onRightClick(int aMouseButton)
    {
      if (aMouseButton == RIGHT && mouseX > 0 && mouseY > 0)
      {
        col = floor(mouseX / dx); // find which column we in
        row = floor(mouseY / dy); // find which row we in 
        pushMatrix();
        translate(col*dx, row*dy); // move grid system for ease
        fill(200, 200, 200); // decolour block 
        idx = row*cols + col; // figure out which index in level array corresponds to grid point chosen 
        if (idx < cols*rows && level[idx] >= 0) // make sure its in screen before storing value
        {
          if(level[idx] == 9)
          {
            playerPos = -1;
          }
          level[idx] = 0;
        }
        rect(0, 0, dx, dy); // draw a rectangle to show wall
        popMatrix();
      }
    }
    
    void placePlayerScreen()
    { // prints warning to say place player and enemy
      if(placePlayerWarning)
      {
        textAlign(CENTER);
        fill(0);
        textSize(32);
        text("Player starting position \n and at least one enemy must be placed \n to save a level", width/2, height/2);
        warningCount ++; // framecount 
        if(warningCount > warningTime) // if warning time is over stop showing warning 
        {
          placePlayerWarning = false;
          warningCount = 0; // reset counter
        }
      }
      
    }

    void saveLevel(char aKey)
    {
      if (aKey == 's')
      { 
        saveScreen = true;
      }
      if (saveScreen == true)
      {
        if (aKey == 'n')
        {
          saveScreen = false;
          saved = false;
          Draw(0, 0);
        }
        if (aKey == 'm') // if m pressed return to menu
        {
          saveScreen = false;
          saved = false;
          mode = 'm';
        }
        if (aKey == 'y' && (playerPos > 0 && enemyPlaced))
        {
          saved = true;
          lvlStr[0] = "B"; // B indicates that this is a level
          for (int num : level)
          {
            lvlStr[0] += str(num);
          }
          saveStrings("data/level.txt", lvlStr);
        }
      }
    }
  }
