Block[][] allBlocks;
FormeVaisseau forme;

void setup() {
  size(1000, 1000);
  allBlocks = new Block[10][10];

  allBlocks[5][6] = new Block();
  allBlocks[6][6] = new Block();
  allBlocks[7][6] = new Block();
  allBlocks[5][7] = new Block();
  allBlocks[5][5] = new Block();
  allBlocks[4][5] = new Block();
  allBlocks[3][5] = new Block();
  allBlocks[3][4] = new Block();
  allBlocks[5][4] = new Block();

  forme = new FormeVaisseau(allBlocks);
}

void draw() {
  background(0);
  translate(100, 100);
  fill(255);

  for (int x=0; x<allBlocks.length; x++) {
    for (int y=0; y<allBlocks[0].length; y++) {
      push();
      translate(x*Block.tailleBloc, y*Block.tailleBloc);
      if (allBlocks[x][y] != null)
        allBlocks[x][y].Render();
      pop();
    }
  }
  
  if (!forme.fini) forme.Cherche(allBlocks);
  forme.Render();
}
