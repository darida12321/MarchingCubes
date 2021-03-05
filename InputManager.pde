class InputManager{
  boolean mouseLDown = false;
  boolean mouseRDown = false;
  float mouseR = 100;
  MarchingSquare marchingSquare;

  InputManager(int w, int h){
    marchingSquare = new MarchingSquare(w, h);
    marchingSquare.generateNoiseWorld(5/(float)w);
  }
  InputManager(int size){
    marchingSquare = new MarchingSquare(size, size);
    marchingSquare.generateNoiseWorld(5/(float)size);
  }

  void update(){
    if(mouseLDown){ marchingSquare.changeAreaSmooth(mouseX, mouseY, mouseR, -0.02); }
    if(mouseRDown){ marchingSquare.changeAreaSmooth(mouseX, mouseY, mouseR,  0.02); }

    background(0);

    stroke(255, 128, 0); strokeWeight(2);
    fill(255, 128, 0);
    marchingSquare.displayArea();
    //marchingSquare.displayNodes();

    noFill();
    stroke(255); strokeWeight(1);
    ellipse(mouseX, mouseY, 2*mouseR, 2*mouseR);
  }
}

void mousePressed(){
  if(mouseButton == LEFT){ inputManager.mouseLDown = true; }
  if(mouseButton == RIGHT){ inputManager.mouseRDown = true; }
}
void mouseReleased(){
  if(mouseButton == LEFT){ inputManager.mouseLDown = false; }
  if(mouseButton == RIGHT){ inputManager.mouseRDown = false; }
}
void mouseWheel(MouseEvent e) {
  inputManager.mouseR *= pow(1.2, e.getCount());
}
