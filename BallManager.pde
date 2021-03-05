class Ball{
  PVector pos;
  PVector vel;
  float r;

  Ball(){
    r = random(width/50, width/10);
    float x = random(r, width-r);
    float y = random(r, height-r);
    pos = new PVector(x, y);

    float angle = random(2*PI);
    float speed = random(width/1000, width/500);
    vel = new PVector(cos(angle) * speed, sin(angle) * speed);
  }

  void update(){
    pos.add(vel);
    if(width  < pos.x+r && 0 < vel.x){ vel.x *= -1; }
    if(height < pos.y+r && 0 < vel.y){ vel.y *= -1; }
    if(pos.x-r < 0 && vel.x < 0){ vel.x *= -1; }
    if(pos.y-r < 0 && vel.y < 0){ vel.y *= -1; }
  }

  void display(){
    ellipse(pos.x, pos.y, r*2, r*2);
  }
}

class BallManager{
  ArrayList<Ball> balls;
  MarchingSquare marchingSquare;

  BallManager(int n, int scale){
    balls = new ArrayList<Ball>();
    for(int i = 0; i < n; i++){
      balls.add(new Ball());
    }

    marchingSquare = new MarchingSquare(scale);
  }

  float getSumDist(float x, float y){
    float sum = 0;
    for(Ball ball : balls){
      float bx = ball.pos.x;
      float by = ball.pos.y;
      sum += sq(ball.r) / (sq(bx-x) + sq(by-y));
    }
    sum /= 2;
    return sum;
  }

  void update(boolean resize){
    for(Ball ball : balls){
      ball.update();
    }

    if(resize){
      int mx = max(1, min(mouseX, width));
      marchingSquare.resize(mx/8, mx/8);
    }

    marchingSquare.generateBallWorld(this);

    display();
  }

  void display(){
    stroke(256, 128, 0); strokeWeight(1);
    background(0);
    fill(256, 128, 0);
    marchingSquare.displaySurface();
    //marchingSquare.displayArea();
  }
}
