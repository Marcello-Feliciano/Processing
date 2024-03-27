class rain{
  float x = random(width);
  float y = random(-700,-100);
  float z = random(0,25);
  float leng = map(z, 0, 20, 10,20);
  float yspeed = map(z, 0, 20, 1, 20);
  void fall(){
    y = y + yspeed;
    float grav = map(z, 0, 20, 0, 0.2);
    yspeed = yspeed + grav;
    
    if(y > height){
      y = random(-700,-100);
      x = random(width);
      yspeed = map(z, 0, 20, 1, 20);
  }
 }
  void show(){
    stroke(0,0,200,150);
    line(x,y,x,y+leng);
  }
}
