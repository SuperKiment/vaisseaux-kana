class Vaisseau {

  PVector pos, dir, vel
    , centreMasse;
  float speed = 5, puissance = 0.01;
  Block[][] allBlocks;
  boolean displayGrid = true,
    up = false, down = false, left = false, right = false;

  Vaisseau() {
    pos = new PVector();
    dir = new PVector(1, 1);
    vel = new PVector();
    dir.setMag(1);

    allBlocks = new Block[10][10];
  }

  void Render() {
    push();
    translate(pos.x, pos.y);
    translate(- allBlocks.length * Block.tailleBloc / 2, - allBlocks[0].length * Block.tailleBloc / 2);
    translate(centreMasse.x, centreMasse.y);
    rotate(dir.heading());
    translate(-centreMasse.x, -centreMasse.y);
    if (displayGrid) {
      push();
      fill(0, 0, 0, 0);
      stroke(0, 255, 255);
      for (int x=0; x<allBlocks.length; x++) {
        for (int y=0; y<allBlocks[0].length; y++) {
          rect(x*Block.tailleBloc, y*Block.tailleBloc, Block.tailleBloc, Block.tailleBloc);
        }
      }
      pop();
    }

    rect((allBlocks.length-.5) * Block.tailleBloc/2, (allBlocks[0].length-.5) * Block.tailleBloc/2, 10, 10);

    for (int x=0; x<allBlocks.length; x++) {
      for (int y=0; y<allBlocks[0].length; y++) {
        if (allBlocks[x][y] != null) {
          Block b = allBlocks[x][y];
          push();
          translate(x*Block.tailleBloc, y*Block.tailleBloc);
          b.Render();
          pop();
        }
      }
    }

    push();
    fill(255, 0, 0);
    ellipse(centreMasse.x, centreMasse.y, 10, 10);
    pop();
    pop();
  }

  void Update() {
    centreMasse = trouverCentreMasse();

    if (up) {
      PVector addvel = dir.copy();
      addvel.setMag(speed*puissance);
      vel.add(addvel);
    }

    if (down) {
      PVector subvel = dir.copy();
      subvel.setMag(speed*puissance);
      vel.sub(subvel);
    }

    if (left) {
      dir.rotate(-.05);
    }

    if (right) {
      dir.rotate(.05);
    }

    pos.add(vel);

    for (int x=0; x<allBlocks.length; x++) {
      for (int y=0; y<allBlocks[0].length; y++) {
        if (allBlocks[x][y] != null) {
          Block b = allBlocks[x][y];
          b.Update();
        }
      }
    }
  }

  void addBlock(int x, int y, Block b) {
    if (x >= 0 && x < allBlocks.length && y >= 0 && y < allBlocks[0].length) {
      if (allBlocks[x][y] == null) {
        allBlocks[x][y] = b;
        println("added en", x, y);
      } else println("déjà un block");
    } else println("block out of bound");
  }

  PVector trouverCentreMasse() {
    PVector res = new PVector();
    int nb = 0;

    for (int x=0; x<allBlocks.length; x++) {
      for (int y=0; y<allBlocks[0].length; y++) {
        if (allBlocks[x][y] != null) {
          res.add(new PVector(x, y));
          nb++;
        }
      }
    }


    res.div(nb);
    res.mult(Block.tailleBloc);
    res.add(new PVector(Block.tailleBloc/2, Block.tailleBloc/2));

    return res;
  }

  boolean isMouseOnGrid() {
    if (centreMasse != null) {
      PVector coin1 = getBlockPosition(0, 0);
      PVector coin2 = getBlockPosition(allBlocks.length, 0);
      PVector coin3 = getBlockPosition(0, allBlocks[0].length);
      PVector coin4 = getBlockPosition(allBlocks.length, allBlocks[0].length);
      
      //Premier tri
      return IsPointInTriangle(new PVector(mouseX, mouseY), coin1, coin2, coin3) || IsPointInTriangle(new PVector(mouseX, mouseY), coin4, coin2, coin3);
    }
    return true;
  }
  
  PVector getBlockPosition(int x, int y) {

    //Magik happens
    PVector posCM = pos.copy();
    posCM.add(new PVector(- allBlocks.length * Block.tailleBloc / 2, - allBlocks[0].length * Block.tailleBloc / 2));
    posCM.add(centreMasse);
    PVector CMaCoin = PVector.sub(new PVector(x*Block.tailleBloc, y*Block.tailleBloc), centreMasse);
    CMaCoin.rotate(dir.heading());
    posCM.add(CMaCoin);
    
    return posCM;
  }
}
