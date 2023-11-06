class Block {
  final static int tailleBloc = 20;
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

  boolean isPointInBlockMap() {
    PVector hg = getMapPosition();
    PVector hd = hg.copy();
    PVector bg = hg.copy();
    PVector bd = hg.copy();

    PVector offset = new PVector(tailleBloc, 0);
    offset.rotate(parent.dir.heading());
    hd.add(offset);
    
    offset.set(0, tailleBloc);
    offset.rotate(parent.dir.heading());
    bg.add(offset);
    
    offset.set(tailleBloc, tailleBloc);
    offset.rotate(parent.dir.heading());
    bd.add(offset);
    
    rect(hg.x, hg.y, 10, 10);
    rect(bd.x, bd.y, 10, 10);
    
    return false;
  }
}





//==============================================================






class Tourelle {
  Block parent;
  float angle = 0, vitesseRot = .05,
    baseCooldown = 400, cooldown, timer,
    randomness = 1.5;
  PVector dirCible, dir, cible;
  PVector pos;

  Tourelle(Block p) {
    parent = p;
    dirCible = new PVector();
    dir = new PVector(1, 0);
    cible = new PVector();
  }

  void Update() {
    pos = parent.getMapPosition().copy();
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
    rect(Block.tailleBloc/2, 0,
      Block.tailleBloc,
      Block.tailleBloc/2);
    pop();
    pop();
  }

  float getSourisAngle() {
    PVector dirV = new PVector(Block.tailleBloc/2, Block.tailleBloc/2);
    dirV.rotate(parent.parent.dir.heading());
    pos.add(dirV);
    PVector dest = PVector.sub(pos, cible);

    return dest.heading()+PI;
  }

  void Tirer() {
    if (millis()-timer > cooldown) {
      cooldown = random(baseCooldown/randomness, baseCooldown*randomness);
      timer = millis();
      allProjectiles.add(new Projectile(pos, dir));
    }
  }
}



//===================================PROJECTILE




class Projectile {
  PVector pos, dir;
  float speed = 8, accel = 1, timeToDeath = 1000, timer;
  boolean mort = false;

  Projectile(PVector p, PVector d) {
    pos = p.copy();
    dir = d.copy();
    dir.setMag(speed);
    timer = millis();
  }

  void Update() {
    dir.setMag(dir.mag()*accel);
    pos.add(dir);

    if (millis() - timer > timeToDeath) {
      mort = true;
      //Explosion
    }
  }

  void Render() {
    push();
    translate(pos.x, pos.y);
    fill(255, 0, 0);
    noStroke();
    ellipse(0, 0, Block.tailleBloc/3, Block.tailleBloc/3);
    pop();
  }
}
