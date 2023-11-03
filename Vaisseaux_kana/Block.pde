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

    PVector posCM = parent.pos.copy();
    posCM.add(new PVector(- parent.allBlocks.length * Block.tailleBloc / 2, - parent.allBlocks[0].length * Block.tailleBloc / 2));
    posCM.add(parent.centreMasse);
    PVector CMaCoin = PVector.sub(new PVector(x*Block.tailleBloc, y*Block.tailleBloc), parent.centreMasse);
    CMaCoin.rotate(parent.dir.heading());
    posCM.add(CMaCoin);

    return posCM;
  }
}



class Tourelle {
  Block parent;
  PVector pos;

  Tourelle(Block p) {
    parent = p;
    pos = p.getMapPosition();
  }

  void Update() {
  }

  void Render() {
  }
}
