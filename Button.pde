class Button{
  String text;
  int x;
  float y;
  int w;
  int h;
  color colour;
  int page;
  Boolean hover;
  int gotoPage;
  
  //constructor
  Button(String txt, int xpos, float ypos, int bwidth, int bheight, color col, int pg, Boolean hov, int destination){
    text = txt;
    x = xpos;
    y = ypos;
    w = bwidth;
    h = bheight;
    colour = col;
    page = pg;
    hover = hov;
    gotoPage = destination;
  }
  
  void drawButton(int currentPage){
    rectMode(CENTER);
    if(page == currentPage){
      if(hover ==true){
        fill(colour,100);
      }else{
        fill(colour);  
      }
      rect(x,y,w,h, 10);
      textFont(bFont);
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(35); 
      text(text, x,y);
    }
  }
  
  void drawColSelect(){
    if(hover ==true){
        fill(colour,100);
      }else{
        fill(colour);  
      }
    circle(x, y, w);
    fill(255);
    text(text, x,y);
  }
  
  void collision(){
    if(mouseY<y+h/2 && mouseY>y-h/2 && mouseX<x+w/2 && mouseX>x-w/2){
        hover = true;
      }else{
        hover = false;
     }
   }
  
}
