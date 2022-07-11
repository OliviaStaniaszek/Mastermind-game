int currentPage;
int noOfGuesses = 5;
int[][] guessesAr;
int[][] feedbackAr;
int noOfButtons = 3;
Button[] buttons = new Button[noOfButtons];
Button[] colourSelect = new Button[6];
int[] codePattern = new int[4];
Boolean codeGenerated;
int[] guess = new int[4];
Boolean won;
Boolean mouseClicked = false;
float startTime;
float endTime;

int input;
String inputString = "";
Boolean playing;
int guessNo;
int guessIndiv; 

PFont tFont; //title
PFont bFont; //body

IntList scoreGuess;
StringList scoreDate;
FloatList scoreTime;
Table table;
Boolean dataSaved;
void setup(){
  size(550,850);
  tFont = createFont("Agency FB", 90);
  bFont = createFont("OCR A Extended", 20);

  scoreGuess = new IntList();
  scoreDate = new StringList();
  scoreTime = new FloatList();
  
  table = loadTable("scoreboard.csv","header");
  dataSaved = false;

  guessesAr = new int[4][noOfGuesses];
  feedbackAr = new int[4][noOfGuesses];
  currentPage = 0; //menu
  codeGenerated = false;
  won = false;
  playing = false;
  
  buttons[0] = new Button("New Game", width/2, height*0.37, 300, 80, pin1, 0, false,1);
  buttons[1] = new Button("Scores", width/2, height*0.50, 300, 80, pin2, 0, false,2);
  buttons[2] = new Button("How to Play", width/2, height*0.63, 300, 80, pin3, 0, false,3);
  //buttons[3] = new Button("Options", width/2, height*0.65, 300, 60, pin4, 0, false,4);

  colourSelect[0] = new Button("1", 475, height*0.16-45    , 90,90, pin1, 1, false, 1);
  colourSelect[1] = new Button("2", 475, height*(0.16*2)-45, 90,90, pin2, 1, false, 2);
  colourSelect[2] = new Button("3", 475, height*(0.16*3)-45, 90,90, pin3, 1, false, 3);
  colourSelect[3] = new Button("4", 475, height*(0.16*4)-45, 90,90, pin4, 1, false, 4);
  colourSelect[4] = new Button("5", 475, height*(0.16*5)-45, 90,90, pin5, 1, false, 5);
  colourSelect[5] = new Button("6", 475, height*(0.16*6)-45, 90,90, pin6, 1, false, 6); 
  
}//end of setup

void draw(){
  if (currentPage == 0){
    menuPage();
  } else if(currentPage ==1){
    game();
  } else if(currentPage ==2){
    scoreboard();
  } else if(currentPage ==3){
    howToPlay();
  }else if(currentPage ==4){
    enterName();
  }
  for(int i=0; i<noOfButtons; i++){
    buttons[i].collision();
  }
}

void mousePressed(){
   for(int i=0; i<noOfButtons; i++){
    if(buttons[i].hover == true){
      currentPage = buttons[i].gotoPage;
      //println("TEST - current page on click - ",currentPage);
      //println("TEST - won? ",won);
      //println("TEST - playing? ",playing);
      
    }
  }
}

void keyPressed() {
  if(playing){
    if (key >= 49 && key <= 54) {
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
      guessesAr[guessIndiv][guessNo] = input; //moved inside so only adds to input/ increments if 1-6
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
    }  
    
    
  }else if(key >= 97 && key <= 122){
      inputString = inputString + key;
    } 
}

void generatePattern(){
  for(int i=0; i<4;i++){
    codePattern[i] = int(random(1,7));
  }
  codeGenerated = true;
  dataSaved = false;
}

void game(){
  if(!codeGenerated){ //once at start of new game
    generatePattern();
    playing = true;
    guessIndiv = 0;
    guessNo = 0;
    startTime = millis();
    for(int i=0; i<4; i++){
      for(int j=0; j<noOfGuesses; j++){
        guessesAr[i][j] = 0;
        feedbackAr[i][j] = 0;
      }
    }
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
      text("You guessed the correct", width/2, height/2 +30);
      text("pattern in " +guessNo+ " guesses", width/2, height/2 +60);
      text("press enter to return to menu", width/2, height/2 +90); 
      currentPage=4;
      enterName();   
  }else{
      textFont(tFont);
      text("game over", width/2, height/2 -50);
      textFont(bFont);
      text("press enter to return to menu", width/2, height/2 +30); 
    }
    if(keyPressed){
      if (key == ENTER || key == RETURN) {
        //won = false;
        codeGenerated = false;
        currentPage = 0;
        menuPage();
      } 
    }
  }
}

void saveData(){
  int d = day();
  int m = month();
  int y = year();
  String day = String.valueOf(d);
  String month = String.valueOf(m);
  String year = String.valueOf(y);
  String yearShort = year.substring(2);
  
  endTime = millis();
  float timeElapsed = (endTime-startTime)/1000;
  
  TableRow newRow = table.addRow();
  newRow.setInt("guesses", guessNo);
  newRow.setString("date",(day+"/"+month+"/"+yearShort));
  newRow.setFloat("timetaken", timeElapsed);
  newRow.setString("name",inputString);
  saveTable(table, "data/scoreboard.csv");
  dataSaved = true;
}

