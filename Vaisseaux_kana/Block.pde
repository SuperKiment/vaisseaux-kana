class Block {
  final static int tailleBloc = 40;
  Vaisseau parent;
  int x, y;
  boolean linked = false;

  Block() {
  }

  void Render() {
    rect(0, 0, tailleBloc, tailleBloc);
  }

  void Update() {
  }

  PVector getMapPosition() {
    if (parent != null) {
      PVector posCM = parent.pos.copy();
      posCM.add(new PVector(- parent.allBlocks.length * Block.tailleBloc / 2, - parent.allBlocks[0].length * Block.tailleBloc / 2));
      posCM.add(parent.centreMasse);
      PVector CMaCoin = PVector.sub(new PVector(x*Block.tailleBloc, y*Block.tailleBloc), parent.centreMasse);
      CMaCoin.rotate(parent.dir.heading());
      posCM.add(CMaCoin);
      return posCM;
    }

    return new PVector(0, 0);
  }
}

//==============================================================

class Tourelle {
  Block parent;
  float angle = 0, vitesseRot = .05;
  PVector dirCible, dir, cible;

  Tourelle(Block p) {
    parent = p;
    dirCible = new PVector();
    dir = new PVector(1, 0);
    cible = new PVector();
  }

  void Update() {
    dirCible.set(1, 0);
    dirCible.rotate(getSourisAngle());
    dir.lerp(dirCible, vitesseRot);

    if (parent.parent.isFocused) {
      cible.set(mouseX, mouseY);
    }
  }

  void Render() {
    push();
    translate(parent.x*Block.tailleBloc+Block.tailleBloc/2,
      parent.y*Block.tailleBloc+Block.tailleBloc/2);
    ellipse(0, 0,
      Block.tailleBloc/2,
      Block.tailleBloc/2);

    rotate(dir.heading()-parent.parent.dir.heading());
    push();
    rectMode(CENTER);
    rect(-Block.tailleBloc/2, 0,
      Block.tailleBloc,
      Block.tailleBloc/2);
    pop();
    pop();
  }

  float getSourisAngle() {
    PVector pos = parent.getMapPosition().copy();
    PVector dirV = new PVector(Block.tailleBloc/2, Block.tailleBloc/2);
    dirV.rotate(parent.parent.dir.heading());
    pos.add(dirV);
    PVector dest = PVector.sub(pos, cible);

    return dest.heading();
  }
}
