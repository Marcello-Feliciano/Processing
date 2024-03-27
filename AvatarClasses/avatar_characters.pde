class avatar_characters{  
  float xrandom = random(0,000);
  float yrandom = random(-0,1000);
  float speedrandom = random(1,20);
  void avatarcharacters(){
    fill(150,0,150,255);
    //ellipse(x+1110,730,75,125);//body
    ellipse(xrandom+(sin(x/100)*50)+1110, (cos(y/5)*80)+730,75, 125);
  fill(0);
  ellipse(xrandom+(sin(x/100)*50)+1095,(cos(y/5)*80)+820,25,75);//l leg
  ellipse(xrandom+(sin(x/100)*50)+1125,(cos(y/5)*80)+820,25,75);//r leg
  ellipse(xrandom+(sin(x/100)*50)+1070,(cos(y/5)*80)+735,25,75);//l arm
  ellipse(xrandom+(sin(x/100)*50)+1150,(cos(y/5)*80)+735,25,75);//r arm
  fill(210,180,140);
  circle(xrandom+(sin(x/100)*50)+1110,(cos(y/5)*80)+620,100);//face
  fill(255);
  circle(xrandom+(sin(x/100)*50)+1090,(cos(y/5)*80)+610,30);//l eye
  fill(0);
  circle(xrandom+(sin(x/100)*50)+1092,(cos(y/5)*80)+612,15);//l eye
  fill(255);
  circle(xrandom+(sin(x/100)*50)+1130,(cos(y/5)*80)+610,30);//r eye
  fill(0);
  circle(xrandom+(sin(x/100)*50)+1132,(cos(y/5)*80)+612,15);//r eye
  fill(255,0,0,175);
  triangle(xrandom+(sin(x/100)*50)+1060, (cos(y/5)*80)+580, xrandom+(sin(x/100)*50)+1110, (cos(y/5)*80)+420, xrandom+(sin(x/100)*50)+1160, (cos(y/5)*80)+580);//hat
  fill(0);
  circle(xrandom+(sin(x/100)*50)+1110,(cos(y/5)*80)+520,40);//hat
  fill(255);
  circle(xrandom+(sin(x/100)*50)+1110,(cos(y/5)*80)+520,20);//hat
  fill(0);
  ellipse(xrandom+(sin(x/100)*50)+1110,(cos(y/5)*80)+640,40,20);//mouth
    xrandom = xrandom + speedrandom;
    if ((xrandom > 1000) || (xrandom < -1100)) {
      speedrandom = speedrandom * -1;
    }
  yrandom++;
  }
}
