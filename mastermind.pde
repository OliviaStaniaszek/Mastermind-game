int currentPage;
int noOfGuesses = 12;
int[][] guessesAr = new int[4][noOfGuesses];
int noOfButtons = 4;
Button[] buttons = new Button[noOfButtons];
Button[] colourSelect = new Button[6];
int[] codePattern = new int[4];
Boolean codeGenerated;
int[] guess = new int[4];

PFont tFont; //title
PFont bFont; //body

void setup(){
  size(550,1000);
  tFont = createFont("Agency FB", 90);
  bFont = createFont("OCR A Extended", 20);
  
  currentPage = 0; //menu
  noOfGuesses = 12;
  codeGenerated = false;
  buttons[0] = new Button("New Game", width/2, height*0.35, 300, 70, pin1, 0, false,1);
  buttons[1] = new Button("Scores", width/2, height*0.45, 300, 70, pin2, 0, false,2);
  buttons[2] = new Button("How to Play", width/2, height*0.55, 300, 70, pin3, 0, false,3);
  buttons[3] = new Button("Options", width/2, height*0.65, 300, 70, pin4, 0, false,4);


  colourSelect[0] = new Button("1", 475, 250, 90,90, pin1, 1, false, 1);
  colourSelect[1] = new Button("2", 475, 350, 90,90, pin2, 1, false, 2);
  colourSelect[2] = new Button("3", 475, 450, 90,90, pin3, 1, false, 3);
  colourSelect[3] = new Button("4", 475, 550, 90,90, pin4, 1, false, 4);
  colourSelect[4] = new Button("5", 475, 650, 90,90, pin5, 1, false, 5);
  colourSelect[5] = new Button("6", 475, 750, 90,90, pin6, 1, false, 6);
  
  //fill 2d array with 0s
  for(int i=0; i<4; i++){
    for(int j=0; j<noOfGuesses; j++){
      guessesAr[i][j] = 0;
      println(i,j,guessesAr[i][j]);
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
  }
}

void mousePressed(){
   for(int i=0; i<noOfButtons; i++){
    if(buttons[i].hover == true){
      currentPage = buttons[i].gotoPage;
    }
  }
  for(int i=0; i<6; i++){
      if(colourSelect[i].hover = true){
        int guess = colourSelect[i].gotoPage;
        println(guess);
      }  
    }
  
}



void menuPage(){
  background(bkg);
  textFont(tFont);
  fill(255);
  text("Mastermind", width/2, height*0.25);
  textFont(bFont);
  textSize(20);
  text("(c) Olivia Staniaszek 2022", 120, height-20);
  //rectMode(CENTER);
  //rect(width/2, height/2, 200, 100,20);
  //println(buttons[0].text);
  for(int i=0; i<noOfButtons; i++){
    buttons[i].drawButton(0);
  }
}
void generatePattern(){
  
  for(int i=0; i<4;i++){
    codePattern[i] = int(random(1,7));
  }
  println(codePattern);
  codeGenerated = true;
}

void userinput(){
  
}

void game(){
  if(!codeGenerated){
    generatePattern();
  }
  background(bkg);
  drawGuesses();
  drawFeedback();
  for(int i=0; i<6; i++){
    colourSelect[i].drawColSelect();
  }
  int guessNo = 0;
  int guessIndiv = 0;
  for(int i=0; i<4; i++){
    if(keyPressed){
      if(key >= 0 && key <= 6){
        int guess = key;
        guessesAr[guessNo][guessIndiv] = guess;
        guessIndiv++;
        drawGuesses();
        println(guess);
        for(int l=0; l<4; l++){
        for(int j=0; j<noOfGuesses; j++){
          guessesAr[l][j] = 0;
          println(l,j,guessesAr[l][j]);
          }
        }
      }
      //println(guessesAr[guessNo][guessIndiv]);
    }
    
  }
  guessNo++;
}
  
 


void drawGuesses(){
  fill(255,255,255);
  noStroke();
  int cwidth = 70;
  int gap = 75;
  for(int i=0; i<4; i++){
    for(int j=0; j<noOfGuesses; j++){
      switch(guessesAr[i][j]){
        case 0:
          fill(blankpin);
          break;
        case 1:
          fill(pin1);
          break;
        case 2:
          fill(pin2);
          break;
        case 3: 
          fill(pin3);
          break;
        case 4:
          fill(pin4);
          break;
        case 5:
          fill(pin5);
          break;
      }
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
    circle(feedbackx, feedbacky+cluster*rowgap,cwidth);
    circle(feedbackx+gap, feedbacky+cluster*rowgap, cwidth);
    circle(feedbackx, feedbacky+cluster*rowgap+gap,cwidth); 
    circle(feedbackx +gap, feedbacky+cluster*rowgap+gap,cwidth);
    cluster++;
  }
}
