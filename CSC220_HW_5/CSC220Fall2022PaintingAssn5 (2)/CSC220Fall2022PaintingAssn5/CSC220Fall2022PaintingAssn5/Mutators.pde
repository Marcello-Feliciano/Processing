// https://docs.oracle.com/javase/8/docs/api/index.html?java/util/Arrays.html

class MutatorManager extends PImageMutator {
  // This is the one dispatched in the worker thread.
  public MutatorManager(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    PImageMutator nextone = null ;
    super.call();
    try {
      for (int i = 0 ; i < threadMutatorQueue.size() ; i++) {
        nextone = threadMutatorQueue.get(i);
        nextone.setMorphedImage(morphedImage);
        morphedImage = nextone.call();
      }
    } catch (Exception xxx) {
      System.err.println("EXCEPTION IN MUTATOR: " + xxx.getClass().getName() + ": " + xxx.getMessage());
      this.flushPendingTasks();
    }
    // println("DEBUG IN MANAGER");
    return morphedImage ;
  }
  void flushPendingTasks() {
    PImage replacement = null ;
    if (imageQueue.size() > 0) {
      replacement = imageQueue.get(0).copy();
    }
    for (int i = 0 ; i < threadMutatorQueue.size() ; i++) {
      PImageMutator nextone = threadMutatorQueue.get(i);
      if (nextone != null) {
        // println("DEBU
        nextone.setMorphedImage(replacement);
      }
    }
    this.setMorphedImage(replacement);
  }
}

