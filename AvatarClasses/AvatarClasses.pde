/*************************************************************/
/* Author: Marcello Feliciano
/* Creation Date: 3/21/23
/* Due Date: 3/30/23
/* Course: CSC120
/* Professor Name: Shimkanon
/* Assignment: Avatar_Classes
/* Sketch name: Avatar_Classes
/* Purpose: create avatar with classes
*************************************************************/
float a = 1;
float b = 50;
float c = 25;
float d = 200;
float e = 150;
float f = 225;
float g = 100;
float z = 0;
float alpha = 255;
rain[] r = new rain [1000];
avatar[] avatars = new avatar[1];
avatar_characters[] randomavatars = new avatar_characters[5];
void setup(){
  size(1920,1080);
  background(0);
  //Start Rain
  for(int i = 0; i < r.length; i++){
    r[i] = new rain();
  }
  //End Rain
  //Start Avatar
  for(int i = 0; i < avatars.length; i++){
    avatars[i] = new avatar();
  }
  //End Avatar
  //Start random Avatar
  for(int i = 0; i < randomavatars.length; i++){
    randomavatars[i] = new avatar_characters();
  }
  //End random Avatar
}
void draw(){
  background(0);
  fill(0,0,100,255);
  rect(0,0,1920,500);//sky
  fill(150,150,130);
  rect(160,150,1530,700);//main building
  rect(120,150,1610,50);//top of building
  rect(140,210,1570,20);//second top building rect
  fill(255);
  rect(100,245,1650,100);//white building rect
  //Start of orange bars
  fill(255,140,0);
  rect(120,255,200,20);
  rect(120,315,200,20);
  rect(350, 255,200,20);
  rect(1300,255,200,20);
  rect(1530,255,200,20);
  rect(350,315,200,20);
  rect(1300,315,200,20);
  rect(1530,315,200,20);
  //End of orange bars
  //Start of blue bars
  fill(0,0,255);
  rect(120,285,200,20);
  rect(350,285,200,20);
  rect(1300,285,200,20);
  rect(1530,285,200,20);
  //End of blue bars
  //Start of grey parking bars
  fill(150,150,130);
  rect(250,875,150,30);
  rect(550,875,150,30);
  rect(850,875,150,30);
  rect(1150,875,150,30);
  rect(1450,875,150,30);
  //End of grey parking bars
  //Start of yellow parking lines
  fill(255,255,0);
  rect(160,875,30,210);
  rect(460,875,30,210);
  rect(760,875,30,210);
  rect(1060,875,30,210);
  rect(1360,875,30,210);
  rect(1660,875,30,210);
  //End of yellow parking lines
  //Start of 7 Eleven text
  textSize(80);
  fill(255,0,0,255);
  text("7",750,325);
  fill(0,0,255,255);
  text("ELEVEN",800,325);
  //End of 7 Eleven text
  fill(0,255,255,150);
  rect(750,400,650,450);//Window
  //Start of water sign
  fill(0,0,255,255);
  rect(160,550,200,300);
  textSize(35);
  fill(255);
  text("$.25",260,600);
  textSize(30);
  fill(255);
  text("WATER",210,640);
  //End of water sign
  //Start of pizza sign
  fill(0,255,0);
  rect(1450,400,230,150);
  textSize(70);
  fill(255,0,0,255);
  text("Pizza",1500,510);
  //End of pizza sign
  //Start of hot dogs sign
  fill(255,0,0);
  rect(1500,600,130,200);
  textSize(35);
  fill(0,255,0);
  text("Hot",1515,635);
  text("Dogs",1515,665);
  text("$1.99",1515,725);
  //End of hot dogs sign
  //Start of burgers sign
  rect(480,500,200,230);
  textSize(40);
  fill(255);
  text("Burgers",500,550);
  //End of burgers sign
  //Start of slurpee sign
  rect(850,500,150,180);
  textSize(30);
  fill(0);
  text("Slurpee",860,550);
  text("$1.95",860,600);
  //End of slurpee sign
  //Start of snacks and drinks sign
  fill(255,255,0);
  rect(1010,500,150,80);
  textSize(15);
  fill(255,0,0);
  text("Snacks",1015,515);
  text("&",1015,535);
  text("Drinks",1015,555);
  //End of snacks and drinks sign
  //Start of black bars
  fill(0);
  rect(1050,600,10,250);
  rect(1350,600,10,250);
  rect(1195,600,10,250);
  rect(1205,600,10,250);
  rect(1050,600,300,10);
  rect(750,840,650,10);
  rect(750,400,650,10);
  rect(750,400,10,450);
  rect(1400,400,10,450);
  //End of black bars
  //Start of door handles
  fill(100);
  rect(1175,725,20,40);
  rect(1215,725,20,40);
  //End of door handles
  //Start of trash cans
  fill(139,69,19);
  rect(400,760,80,100);
  rect(1400,760,80,100);
  fill(100);
  quad(410, 730, 470, 730, 490, 780,390, 780);
  quad(1410, 730, 1470, 730, 1490, 780, 1390, 780);
  //End of trash cans
  stars();
  for(int i = 0; i < avatars.length; i++){
    avatars[i].avatarmaincharacter();
  }
  for(int i = 0; i < randomavatars.length; i++){
    randomavatars[i].avatarcharacters();
  }
  for(int i = 0; i < r.length; i++){
    r[i].show();
    r[i].fall();
  }
  box();
  fries();
  cloud();
}
void stars(){
  a++;
  b++;
  c++;
  d++;
  e++;
  f++;
  g++;
  while(a >= 255){
    a -= 100;
  }
  while(b >= 255){
    b -= 100;
  }
  while(c >= 255){
    c -= 100;
  }
  while(d >= 255){
    d -= 100;
  }
  while(e >= 255){
    e -= 100;
  }
  while(f >= 255){
    f -= 100;
  }
  while(g >= 255){
    g -= 100;
  }
  fill(255,255,0,a);
  circle(40,100,20);
  fill(255,255,0,b);
  circle(300,20,22);
  fill(255,255,0,c);
  circle(500,70,16);
  fill(255,255,0,d);
  circle(1000,90,14);
  fill(255,255,0,e);
  circle(1600,125,17);
  fill(255,255,0,f);
  circle(1800,40,18);
  fill(255,255,0,g);
  circle(1850,200,15);
}
void box(){
  fill(255,0,0,255);
  rect(x+(sin(x/100)*50)+1080,(cos(y/5)*80)+735,60,40);// red fries box
}
void fries(){
  fill(255,255,0,alpha);
  rect(x+(sin(x/100)*50)+1080,(cos(y/5)*80)+705,10,30);
  fill(255,255,0,alpha+255);
  rect(x+(sin(x/100)*50)+1095,(cos(y/5)*80)+705,10,30);
  fill(255,255,0,alpha+510);
  rect(x+(sin(x/100)*50)+1110,(cos(y/5)*80)+705,10,30);
  fill(255,255,0,alpha+765);
  rect(x+(sin(x/100)*50)+1125,(cos(y/5)*80)+705,10,30);
  if(x == 0){//if x = 0 set alpha at 255
    alpha = 255;
  }
}
void keyPressed() {//if space is pessed decrease alpha by 255
  if (key == ' '){
  alpha -= 255;
  }
}
void cloud(){//cloud start
  fill(150,150,150,200);
  ellipse(z+700,100,300,150);
  ellipse(z+50,150,250,250);
  ellipse(z+100,200,400,250);
  ellipse(z+620,50,150,200);
  ellipse(z+1700,300,200,50);
  ellipse(z+1675,275,150,50);
  z += 20;
  if(z == 2000){
  z += (-4000);
  }
}//cloud end
