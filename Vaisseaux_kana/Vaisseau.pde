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

      PVector coin1 = new PVector(-allBlocks.length * Block.tailleBloc/2, -allBlocks[0].length * Block.tailleBloc/2);
      coin1.rotate(dir.heading());
      PVector centreMasseOffset = centreMasse.copy();
      centreMasseOffset.sub(new PVector(allBlocks.length * Block.tailleBloc/2, allBlocks[0].length * Block.tailleBloc/2));
      println(centreMasseOffset);
      coin1.add(centreMasseOffset);
      centreMasseOffset.rotate(dir.heading());
      coin1.sub(centreMasseOffset);
      coin1.add(pos);
      rect(coin1.x, coin1.y, 10, 10);
      
      PVector coin2 = new PVector(-allBlocks.length * Block.tailleBloc/2, -allBlocks[0].length * Block.tailleBloc/2);
      coin2.rotate(dir.heading());
      centreMasseOffset.set(centreMasse.copy());
      centreMasseOffset.sub(new PVector(allBlocks.length * Block.tailleBloc/2, allBlocks[0].length * Block.tailleBloc/2));
      println(centreMasseOffset);
      coin2.add(centreMasseOffset);
      centreMasseOffset.rotate(dir.heading());
      coin2.sub(centreMasseOffset);
      coin2.add(pos);
      rect(coin2.x, coin2.y, 10, 10);
    }

    return true;
  }
}
