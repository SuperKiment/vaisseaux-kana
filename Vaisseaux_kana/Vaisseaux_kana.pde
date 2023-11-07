ArrayList<Vaisseau> allVaisseaux;
ArrayList<Projectile> allProjectiles;
Vaisseau focusedVaisseau;

void setup() {
  size(1000, 1000);
  smooth();

  allVaisseaux = new ArrayList<Vaisseau>();
  allProjectiles = new ArrayList<Projectile>();

  Vaisseau v = new Vaisseau();
  allVaisseaux.add(v);
  v.pos.set(500, 500);

  Vaisseau v2 = new Vaisseau();
  allVaisseaux.add(v2);
  v2.pos.set(200, 500);

  ChangerVaisseau(v);
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

  //Vaisseaux
  focusedVaisseau.displayGrid = focusedVaisseau.isMouseOnGrid();
  for (int i=0; i<allVaisseaux.size(); i++) {
    Vaisseau v = allVaisseaux.get(i);
    v.Update();
    v.Render();
  }

  //Projectiles
  for (int i=0; i<allProjectiles.size(); i++) {
    Projectile p = allProjectiles.get(i);
    p.Update();
    p.Render();

    if (p.mort) allProjectiles.remove(i);
  }

  text(mouseX, mouseX, mouseY+30);
  text(mouseY, mouseX, mouseY+40);
}



void mousePressed() {
  for (Vaisseau v : allVaisseaux) {
    float tailleDiag = sqrt(
      pow(v.allBlocks.length * Block.tailleBloc / 2, 2)
      + pow(v.allBlocks[0].length * Block.tailleBloc / 2, 2)
      );

    if (dist(mouseX, mouseY, v.pos.x, v.pos.y) < tailleDiag) {
      //Changer vaisseau
      if (v.formeVaisseau.isPointInPolygon(mouseX, mouseY)) {
        ChangerVaisseau(v);
      } else {
        //Si on change de vaisseau, ne pas placer de block
        if (v.isMouseOnGrid()) {
          PVector coordBlockInVaisseau = v.getCoordBlockFromPoint(mouseX, mouseY);
          //Ajouter un block
          if (v.ID.equals(focusedVaisseau.ID)) v.addBlock(int(coordBlockInVaisseau.x), int(coordBlockInVaisseau.y), new Block(), false);
        }
      }
    }
  }

  focusedVaisseau.tirer = true;
}



void mouseReleased() {
  focusedVaisseau.tirer = false;
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



void ChangerVaisseau(Vaisseau v) {
  if (focusedVaisseau == null) {
    focusedVaisseau = v;
  }
  focusedVaisseau.displayGrid = false;
  focusedVaisseau.isFocused = false;
  focusedVaisseau = v;
  focusedVaisseau.isFocused = true;
}