class BlurMutator extends PImageMutator {
  final int blurFactor ;
  public BlurMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
    this.blurFactor = (posArgs != null && posArgs.length > 0) ? int(constrain(posArgs[0], 2, 255)) : 2 ;
  }
  public PImage call() {
    // println("DEBUG IN BLUR FILTER");
    super.call();
    morphedImage.filter(BLUR,blurFactor);
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class FadeMutator extends PImageMutator {
  volatile int opacity  ;
  final float opacityDecayRate ;
  volatile boolean isdown = true ;
  public FadeMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
    this.opacity = (posArgs != null && posArgs.length > 0) ? constrain(round(posArgs[0]), 0, 255) : 255 ;
    this.opacityDecayRate = (posArgs != null && posArgs.length > 1) ? constrain(posArgs[1], 0.000001, 0.999999) : .999999 ;
    println("DEBUG 0 FadeMutator", opacity, opacityDecayRate);
  }
  public PImage call() {
    super.call();
    PImage maskImage = createImage(morphedImage.width, morphedImage.height, ARGB);
    maskImage.loadPixels();
    Arrays.fill(maskImage.pixels, opacity);
    maskImage.updatePixels();
    morphedImage.mask(maskImage);
    // println("DEBUG 1 FadeMutator", opacity, opacityDecayRate);
    if (isdown) {
      opacity = floor(constrain(opacity*opacityDecayRate,1,255));
      if (opacity < 2) {
        isdown = false ;
      }
    } else {
      opacity = floor(constrain(ceil(opacity/opacityDecayRate),1,255));
      if (opacity > 253) {
        isdown = true ;
      }   
    }
    // println("DEBUG 2 FadeMutator", opacity, opacityDecayRate);
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class EtchMutator extends PImageMutator {
  final float probabilityOfEtch ; // probabilityOfEtch must be in range [0.0, 100.0)
  public EtchMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
    this.probabilityOfEtch = (posArgs != null && posArgs.length > 0) ? posArgs[0] : 0.15 ;
  }
  public PImage call() {
    super.call();
    morphedImage.loadPixels();
    for (int row = 0 ; row < morphedImage.height ; row++) {
      for (int col = 0 ; col < morphedImage.width ; col++) {
        int pix = (row * morphedImage.width) + col ;  // index down row rows of width pixels each
        if (morphedImage.pixels[pix] == 0
            && random(0, 100) < probabilityOfEtch) {  // transparent, make its neighbors transparent
          for (int subrow = max(row-1,0) ; subrow < min(row+2,morphedImage.height) ; subrow++) {
            for (int subcol = max(col-1,0) 
                ; subcol < min(col+1,morphedImage.width) ; subcol++) {
              int subpix = (subrow * morphedImage.width) + subcol ;
              morphedImage.pixels[subpix] = 0 ;
            }
          }
        } else if (random(0, 100) < probabilityOfEtch) {
          morphedImage.pixels[pix] = 0 ;
        }
      }
    }
    morphedImage.updatePixels();
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class NestMutator extends PImageMutator {
  final float scaledown ;
  volatile PImage spare = null ;
  volatile float currentScale = 1.0 ;
  public NestMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
    this.scaledown = (posArgs != null && posArgs.length > 0) ? constrain(posArgs[0], 0.000001, 0.999999) : .75 ;
    
  }
  public PImage call() {
    super.call();
    if (images.size() > 0) {
      spare = images.get(0).copy(); ;
    }
    currentScale *= scaledown ;
    // println("DEBUG 1 currentScale ", currentScale);
    if (currentScale < .000000001) {
      morphedImage = spare ;
      currentScale = 1.0 ;
    }
    // Do this in a loop and not recursively so we can go backwards and zoom out.
    // for (float scaler = scaledown ; scaler > .000001 ; scaler = scaler * scaler) {
      int w = round(scaledown * morphedImage.width);
      int h = round(scaledown * morphedImage.height);
      PImage clone = morphedImage.copy();
      clone.resize(w, h);
      int left = (morphedImage.width - clone.width) / 2 ;  // left margin
      int top = (morphedImage.height - clone.height) / 2 ;  // top margin
      // morphedImage.set(left, top, clone);
      morphedImage.loadPixels();
      clone.loadPixels();
      for (int fromrow = 0, torow = top ; fromrow < clone.height ; fromrow++, torow++) {
        System.arraycopy(clone.pixels,(fromrow*clone.width), morphedImage.pixels,
          (torow*morphedImage.width)+left, clone.width);
      }
      morphedImage.updatePixels();
      clone = null ;
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class MaskMutator extends PImageMutator {
  public MaskMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    PImage masker = (images.size() > 1) ? images.get(1) : null ;
    if (morphedImage != null && masker != null) {
      masker.resize(morphedImage.width, morphedImage.height);
      morphedImage.mask(masker);
      return morphedImage ;
    }
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class BlendScreenMutator extends PImageMutator {
  public BlendScreenMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    PImage blender = (images.size() > 1) ? images.get(1) : null ;
    if (morphedImage != null && blender != null) {
      blender.resize(morphedImage.width, morphedImage.height);
      morphedImage.blend(blender, 0, 0, morphedImage.width, morphedImage.height,
        0, 0, blender.width, blender.height, SCREEN);
      return morphedImage ;
    }
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class ThresholdEtchMutator extends PImageMutator {
  volatile float boundary ;
  volatile boolean isdown = false ;
  public ThresholdEtchMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
    this.boundary = 0.0 ;
  }
  public PImage call() {
    super.call();
    if (images.size() > 0) {
      morphedImage = images.get(0).copy(); ;
    }
    PImage masker = morphedImage.copy();
    if (isdown) {
      masker.filter(INVERT);
    }
    masker.filter(THRESHOLD, boundary);
    morphedImage.mask(masker);
    masker = null ;
    if (isdown) {
      boundary -= 0.005 ;
      if (boundary < 0.0) {
        boundary = 0.0 ;
        isdown = false ;
      }
    } else {
      boundary += 0.005 ;
      if (boundary > 1.0) {
        boundary = 1.0 ;
        isdown = true ;
      }
    }
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class CircleEtchMutator extends PImageMutator {
  volatile float limit = 1.0 ;
  volatile boolean isdown = true ;
  public CircleEtchMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    if (images.size() > 0) {
      morphedImage = images.get(0).copy(); ;
    }
    PImage masker = morphedImage.copy();
    masker.loadPixels();
    int filler = 0x0ffffffff ;
    if (isdown) {
      Arrays.fill(masker.pixels, 0);
    } else {
      Arrays.fill(masker.pixels, filler);
      filler = 0 ;
    }
    int radius = min(masker.width, masker.height) / 2 ;
    int centerx = masker.width / 2 ;
    int centery = masker.height / 2 ;
    for (int row = 0 ; row < masker.height ; row++) {
      for (int col = 0 ; col < masker.width ; col++) {
        if (dist(col, row, centerx, centery) < (limit * radius)) {
          int pix = (row * masker.width) + col ;
          masker.pixels[pix] = filler  ;
        }
      }
    }
    morphedImage.mask(masker);
    masker = null ;
    if (isdown) {
      limit -= 0.005 ;
      if (limit < 0.1) {
        limit = 0.1 ;
        isdown = false ;
      }
    } else {
      limit += 0.005 ;
      if (limit > 0.9) {
        limit = 0.9 ;
        isdown = true ;
      }
    }
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class SquareEtchMutator extends PImageMutator {
  volatile float limit = 1.0 ;
  volatile boolean isdown = true ;
  public SquareEtchMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    if (images.size() > 0) {
      morphedImage = images.get(0).copy(); ;
    }
    PImage masker = morphedImage.copy();
    masker.loadPixels();
    int filler = 0x0ffffffff ;
    if (isdown) {
      Arrays.fill(masker.pixels, 0);
    } else {
      Arrays.fill(masker.pixels, filler);
      filler = 0 ;
    }
    int radius = min(masker.width, masker.height) / 2 ;
    int centerx = masker.width / 2 ;
    int centery = masker.height / 2 ;
    int left = (masker.width - radius) / 2 ;
    int top = (masker.height - radius) / 2;
    for (int row = 0 ; row < masker.height ; row++) {
      for (int col = 0 ; col < masker.width ; col++) {
        if (col >= left*limit && col <= (masker.width-left*limit)
            && row >= top*limit && row <= (masker.height-top*limit)) {
          int pix = (row * masker.width) + col ;
          masker.pixels[pix] = filler  ;
        }
      }
    }
    morphedImage.mask(masker);
    masker = null ;
    if (isdown) {
      limit -= 0.005 ;
      if (limit < 0.01) {
        limit = 0.01 ;
        isdown = false ;
      }
    } else {
      limit += 0.005 ;
      if (limit > 1.0) {
        limit = 1.0 ;
        isdown = true ;
      }
    }
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class PosterMutator extends PImageMutator {
  volatile float posterLevel = 20 ;
  final float downcount = 0.10 ;
  public PosterMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    if (images.size() > 0) {
      morphedImage = images.get(0).copy(); // re-posterize original image
    }
    morphedImage.filter(POSTERIZE,constrain(round(posterLevel), 2, 255));
    posterLevel -= downcount ;
    if (round(posterLevel) < -10) {
      posterLevel = 20 ;
      loaderThread.triggerLoadImage(1); // STUDENT REMOVE THIS LINE TO STAY WITH SAME PImage
    }
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}
  
class ErodeMutator extends PImageMutator {
  volatile int erodeLevel = 512 ;
  volatile boolean isdown = true ;
  public ErodeMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    erodeLevel -= 1 ;
    if (round(erodeLevel) < 10) {
      // loaderThread.triggerLoadImage(1); // STUDENT UNCOMMENT THIS LINE TO ADVANCE  PImage
      morphedImage = images.get(0).copy(); // re-erode original image
      erodeLevel = 512 ;
    }
    if ((erodeLevel & 1) == 1) {  // only do every opther one
      morphedImage.filter(ERODE);
    }
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class DilateMutator extends PImageMutator {
  volatile int dilateLevel = 512 ;
  volatile boolean isdown = true ;
  public DilateMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    dilateLevel -= 1 ;
    if (round(dilateLevel) < 10) {
      // loaderThread.triggerLoadImage(1); // STUDENT UNCOMMENT THIS LINE TO ADVANCE  PImage
      morphedImage = images.get(0).copy(); // re-erode original image
      dilateLevel = 512 ;
    }
    if ((dilateLevel & 1) == 1) {  // only do every opther one
      morphedImage.filter(DILATE);
    }
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  }
}

class InvisibleMutator extends PImageMutator {
  
  volatile int countdown = 20 ;
  volatile boolean isdown = true ;
  public InvisibleMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    countdown--;
    if(countdown == 0){
      morphedImage.filter(INVERT);
      countdown = 20;
    }
    //countdown -= 1 ;
    //if (round(blendLevel) < 10) {
      // loaderThread.triggerLoadImage(1); // STUDENT UNCOMMENT THIS LINE TO ADVANCE  PImage
      //morphedImage = images.get(0).copy(); // re-erode original image
      ////blendLevel = 1 ;
    //}
    //if ((blendLevel & 1) == 1) {  // only do every opther one
      
   // }
    PImage result = morphedImage ;
   // morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);
  
  /*// Make foregound invisible so the background and fopreground draw()s dominate.
  public InvisibleMutator(List<PImage> images, PImage morphedImage, Float [] posArgs) {
    super(images, morphedImage);
  }
  public PImage call() {
    super.call();
    morphedImage = createImage(width, height, ARGB);
    PImage result = morphedImage ;
    morphedImage = null ;    // Do not save extra images that consume memory.
    return(result);*/
  }
}
