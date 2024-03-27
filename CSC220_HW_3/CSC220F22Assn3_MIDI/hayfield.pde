int hayBaleCount = 0, hayBaleMax = 0;
final int cloverResolution = 100 ;
void makeCloverPShape() {
  cloverPImage = loadImage("clover.png");
   //cloverPImage.resize(cloverResolution, cloverResolution);
   //cloverPImage.loadPixels();
  cloverPShape = createShape(BOX,cloverResolution, cloverResolution*1.5, cloverResolution*2);
  cloverPShape.setStroke(false);
  cloverPShape.setTexture(cloverPImage);
  cloverPShape.translate(cloverResolution/2, cloverResolution*0.75,0); // shapeMode(CENTER) broken
  int newcells = 0 ;
  for (int x = 0 ; x < width ; x += cloverResolution*2) {
    for (int y = 0 ; y < height ; y += cloverResolution*3) {
      for (int z = minimumZ ; z < maximumZ ; z += cloverResolution*4) {
        newcells++ ;
      }
    }
  }
  int oldcells = avatars.length ;
  Avatar [] newavatars = new Avatar [ oldcells + newcells ];
  java.lang.System.arraycopy(avatars, 0, newavatars, 0, oldcells);
  int cellix = oldcells ;
  for (int x = 0 ; x < width ; x += cloverResolution*2) {
    for (int y = 0 ; y < height ; y += cloverResolution*3) {
      for (int z = minimumZ ; z < maximumZ ; z += cloverResolution*4) {
        // SLOW!!! avatars = (Avatar []) append(avatars, new HayBale(x, y, z, avatars.length));
        newavatars[cellix] = new HayBale(x, y, z, cellix);
        cellix++ ;
      }
    }
  }
  hayBaleCount = hayBaleMax = newcells ;
  avatars = newavatars ;
}
float lastHayNote = 0 ;
class HayBale implements Avatar {
  final int channel = 1;
  final int DrawbarOrgan = 16 ;
  int mowCounter = 0;
  // http://midi.teragonaudio.com/tutr/gm.htm
  final int pitch = 36 ;  // multiple of 12 for "C"
  // http://midi.teragonaudio.com/tutr/gm.htm says 17 is Drawbar Organ
  int x, y, z, avatarsIndex ;
  HayBale(int x, int y, int z, int avatarsIndex) {
    this.x = x ;
    this.y = y ;
    this.z = z ;
    this.avatarsIndex = avatarsIndex ;
  }
  void display() {
    push();
    translate(x, y, z);
    if (mowCounter > 0){
      scale(4,1.0-mowCounter/50.0,3);
    }
    shape(cloverPShape, 0, 0);
    pop();
    // USE MIDI channel 1 and instrument organ. Cannot run in constructor
    // must wait until after initMIDI() runs in draw():
    sendMIDI(ShortMessage.PROGRAM_CHANGE, channel, DrawbarOrgan, 0);
    float elapsed = ((float)frameCount / (float)frameRate) - lastHayNote ;
    int volumeAdjust = 7 ;
    int volumeLevel = int(constrain(map(float(hayBaleCount), 0.0, float(hayBaleMax), 64.0, 127.0), 64.0, 127.0));
    sendMIDI(ShortMessage.CONTROL_CHANGE, channel, volumeAdjust, volumeLevel);
    if (lastHayNote == 0 || elapsed > 60) {
      sendMIDI(ShortMessage.NOTE_ON, channel, pitch, 127);
      lastHayNote = ((float)frameCount / (float)frameRate);
      // See http://midi.teragonaudio.com/tech/midispec.htm
    }
  }
  void move() {
    if(mowCounter > 0){
      mowCounter += 1 ;
    }
    if(mowCounter > 50){
      avatars[avatarsIndex] = null ;
    hayBaleCount = constrain(hayBaleCount-1, 0, hayBaleCount);
    // println("DEBUG hayBaleCount hayBaleMAX", hayBaleCount, hayBaleMax);
    if (hayBaleCount == 0) {
      sendMIDI(ShortMessage.NOTE_OFF, channel, pitch, 0);
      }
    }
  }
  int getX() { return x; }
  int getY() { return y; }
  int getZ() { return z; }
  int [] getBoundingBox() {
    int [] result = new int[6];
    result[0] = x - cloverResolution/2 ;
    result[1] = y - int(cloverResolution*.75) ;
    result[2] = z - cloverResolution ;
    result[3] = x + cloverResolution/2 ;
    result[4] = y + int(cloverResolution*.75) ;
    result[5] = z + cloverResolution ;
    return result ;
  }
  void shuffle() {}
  void forceshuffle() {
      x = int(random(0,width));
      y = int(random(0, height));
      z = int(random(minimumZ, maximumZ));
  }
  void mow() {
    mowCounter += 1 ;
  }
}
