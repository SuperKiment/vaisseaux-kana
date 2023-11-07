class Vaisseau {

  PVector pos, dir, vel
    , centreMasse;
  float speed = 5, puissance = 0.01,
    rotSpeed = 0, rotPuissance = 0.001;
  Block[][] allBlocks;
  boolean displayGrid = false,
    up = false, down = false, left = false, right = false, straftL = false, straftR = false,
    isFocused = false,
    tirer = false;
  FormeVaisseau formeVaisseau;
  ArrayList<Tourelle> allTourelles;
  String ID = String.valueOf(int(random(10000, 99999)));

  Vaisseau() {
    pos = new PVector();
    dir = new PVector(1, 1);
    vel = new PVector();
    dir.setMag(1);

    allBlocks = new Block[10][10];

    addBlock(5, 5, new Block(), true);
    addBlock(6, 5, new Block(), true);
    addBlock(7, 5, new Block(), true);
    addBlock(8, 5, new Block(), true);

    addBlock(5, 4, new Block(), true);
    addBlock(6, 4, new Block(), true);
    addBlock(7, 4, new Block(), true);

    formeVaisseau = new FormeVaisseau(allBlocks);

    allTourelles = new ArrayList<Tourelle>();
    allTourelles.add(new Tourelle(allBlocks[5][5]));
    allTourelles.add(new Tourelle(allBlocks[7][5]));
  }

  void Render() {
    //Base translate
    push();
    translate(pos.x, pos.y);
    translate(- allBlocks.length * Block.tailleBloc / 2, - allBlocks[0].length * Block.tailleBloc / 2);
    translate(centreMasse.x, centreMasse.y);
    rotate(dir.heading());
    translate(-centreMasse.x, -centreMasse.y);

    if (displayGrid) {
      RenderGrid();
    }

    //Centre du vaisseau
    //rect((allBlocks.length-.5) * Block.tailleBloc/2, (allBlocks[0].length-.5) * Block.tailleBloc/2, 10, 10);

    RenderBlocks();

    RenderCentreDeMasse();
    formeVaisseau.Render();

    RenderTourelles();
    pop();
  }

  void RenderGrid() {
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

  void RenderBlocks() {
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
  }

  void RenderCentreDeMasse() {
    push();
    fill(255, 0, 0);
    ellipse(centreMasse.x, centreMasse.y, 10, 10);
    pop();
  }

  void RenderTourelles() {
    for (Tourelle t : allTourelles) {
      t.Render();
    }
  }

  void Update() {
    PVector ancienCentreMasse = null;
    if (centreMasse != null)
      ancienCentreMasse = centreMasse.copy();

    centreMasse = trouverCentreMasse();
    if (ancienCentreMasse != null)
      if (PVector.sub(ancienCentreMasse, centreMasse).mag() > 0) {
        println(PVector.sub(ancienCentreMasse, centreMasse));
        //pos.add(PVector.sub(ancienCentreMasse, centreMasse));
        println("sheeesh");
      }

    Input();

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

    for (Tourelle t : allTourelles) {
      t.Update();
    }
  }

  void Input() {
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
      if (abs(rotSpeed) < 0.0025) rotSpeed = 0;
    }

    if (!up && !down && !straftL && !straftR) {
      if (vel.mag() < .07) vel.setMag(0);
      if (vel.mag() < .3) vel.lerp(new PVector(), 0.01f);
    }

    if (tirer) Tirer();
  }

  void addBlock(int x, int y, Block b, boolean force) {
    b.x = x;
    b.y = y;
    b.parent = this;

    if (x >= 0 && x < allBlocks.length && y >= 0 && y < allBlocks[0].length) {
      if (allBlocks[x][y] == null) {
        if (force
          || allBlocks[x+1][y] != null || allBlocks[x-1][y] != null
          || allBlocks[x][y+1] != null || allBlocks[x][y-1] != null) {
          allBlocks[x][y] = b;
          if (formeVaisseau != null) formeVaisseau.UpdateForme(allBlocks);
        }
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

  boolean isMouseOnBlocks() {
    if (isMouseOnGrid()) {
      if (formeVaisseau.isPointInPolygon(mouseX, mouseY))
        return true;
    }
    return false;
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

  void Tirer() {
    for (Tourelle t : allTourelles) {
      t.Tirer();
    }
  }

  PVector getCoordBlockFromPoint(int px, int py) {
    PVector res = null;

    for (int x=0; x<allBlocks.length; x++) {
      for (int y=0; y<allBlocks[0].length; y++) {
        if (isPointInBlockMap(px, py, x, y, this)) {
          return new PVector(x, y);
        }
      }
    }

    return res;
  }




  //=======================FORME VAISSEAU




  class FormeVaisseau {
    ArrayList<PVector> forme;

    FormeVaisseau(Block[][] bs) {
      forme = new ArrayList<PVector>();
      UpdateForme(bs);
    }

    void UpdateForme(Block[][] blocks) {
      forme.clear();
      forme = Cherche(blocks);
    }

    ArrayList<PVector> Cherche(Block[][] blocks) {
      ArrayList<PVector> points = new ArrayList<PVector>();
      int direction = 0, // 0 : L  /  1 : U  /  2 : R  /  3 : B
        px = -1, py = -1, basePx = -2, basePy = -2;
      boolean fini = false;
      boolean changDir = false;


      while (!fini) {
        //Si on a pas de premier block, le trouver
        if (px == -1 && py == -1) {
          boolean br = false;

          for (int x=0; x<blocks.length; x++) {
            for (int y=0; y<blocks[0].length; y++) {
              if (blocks[x][y] != null) {
                px = x;
                py = y;
                basePx = x;
                basePy = y;
                points.add(new PVector(px, py));
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
            points.add(new PVector(px, py));
          } else changDir = true;
          break;
        case 1:
          if (blocks[px][py-1] != null && blocks[px-1][py-1] == null) {
            py--;
            points.add(new PVector(px, py));
          } else changDir = true;
          break;
        case 2:
          if (blocks[px-1][py] == null && blocks[px-1][py-1] != null) {
            px--;
            points.add(new PVector(px, py));
          } else changDir = true;
          break;
        case 3:
          if (blocks[px][py] == null && blocks[px-1][py] != null) {
            py++;
            points.add(new PVector(px, py));
          } else changDir = true;
          break;
        }

        if (changDir) {
          direction++;
          direction%=4;
        }

        if (px == basePx && py == basePy) fini = true;
      }

      //CLEAN
      for (int i=0; i<(points.size()-1); i++) {
        PVector v0 = points.get(i);
        PVector v1 = points.get(i+1);
        PVector v2 = points.get((i+2)%points.size());

        if (v0.x == v1.x && v1.x == v2.x
          || v0.y == v1.y && v1.y == v2.y) {
          points.remove(v1);
          i--;
        }
      }

      return points;
    }

    void Render() {
      for (PVector v : formeVaisseau.forme) {
        push();
        fill(255, 0, 0);
        noStroke();
        ellipse(v.x*Block.tailleBloc, v.y*Block.tailleBloc, 5, 5);
        pop();
      }
    }

    boolean isPointInPolygon(int px, int py) {
      boolean aLinterieur = false;
      int nbSommets = forme.size();
      ArrayList<PVector> forme2 = new ArrayList<PVector>();

      for (PVector v : forme) {
        PVector v2 = getBlockPosition(int(v.x), int(v.y));
        forme2.add(v2);
      }

      for (int i = 0; i<nbSommets; i++) {
        PVector v1 = forme2.get(i);
        PVector v2 = forme2.get((i+1)%nbSommets);

        //And magik occurs (merci internet sur ce coup là)
        if ((v1.y>py) != (v2.y>py) && px < (v2.x - v1.x) * (py - v1.y) / (v2.y - v1.y) + v1.x) {
          aLinterieur = !aLinterieur;
        }
      }

      return aLinterieur;
    }
  }
}
