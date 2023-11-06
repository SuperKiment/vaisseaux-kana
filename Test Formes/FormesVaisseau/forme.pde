class FormeVaisseau {
  ArrayList<PVector> forme;

  FormeVaisseau(Block[][] bs) {
    forme = new ArrayList<PVector>();
  }

  int direction = 0, // 0 : L  /  1 : U  /  2 : R  /  3 : B
    px = -1, py = -1, basePx = -2, basePy = -2;
  boolean fini = false;
  boolean changDir = false;



  void Cherche(Block[][] blocks) {

    println();
    println("direction : "+direction);
    println("test : "+px +" "+py);
    //Si on a pas de premier block, le trouver
    if (px == -1 && py == -1) {
      boolean br = false;

      for (int x=0; x<blocks.length; x++) {
        for (int y=0; y<blocks[0].length; y++) {
          if (blocks[x][y] != null) {
            px = x;
            py = y;
            basePx = x;
            basePy = x;
            println(basePx, basePy);
            forme.add(new PVector(px, py));
            br = true;
            break;
          }
        }
        if (br) break;
      }
    }


    switch(direction) {
    case 0:
      if (blocks[px][py] != null && blocks[px][py-1] == null) {
        px++;
        forme.add(new PVector(px, py));
      } else changDir = true;
      break;
    case 1:
      if (blocks[px][py-1] != null && blocks[px-1][py-1] == null) {
        py--;
        forme.add(new PVector(px, py));
      } else changDir = true;
      break;
    case 2:
      if (blocks[px-1][py] == null && blocks[px-1][py-1] != null) {
        px--;
        forme.add(new PVector(px, py));
      } else changDir = true;
      break;
    case 3:
      if (blocks[px][py] == null && blocks[px-1][py] != null) {
        py++;
        forme.add(new PVector(px, py));
      } else changDir = true;
      break;
    }

    if (changDir) {
      direction++;
      direction%=4;
    }

    if (px == basePx && py == basePy) fini = true;
  }

  void Render() {
    fill(255, 0, 0);
    for (PVector v : forme) {
      ellipse(v.x*Block.tailleBloc, v.y*Block.tailleBloc, 10, 10);
    }
  }
}
