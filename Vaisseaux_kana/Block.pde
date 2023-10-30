class Block {
  final static int tailleBloc = 20;
  Vaisseau parent;

  Block() {
  }

  void Render() {

    rect(0, 0, tailleBloc, tailleBloc);
  }

  void Update() {
  }

  PVector getMapPosition(Vaisseau vaisseau, int posX, int posY) {
    
    PVector position = new PVector(-vaisseau.allBlocks.length * Block.tailleBloc/2, -vaisseau.allBlocks[0].length * Block.tailleBloc/2);

    
    rect(position.x, position.y, 10, 10);

    return position;
  }
}
