class Vaisseau {

  PVector pos, dir, vel
    , centreMasse;
  float speed = 5, puissance = 0.01,
    rotSpeed = 0, rotPuissance = 0.001;
  Block[][] allBlocks;
  boolean displayGrid = true,
    up = false, down = false, left = false, right = false, straftL = false, straftR = false;

  Vaisseau() {
    pos = new PVector();
    dir = new PVector(1, 1);
    vel = new PVector();
    dir.setMag(1);

    allBlocks = new Block[10][10];

    addBlock(5, 5, new Block());
    addBlock(6, 5, new Block());
    addBlock(7, 5, new Block());
    addBlock(8, 5, new Block());

    addBlock(5, 4, new Block());
    addBlock(6, 4, new Block());
    addBlock(7, 4, new Block());
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

    if (straftL) {
      PVector straftvel = dir.copy();
      straftvel.rotate(-PI/2);
      straftvel.setMag(speed*(puissance/3));
      vel.add(straftvel);
    }

    if (straftR) {
      PVector straftvel = dir.copy();
      straftvel.rotate(PI/2);
      straftvel.setMag(speed*(puissance/3));
      vel.add(straftvel);
    }

    if (left) {
      rotSpeed -= rotPuissance;
    }
    if (right) {
      rotSpeed += rotPuissance;
    }

    if (!left && !right) {
      rotSpeed = lerp(rotSpeed, 0, 0.01);
      println(rotSpeed);
      if (abs(rotSpeed) < 0.0025) rotSpeed = 0;
    }

    if (!up && !down && !straftL && !straftR) {
      if (vel.mag() < .07) vel.setMag(0);
      if (vel.mag() < .3) vel.lerp(new PVector(), 0.01f);
    }

    dir.rotate(rotSpeed);
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
    b.x = x;
    b.y = y;

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







  //=======================LIAISON BLOCK

  class LiaisonBlock {
    ArrayList<Block> blocks;

    LiaisonBlock() {
      RecreateBlocks();
    }

    void Render() {
      int minX=999, minY=999, maxX=-1, maxY=-1;

      for (Block b : blocks) {
        if (b.x < minX) minX = b.x;
        if (b.x > maxX) maxX = b.x;
        if (b.y < minX) minX = b.y;
        if (b.y > maxX) maxX = b.y;
      }

      rect(minX*Block.tailleBloc, minY*Block.tailleBloc, maxX*Block.tailleBloc, maxY*Block.tailleBloc);
    }

    void RecreateBlocks() {
      for (Block b : blocks) b.linked = false;
      blocks.clear();

      for (int x=0; x<allBlocks.length; x++) {
        for (int y=0; y<allBlocks[0].length; y++) {
          
        }
      }
    }
  }
}
