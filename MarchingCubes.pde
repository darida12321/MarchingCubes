


InputManager inputManager;
BallManager ballManager;

void setup(){
  size(800, 800);
  //fullScreen();
  frameRate(60);

  inputManager = new InputManager(1);
  ballManager = new BallManager(20, 100);
}

void draw(){
  ballManager.update(false);
  //inputManager.update();

  //println(frameRate);
}
