ArrayList<Vaisseau> allVaisseaux;
Vaisseau focusedVaisseau;

void setup() {
  size(1000, 1000);

  allVaisseaux = new ArrayList<Vaisseau>();

  Vaisseau v = new Vaisseau();

  v.addBlock(5, 5, new Block());
  v.addBlock(6, 5, new Block());
  v.addBlock(7, 5, new Block());
  v.addBlock(8, 5, new Block());

  v.addBlock(5, 4, new Block());
  v.addBlock(6, 4, new Block());
  v.addBlock(7, 4, new Block());

  v.addBlock(20, 5, new Block());
  v.pos.set(500, 500);

  focusedVaisseau = v;
  allVaisseaux.add(v);
}

void draw() {
  background(0);

  for (int i=0; i<allVaisseaux.size(); i++) {
    Vaisseau v = allVaisseaux.get(i);

    v.displayGrid = v.isMouseOnGrid();

    v.Update();
    v.Render();
  }
}

void keyPressed() {
  if (key == 'z') focusedVaisseau.up = true;
  if (key == 's') focusedVaisseau.down = true;
  if (key == 'q') focusedVaisseau.left = true;
  if (key == 'd') focusedVaisseau.right = true;
}

void keyReleased() {
  if (key == 'z') focusedVaisseau.up = false;
  if (key == 's') focusedVaisseau.down = false;
  if (key == 'q') focusedVaisseau.left = false;
  if (key == 'd') focusedVaisseau.right = false;
}
