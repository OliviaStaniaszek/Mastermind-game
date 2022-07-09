int currentPage;
int noOfGuesses = 5;
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
int startTime;
int endTime;

int input;
Boolean playing;
int guessNo;
int guessIndiv; 

PFont tFont; //title
PFont bFont; //body

PrintWriter scoreboard;
BufferedReader reader;
String line;

void setup(){
  size(550,700);
  tFont = createFont("Agency FB", 90);
  bFont = createFont("OCR A Extended", 20);
  scoreboard = createWriter("scoreboard.txt.");
  reader = createReader("scoreboard.txt");
  parseFile();
  
  currentPage = 0; //menu
  codeGenerated = false;
  won = false;
  playing = false;
  
  buttons[0] = new Button("New Game", width/2, height*0.35, 300, 70, pin1, 0, false,1);
  buttons[1] = new Button("Scores", width/2, height*0.45, 300, 70, pin2, 0, false,2);
  buttons[2] = new Button("How to Play", width/2, height*0.55, 300, 70, pin3, 0, false,3);
  buttons[3] = new Button("Options", width/2, height*0.65, 300, 70, pin4, 0, false,4);

  colourSelect[0] = new Button("1", 475, height*0.16-45, 90,90, pin1, 1, false, 1);
  colourSelect[1] = new Button("2", 475, height*(0.16*2)-45, 90,90, pin2, 1, false, 2);
  colourSelect[2] = new Button("3", 475, height*(0.16*3)-45, 90,90, pin3, 1, false, 3);
  colourSelect[3] = new Button("4", 475, height*(0.16*4)-45, 90,90, pin4, 1, false, 4);
  colourSelect[4] = new Button("5", 475, height*(0.16*5)-45, 90,90, pin5, 1, false, 5);
  colourSelect[5] = new Button("6", 475, height*(0.16*6)-45, 90,90, pin6, 1, false, 6);
  
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
  } else if(currentPage ==2){
    scoreboard();
  }
  for(int i=0; i<noOfButtons; i++){
    buttons[i].collision();
  }
}

String[] parseFile(){
  line = null;
  try{
    while((line = reader.readLine()) != null){
      String[] pieces = split(line, TAB);
      int guesses = int(pieces[0]);
      String date = (pieces[1]);
      float time = float(pieces[2]);
    }
    reader.close();
  } catch(IOException e){
    e.printStackTrace();
  }
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
      if(guessNo > noOfGuesses-1){
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
    startTime = millis();
    
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
      
      int d = day();
      int m = month();
      int y = year();
      endTime = millis();
      float timeElapsed = (endTime-startTime)/1000;
      scoreboard.println(guessNo+"\t"+String.valueOf(d)+"/"+String.valueOf(m)+"/"+String.valueOf(y)+"\t"+timeElapsed);
      scoreboard.flush();
      scoreboard.close();
  }else{
      textFont(tFont);
      text("game over", width/2, height/2 -50);
      textFont(bFont);
      text("press enter to return to menu", width/2, height/2 +30);
      
      
    }
    if(keyPressed){
      if (key == ENTER || key == RETURN) {
        println("TEST - enter");
        currentPage = 0;
        menuPage();
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
      //println("not correct");
      for(int n=0; n<4; n++){
        println("test",n);
        if(codePattern[n] == currentPin){
          println(codePattern[n]);
          feedbackAr[i][guessNo] = 1;
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
  text("Mastermind", width/2, height*0.22);
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

void scoreboard(){
  background(bkg);
  textFont(tFont);
  textSize(60);
  fill(255);
  text("Scoreboard", width/2, height*0.10);
  String[] scores = new int[]parseFile();
}

void drawGuesses(){
  fill(255,255,255);
  noStroke();
  int cwidth = 70;
  //float ygap = 75 + noOfGuesses*2.5;
  float ygap = height/noOfGuesses;
  //ygap = map(ygap, 0, 900, 0, height);
  int xgap = 75;
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
      
      circle(xgap*i+xgap,ygap*j+ygap/2,cwidth);
      fill(255);
      if(guessesAr[i][j] != 0){
        text(guessesAr[i][j],xgap*i+xgap,ygap*j+ygap/2);
      }
    }
  }
}

void getFeedbackColour(int i, int j){
  switch(feedbackAr[i][j]){
        case 0:
          fill(blankpin);
          break;
        case 1:
          fill(partially);
          break;
        case 2:
          fill(correct);
          break;
  }
}

void drawFeedback(){
  int feedbackx = 360;
  float feedbacky = 133- 15; //60 + noOfGuesses*2.5;
  int cwidth = 30;
  float gap = 30;
  float rowgap = height/noOfGuesses;
  int cluster = 0;
  for(int i=0; i<noOfGuesses; i++){
    getFeedbackColour(0,i);
    circle(feedbackx, feedbacky/2+cluster*rowgap,cwidth);
    getFeedbackColour(1,i);
    circle(feedbackx+gap, feedbacky/2+cluster*rowgap, cwidth);
    getFeedbackColour(2,i);
    circle(feedbackx, feedbacky/2+cluster*rowgap+gap,cwidth); 
    getFeedbackColour(3,i);
    circle(feedbackx +gap, feedbacky/2+cluster*rowgap+gap,cwidth);
    cluster++;
  }
}
