

class World{
  // Variables
  float[][] density;
  int precX, precY;
  float treshold = 0.5;
  float squareW, squareH;

  // Constructor
  World(int precX, int precY){
    this.precX = precX;
    this.precY = precY;

    density = new float[precX+1][precY+1];

    squareW = (float)width/precX;
    squareH = (float)height/precY;
  }

  // Update
  void generateRandomWorld(){
    for(int x = 0; x < precX+1; x++){
      for(int y = 0; y < precY+1; y++){
        density[x][y] = random(0, 1);
      }
    }
  }
  void generateNoiseWorld(float noiseScale){
    for(int x = 0; x < precX+1; x++){
      for(int y = 0; y < precY+1; y++){
        density[x][y] = noise(x*noiseScale, y*noiseScale);
      }
    }
  }
  void changeArea(float cx, float cy, float r, float diff){
    for(int x = 0; x < precX+1; x++){
      for(int y = 0; y < precY+1; y++){
        float dist = sqrt(sq(x*squareW - cx) + sq(y*squareH - cy));
        if(dist < r){
          density[x][y] += diff * (1-dist/r);
          density[x][y] = max(0, min(density[x][y], 1));
        }
      }
    }
  }

  // Display
  void drawEdge(PVector p1, PVector p2){
    line(p1.x, p1.y, p2.x, p2.y);
  }
  float calculateScale(float v1, float v2){
    float scale = 0.5;
    if(v1 != v2){ scale = map(0.5, v1, v2, 0, 1); }
    if(scale < -1 || 1 < scale){ scale = 0.5; }
    if(scale < 0){ scale += 1; }
    return scale;
  }
  void drawMarchingSquare(float x, float y, float w, float h, int tx, int ty){
    float rScale = calculateScale(density[tx+1][ty  ], density[tx+1][ty+1]);
    float tScale = calculateScale(density[tx  ][ty  ], density[tx+1][ty  ]);
    float lScale = calculateScale(density[tx  ][ty  ], density[tx  ][ty+1]);
    float bScale = calculateScale(density[tx  ][ty+1], density[tx+1][ty+1]);

    PVector r = new PVector(x + w       , y + h*rScale);
    PVector t = new PVector(x + w*tScale, y           );
    PVector l = new PVector(x           , y + h*lScale);
    PVector b = new PVector(x + w*bScale, y + h       );

    int type = 0;
    if(density[tx+1][ty  ] < treshold){ type += 1; }
    if(density[tx  ][ty  ] < treshold){ type += 2; }
    if(density[tx  ][ty+1] < treshold){ type += 4; }
    if(density[tx+1][ty+1] < treshold){ type += 8; }

    // 2 -- 1
    // |    |
    // 4 -- 8

    switch(type){
      case 0: break;
      case 1: drawEdge(t, r); break;
      case 2: drawEdge(t, l); break;
      case 3: drawEdge(r, l); break;
      case 4: drawEdge(l, b); break;
      case 5: drawEdge(l, b); drawEdge(t, r); break;
      case 6: drawEdge(t, b); break;
      case 7: drawEdge(b, r); break;
      case 8: drawEdge(b, r); break;
      case 9: drawEdge(t, b); break;
      case 10: drawEdge(l, b); drawEdge(t, r); break;
      case 11: drawEdge(l, b); break;
      case 12: drawEdge(l, r); break;
      case 13: drawEdge(t, l); break;
      case 14: drawEdge(t, r); break;
      case 15: break;
    }
  }
  void displaySurface(){
    for(int x = 0; x < precX; x++){
      for(int y = 0; y < precY; y++){
        drawMarchingSquare(x*squareW, y*squareH, squareW, squareH, x, y);
      }
    }
  }
  void displayNodes(){
    for(int x = 0; x < precX+1; x++){
      for(int y = 0; y < precY+1; y++){
        fill(map(density[x][y], 0, 1, 0, 255));
        //if(density[x][y] < treshold){ fill(255); }else{ fill(0); }
        ellipse(x * squareW, y * squareH, 10, 10);
      }
    }
  }
}

boolean mouseLDown = false, mouseRDown = false;
float mouseR = 100;
World world;

void setup(){
  size(500, 500);
  frameRate(60);

  world = new World(20, 20);
  world.generateNoiseWorld(0.05);
}

void draw(){
  if(mouseLDown){ world.changeArea(mouseX, mouseY, mouseR, -0.02); }
  if(mouseRDown){ world.changeArea(mouseX, mouseY, mouseR,  0.02); }

  background(200);

  //world.displayNodes();
  world.displaySurface();

  noFill();
  ellipse(mouseX, mouseY, 2*mouseR, 2*mouseR);
}

void mousePressed(){
  if(mouseButton == LEFT){ mouseLDown = true; }
  if(mouseButton == RIGHT){ mouseRDown = true; }
}
void mouseReleased(){
  if(mouseButton == LEFT){ mouseLDown = false; }
  if(mouseButton == RIGHT){ mouseRDown = false; }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  mouseR *= pow(1.2, e);
}
