ArrayList<Vaisseau> allVaisseaux;
Vaisseau focusedVaisseau;

void setup() {
  size(1000, 1000);
  smooth();

  allVaisseaux = new ArrayList<Vaisseau>();

  Vaisseau v = new Vaisseau();
  allVaisseaux.add(v);
  focusedVaisseau = v;

  v.addBlock(20, 5, new Block());
  v.pos.set(500, 500);
}

void draw() {
  background(0);
  push();
  stroke(255);
  strokeWeight(0.1);
  for (int x=0; x<width; x+=50) {
    line(x, 0, x, height);
  }
  for (int y=0; y<width; y+=50) {
    line(0, y, width, y);
  }
  pop();

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
  if (key == 'a') focusedVaisseau.straftL = true;
  if (key == 'e') focusedVaisseau.straftR = true;
}

void keyReleased() {
  if (key == 'z') focusedVaisseau.up = false;
  if (key == 's') focusedVaisseau.down = false;
  if (key == 'q') focusedVaisseau.left = false;
  if (key == 'd') focusedVaisseau.right = false;
  if (key == 'a') focusedVaisseau.straftL = false;
  if (key == 'e') focusedVaisseau.straftR = false;
}