int[] sortTable(){
  table = loadTable("scoreboard.csv","header");
  int n = table.getRowCount();
  int[] order = new int[n];
  float[] numbers = new float[n];
  int i=0;
  for(TableRow row: table.rows()){
    float time = row.getFloat("timetaken");
    numbers[i]=time;
    order[i]=i;
    i++;
  }
  //bubble sort (because built in table sort didnt work)
  for(int j=0; j<n-1; j++){
    for(int k=0; k<n-j-1; k++){
      if(numbers[k] > numbers[k+1]){
        //swap
        float temp = numbers[k];
        numbers[k] = numbers[k+1];
        numbers[k+1] = temp;
        
        int tempi = order[k];
        order[k] = order[k+1];
        order[k+1] = tempi;
      }
    }
  }
  return order;
}
  
void feedback(){
  for(int i=0; i<4; i++){
    int currentPin = guessesAr[i][guessNo];
    if(currentPin == codePattern[i]){
      feedbackAr[i][guessNo] = 2; //correct
    } else{
      for(int n=0; n<4; n++){
        if(codePattern[n] == currentPin){
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
  text("Mastermind", width/2, height*0.22);
  textFont(bFont);
  textSize(20);
  fill(100);
  text("Olivia Staniaszek 2022", width-147, height-20);
  for(int i=0; i<noOfButtons; i++){
    buttons[i].drawButton(0);
  }
}

void scoreboard(){
  background(bkg);
  textFont(tFont);
  textSize(60);
  fill(pin2);
  text("Scoreboard", width/2, height*0.10);
  textSize(23);
  fill(255);
  text("press enter to return to menu", 120, 20);
  textSize(35);
  text("Name",width*0.13, height*0.2);
  text("Guesses",width*0.30,height*0.2);
  text("Date",width*0.5,height*0.2);
  text("Time taken",width*0.80,height*0.2);
  float top = height*0.25;
  float gap = 25;
  table = loadTable("scoreboard.csv","header");
  textFont(bFont);
  textSize(25);
  int[] order = sortTable();
  
  for(int l=0; l<order.length; l++){
    TableRow row = table.getRow(order[l]);
    int guess = row.getInt("guesses");
    String date = row.getString("date");
    float time = row.getFloat("timetaken");
    String name = row.getString("name");
    if(order[l]==order.length-1){
      fill(pin2);
    }else{
      fill(255);
    }
    text(name.toUpperCase(),width*0.13, top+gap*l);
    text(str(guess),width*0.30,top+gap*l);
    text(date,width*0.5,top+gap*l);
    text(str(time),width*0.80,top+gap*l);
    
    fill(0);
    rect(width/2, height-height*0.05,width,height*0.1); //covers overflow lol
  }
  
  if(keyPressed){
    if (key == ENTER || key == RETURN) {
      currentPage = 0;
      menuPage();
    } 
  }
}

void enterName(){
  background(bkg);
  textFont(tFont);
  textSize(60);
  fill(255);
  text("Enter a 3 letter name", width/2, height*0.10);
  textFont(bFont);
  textSize(30);
  text(inputString,width/2,height*0.25);
  if(inputString.length() > 2){
    if(!dataSaved){
      saveData();
    }
    currentPage = 0;
    menuPage();
    codeGenerated = false;
    won = false;
  }  
}

void howToPlay(){
  background(bkg);
  textFont(tFont);
  textSize(60);
  fill(pin3);
  textAlign(CENTER);
  text("How to play", width/2, height*0.12);
  
  String[] howto = new String[14];
  howto[0] = "The aim of Mastermind is to";
  howto[1] = "guess the hidden code in as";
  howto[2] = "few guesses as possible.";
  howto[3] = "Use the number keys (1-6) to";
  howto[4] = "guess colours.";
  howto[5] = " ";
  howto[6] = "The 4 small circles indicate";
  howto[7] = "how you did:";
  howto[8] = "- Black: correct colour and";
  howto[9] = "\tposition";
  howto[10] = "- Grey: correct colour but";
  howto[11] = "\twrong position";
  howto[12] = "- White: wrong colour and";
  howto[13] = "\tposition";

  
  textSize(23);
  fill(255);
  text("press enter to return to menu", 120, 25);
  textAlign(LEFT);
  textFont(bFont);
  textSize(25);
  float textTop = 180;
  for(int i=0; i<howto.length;i++){
    text(howto[i],65, textTop+i*height/25);
  }
  textAlign(CENTER);
  if(keyPressed){
    if (key == ENTER || key == RETURN) {
      currentPage = 0;
      menuPage();
    } 
  }
}

void drawGuesses(){
  fill(255,255,255);
  noStroke();
  int cwidth = 70;
  float ygap = height/noOfGuesses;
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
  float feedbacky = 140;
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
