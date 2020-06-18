class legend
{
  PVector pos; // position of box 
  Box2 legendBox; // box that hold instructions
  String[] toEdit = {"Press S to Save", "W -", "E -", "R -", "T -", "P -", "Press X to reset", "Right Click - clear"}; // text to put in box of level editor
  String[][] toPlay = {{"W, A, S, D  -  to move", "Mouse -  Aim and Shoot", "P   -   Pause"},{"use 'C' to set mines", "they'll never see", "it coming."}, {"Here's an extra life", "soldier, you'll need it"}}; // text to put in first level
  String[] instructions;
  int mode; // if 1 then info for how to play else if 0 instructions for level editing, if 2 show infor on how to use mines
  int txtSize = 18;
  Box2 wall; // wall for legend
  Player playerIcon; // for player
  Enemy enemyIcon; // for enemies
  color wallColour = color(181, 77, 77);
  float boxHeight;
  float boxWidth;
  boolean mouseOver = false;
  int idx; // stores index of biggest string
 
  
  legend(float aX, float aY, int aMode)
  {
    pos = new PVector(aX, aY);
    mode = aMode;
    textSize(txtSize);
    legendBox = new Box2(pos.x, pos.y, 0, 0, 0);
    wall = new Box2(0, 0, width/40, width/40, 0);
    playerIcon = new Player(0, 0, 0.5);
    enemyIcon = new Enemy(0, 0, 0, 0.5);
    if(mode == 0) // show instructions for edit
    {
      instructions = toEdit; 
      idx = instructions.length -1;
    } else if(mode == 1){ // show instructions to play
      instructions = toPlay[0];
      idx = 1;
    } else if (mode == 2){
      instructions = toPlay[1];
      idx = 1;
    }  else if (mode == 3){
      instructions = toPlay[2];
      idx = 1;
    }
    boxHeight = 2.1 * instructions.length *textAscent();
    boxWidth = textWidth(instructions[idx])* 1.25;
    legendBox.Height = boxHeight;
    legendBox.Width = boxWidth;
  } 
  
  void changeMode(int aMode)
  {
    mode = aMode;
    
     if(mode == 0) // show instructions for edit
    {
      instructions = toEdit; 
      idx = instructions.length -1;
    } else if(mode == 1){ // show instructions to play
      instructions = toPlay[0];
      idx = 1;
    } else if (mode == 2){
      instructions = toPlay[1];
      idx = 1;
    }  else if (mode == 3){
      instructions = toPlay[2];
      idx = 1;
    }
    boxHeight = 2.1 * instructions.length *textAscent();
    boxWidth = textWidth(instructions[idx])* 1.25;
    legendBox.Height = boxHeight;
    legendBox.Width = boxWidth;
  }
  
  void move(float aX, float aY)
  {
    pos.x = aX;
    pos.y = aY;
    legendBox.move(aX, aY);
  }
  
  void Draw(int aX, int aY)
  {
    isMouseOver(aX, aY);
    if(!mouseOver)
    {
      fill(150, 150, 150, 100);
      legendBox.Draw();
      pushMatrix();
      translate(pos.x, pos.y);
      
      //textSize(txtSize);
      if(mode == 0)
      {
        for(int i = 0; i < instructions.length; i++)
        {
          fill(0);
          textAlign(LEFT);
          textSize(txtSize);
          text(instructions[i], -textWidth(instructions[idx])/2, (- 0.5 * boxHeight) + (2 * i + 1.5) * textAscent());
          if(i == 1)
          {
            fill(wallColour);
            wall.move(0, (- 0.5 * boxHeight) + (2 * i + 1.25) * textAscent());
            wall.Draw();
          }
          if(i == 2)
          {
            enemyIcon.AI = 1;
            enemyIcon.direction = 0;
            enemyIcon.move(0, (- 0.5 * boxHeight) + (2 * i + 1) * textAscent());
            enemyIcon.drawTank();
          }
           if(i == 3)
          {
            enemyIcon.AI = 2;
            enemyIcon.direction = 1;
            enemyIcon.move(0, (- 0.5 * boxHeight) + (2 * i + 1) * textAscent());
            enemyIcon.drawTank();
          }
            if(i == 4)
          {
            enemyIcon.AI = 0;
            enemyIcon.direction = 0;
            enemyIcon.move(0, (- 0.5 * boxHeight) + (2 * i + 1) * textAscent());
            enemyIcon.drawTank();
          }
            if(i == 5)
          {
            playerIcon.move(0, (- 0.5 * boxHeight) + (2 * i + 1) * textAscent());
            playerIcon.drawTank();
          }
        }
      } else {  
        for(int i = 0; i < instructions.length; i++)
        {
          fill(0);
          textAlign(LEFT);
          textSize(txtSize);
          text(instructions[i], -textWidth(instructions[idx])/2, (- 0.5 * boxHeight) + (2 * i + 1.5) * textAscent());
        }
      }
      popMatrix();
    }
  }
  
  void isMouseOver(int aX, int aY)
  {
    if(isPointInsideBox(aX, aY, legendBox))
    {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
  }
  
}
