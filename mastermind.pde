int currentPage;
//color bkg;
int noOfGuesses = 12;
int[][] guessesAr = new int[4][noOfGuesses];
int noOfButtons = 2;
Button[] buttons = new Button[noOfButtons];
Button[] colourSelect = new Button[6];

void setup(){
  size(550,1000);
  currentPage = 0; //menu
  noOfGuesses = 12;
  buttons[0] = new Button("New Game", width/2, height/2, 200, 50, pin1, 0, false,1);
  buttons[1] = new Button("Scores", width/2, height/2 + 100, 200, 50, pin2, 0, false,2);
  
  colourSelect[0] = new Button("1", 475, 250, 90,90, pin1, 1, false, 0);
  colourSelect[1] = new Button("2", 475, 350, 90,90, pin2, 1, false, 0);
  colourSelect[2] = new Button("3", 475, 450, 90,90, pin3, 1, false, 0);
  colourSelect[3] = new Button("4", 475, 550, 90,90, pin4, 1, false, 0);
  colourSelect[4] = new Button("5", 475, 650, 90,90, pin5, 1, false, 0);
  colourSelect[5] = new Button("6", 475, 750, 90,90, pin6, 1, false, 0);
  
  //fill 2d array with 0s
  for(int i=0; i<4; i++){
    for(int j=0; j<noOfGuesses; j++){
      guessesAr[i][j] = 0;
      //println(i,j,guessesAr[i][j]);
    }
  }
  
  
  
}//end of setup

void draw(){
  if (currentPage == 0){
    menuPage();
  } else if(currentPage ==1){
    game();
  }
  
  for(int i=0; i<noOfButtons; i++){
    buttons[i].collision();
  }
  for(int i=0; i<6; i++){
    colourSelect[i].collision();
    //println(colourSelect[i].hover);
  }
}

void mousePressed(){
   for(int i=0; i<noOfButtons; i++){
    if(buttons[i].hover == true){
      currentPage = buttons[i].gotoPage;
    }
  }
}


void menuPage(){
  background(bkg);
  text("hi", width/2, height/2);
  //rectMode(CENTER);
  //rect(width/2, height/2, 200, 100,20);
  //println(buttons[0].text);
  for(int i=0; i<noOfButtons; i++){
    buttons[i].drawButton(0);
  }
}

void game(){
  background(bkg);
  drawGuesses();
  drawFeedback();
  for(int i=0; i<6; i++){
    colourSelect[i].drawColSelect();
  }
}

void drawGuesses(){
  fill(255,255,255);
  noStroke();
  int cwidth = 70;
  int gap = 75;
  for(int i=0; i<4; i++){
    for(int j=0; j<noOfGuesses; j++){
      circle(gap*i+gap,gap*j+gap,cwidth);
    }
  }
}

void drawFeedback(){
  int feedbackx = 360;
  float feedbacky = 60;
  int cwidth = 30;
  int gap = 30;
  int rowgap = 75;
  int cluster = 0;
  for(int i=0; i<12; i++){
    //println(cluster);
    circle(feedbackx, feedbacky+cluster*rowgap,cwidth);
    circle(feedbackx+gap, feedbacky+cluster*rowgap, cwidth);
    circle(feedbackx, feedbacky+cluster*rowgap+gap,cwidth); 
    circle(feedbackx +gap, feedbacky+cluster*rowgap+gap,cwidth);
    cluster++;
  }
}
