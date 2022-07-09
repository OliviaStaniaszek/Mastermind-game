int currentPage;
int noOfGuesses = 12;
int[][] guessesAr = new int[4][noOfGuesses];
int[][] feedbackAr = new int[4][noOfGuesses];
int noOfButtons = 4;
Button[] buttons = new Button[noOfButtons];
Button[] colourSelect = new Button[6];
int[] codePattern = new int[4];
Boolean codeGenerated;
int[] guess = new int[4];
Boolean won;
Boolean mouseClicked = false;

int input;
Boolean playing;
int guessNo;
int guessIndiv; 

PFont tFont; //title
PFont bFont; //body

void setup(){
  size(550,1000);
  tFont = createFont("Agency FB", 90);
  bFont = createFont("OCR A Extended", 20);
  
  currentPage = 0; //menu
  noOfGuesses = 12;
  codeGenerated = false;
  won = false;
  playing = false;
  
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
      feedbackAr[i][j] = 0;
      //println(i,j,guessesAr[i][j]);
      
    }
  }
  
  
}//end of setup

void draw(){
  //println("TEST - current page", currentPage);
  if (currentPage == 0){
    menuPage();
  } else if(currentPage ==1){

    game();
  }
  for(int i=0; i<noOfButtons; i++){
    buttons[i].collision();
  }
  //for(int i=0; i<6; i++){
  //  colourSelect[i].collision();
  //  //println(colourSelect[i].hover);
  //}
}

void mousePressed(){
   for(int i=0; i<noOfButtons; i++){
    if(buttons[i].hover == true){
      currentPage = buttons[i].gotoPage;
    }
  }

}


void keyPressed() {
  if (key >= '1' && key <= '6') {
    if(key == '1'){
      input = 1;
    }else if(key == '2'){
     input = 2;
    }else if(key == '3'){
     input = 3;
    }else if(key == '4'){
     input = 4;
    }else if(key == '5'){
     input = 5;
    }else if(key == '6'){
     input = 6;
    }
    //println("TEST",input);
    
    guessesAr[guessIndiv][guessNo] = input;
    if(guessIndiv >= 3){
      feedback();
      guessIndiv = 0;
      guessNo ++;
      if(guessNo > 11){
        playing = false;
      }
    } else{
      guessIndiv ++;
    }
    
    //println("TEST", guessNo, guessIndiv);
    }
}


void generatePattern(){
  for(int i=0; i<4;i++){
    codePattern[i] = int(random(1,7));
  }
  println(codePattern);
  codeGenerated = true;
}

void game(){
  if(!codeGenerated){ //once at start of new game
    generatePattern();
    playing = true;
    guessIndiv = 0;
    guessNo = 0;
  }
  
 
  background(bkg);
  
  if(playing){
    drawGuesses();
    drawFeedback();
    for(int i=0; i<6; i++){
      colourSelect[i].drawColSelect();
    }
  }else{ //game over
    if(won){
      textFont(tFont);
      text("You Won!", width/2, height/2 -50);
      textFont(bFont);
      //String message = "You guessed the correct pattern in" +guessNo+ "guesses";
      text("You guessed the correct", width/2, height/2 +30);
      text(" pattern in " +guessNo+ " guesses", width/2, height/2 +60);
    }else{
      textFont(tFont);
      text("game over", width/2, height/2 -50);
      textFont(bFont);
      text("press enter to return to menu", width/2, height/2 +30);
      
      
    }
    if(keyPressed){
        if (key == CODED) {
          if (keyCode == ENTER) {
            println("TEST - enter");
            currentPage = 0;
            menuPage();
          }
        }
      }
  }
}
  
void feedback(){
  //println("TEST - feedback");
  for(int i=0; i<4; i++){
    int currentPin = guessesAr[i][guessNo];
    if(currentPin == codePattern[i]){
      //println("TEST - correct colour and pos");
      feedbackAr[i][guessNo] = 2; //correct
    } else{
      Boolean contains = false;
      for(int n=0; n<3; n++){
        if(codePattern[i] == currentPin){
          contains = true;
        }
      if(contains){
        feedbackAr[i][guessNo] = 1; //partially correct
      }
      }
    }
  }
  int total = 0;
  for(int i=0; i<4; i++){
      total += feedbackAr[i][guessNo];
  }
  if(total == 8){
    won = true;
    playing = false;
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
        case 6:
          fill(pin6);
          break;
      }
      circle(gap*i+gap,gap*j+gap,cwidth);
    }
  }
}

void getFeedbackColour(int i, int j){
  switch(feedbackAr[i][j]){
        case 0:
          fill(blankpin);
          break;
        case 1:
          fill(150);
          break;
        case 2:
          fill(20);
          break;
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
    getFeedbackColour(0,i);
    circle(feedbackx, feedbacky+cluster*rowgap,cwidth);
    getFeedbackColour(1,i);
    circle(feedbackx+gap, feedbacky+cluster*rowgap, cwidth);
    getFeedbackColour(2,i);
    circle(feedbackx, feedbacky+cluster*rowgap+gap,cwidth); 
    getFeedbackColour(3,i);
    circle(feedbackx +gap, feedbacky+cluster*rowgap+gap,cwidth);
    cluster++;
  }
}
