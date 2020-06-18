class Level
{
  float dx; // coloumn width of grid
  float dy; // row height of grid 
  int cols; // stores the number of columns
  int rows; // stores the number of rows
  int col; // the column that is in right now 
  int row; // the row that mouse is in right now
  String[] lvlStr; // string that holds information for the walls
  Box2[] walls = new Box2[0]; // contains walls in the level
  color wallColour = color(181, 77, 77);
  int enemyCount = 0; // count howmuch enemies there are
  Enemies enemies; // initialise the enemies
  PVector playerPos;
  Player livesIcon;
  
 
  
  Level(String aFile)
  {
    lvlStr = loadStrings(aFile); // load level string
    
    livesIcon = new Player(width - 50 , height - 20, 0.5);
    livesIcon.health = 3;
    
    dx = width/40; // column width
    dy = dx; // row height
    cols = int(width/dx); // number of columns
    rows = int(height/dy); // numer of rows
    
    if(lvlStr[0].charAt(0)=='B') // check if the text file is actually a level
    { // counnt the enemies in the level
      for(int i = 1; i < lvlStr[0].length() ; i++)
      {
        if(int(str(lvlStr[0].charAt(i))) > 1 && int(str(lvlStr[0].charAt(i))) != 9)
        {
          enemyCount ++;
        }
      }
      
      enemies = new Enemies(0);
      enemies.AliveCount = enemyCount;
      
      //println(true);
      for(int i = 1; i < lvlStr[0].length(); i++) 
      {// goes through the string and creates a box in each square that has a one and adds it to walls
        col = (i-1) % cols; // which column are we on
        row = floor((i-1) / (cols)); // which row are we on 
        if(lvlStr[0].charAt(i) == '1')
        {
          Box2 wall = new Box2(col*dx+dx/2, row*dy+dy/2, dy, dx, 0);
          walls = (Box2[])append(walls, wall);
        }
        
        if(lvlStr[0].charAt(i) == '2')
        {
          enemies.myEnemies =(Enemy[])append(enemies.myEnemies, new Enemy(col*dx+dx/2, row*dy+dy/2, 1, 1)); // left right
        }
        else if(lvlStr[0].charAt(i) == '3')
        {
          enemies.myEnemies =(Enemy[])append(enemies.myEnemies, new Enemy(col*dx+dx/2, row*dy+dy/2, 2, 1)); // moving up down
        }
        else if(lvlStr[0].charAt(i) == '4')
        {
          enemies.myEnemies =(Enemy[])append(enemies.myEnemies, new Enemy(col*dx+dx/2, row*dy+dy/2, 0, 1)); // stationary
        }
        else if(lvlStr[0].charAt(i) == '5')
        {
          enemies.myEnemies =(Enemy[])append(enemies.myEnemies, new Enemy(col*dx+dx/2, row*dy+dy/2, 3, 1)); // shoots through walls!!!
          enemies.myEnemies[enemies.myEnemies.length-1].coolDown = 1000;
        }
         else if(lvlStr[0].charAt(i) == '6')
        {
          enemies.myEnemies =(Enemy[])append(enemies.myEnemies, new Enemy(col*dx+dx/2, row*dy+dy/2, 4, 1)); // searches maze!!!
        }
        else if(lvlStr[0].charAt(i) == '7')
        {
          enemies.myEnemies =(Enemy[])append(enemies.myEnemies, new Enemy(col*dx+dx/2, row*dy+dy/2, 5, 1)); // big boss!!!
          enemies.myEnemies[enemies.myEnemies.length-1].coolDown = 1000;
        }
        else if(lvlStr[0].charAt(i) == '9')
        {
          playerPos = new PVector(col*dx+dx/2, row*dy+dy/2); // put player position
        }
      }
    }
  }
  
  void Draw()
  { 
    background(200);
    
    // draws all the walls
    for(Box2 wall: walls)
    {
      fill(wallColour);
      stroke(0);
      wall.Draw();
    }
    //fill(255);
    //rect(width * 38/40, height * 38/40, 2*dx, 2*dy);
    //livesIcon.drawTank();
    
    
  }
}
