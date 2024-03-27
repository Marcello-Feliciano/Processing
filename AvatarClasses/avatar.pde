float x = 0;
float y = 0;
float speed = 6;
float rads = 0;
class avatar{
  //pushMatrix();//avatarstart
  //translate(0,y);
  void avatarmaincharacter(){
  fill(150,0,150,255);
  //ellipse(x+1110,730,75,125);//body
  ellipse(x+(sin(x/100)*50)+1110, (cos(y/5)*80)+730,75, 125);
  fill(0);
  ellipse(x+(sin(x/100)*50)+1095,(cos(y/5)*80)+820,25,75);//l leg
  ellipse(x+(sin(x/100)*50)+1125,(cos(y/5)*80)+820,25,75);//r leg
  ellipse(x+(sin(x/100)*50)+1070,(cos(y/5)*80)+735,25,75);//l arm
  ellipse(x+(sin(x/100)*50)+1150,(cos(y/5)*80)+735,25,75);//r arm
  fill(210,180,140);
  circle(x+(sin(x/100)*50)+1110,(cos(y/5)*80)+620,100);//face
  fill(255);
  circle(x+(sin(x/100)*50)+1090,(cos(y/5)*80)+610,30);//l eye
  fill(0);
  circle(x+(sin(x/100)*50)+1092,(cos(y/5)*80)+612,15);//l eye
  fill(255);
  circle(x+(sin(x/100)*50)+1130,(cos(y/5)*80)+610,30);//r eye
  fill(0);
  circle(x+(sin(x/100)*50)+1132,(cos(y/5)*80)+612,15);//r eye
  fill(255,0,0,175);
  triangle(x+(sin(x/100)*50)+1060, (cos(y/5)*80)+580, x+(sin(x/100)*50)+1110, (cos(y/5)*80)+420, x+(sin(x/100)*50)+1160, (cos(y/5)*80)+580);//hat
  fill(0);
  circle(x+(sin(x/100)*50)+1110,(cos(y/5)*80)+520,40);//hat
  fill(255);
  circle(x+(sin(x/100)*50)+1110,(cos(y/5)*80)+520,20);//hat
  fill(0);
  ellipse(x+(sin(x/100)*50)+1110,(cos(y/5)*80)+640,40,20);//mouth
  x = x + speed;
  if ((x > width/1.7) || (x < 0)) {
    speed = speed * -1;
    }
  y++;
  }
}
