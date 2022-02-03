import java.util.Iterator;

static final boolean CLOSE_BOUNDARY = true;
static final boolean LOCALITY = true;

static final int SIZE = 20;
static final float LIGHT_SPEED = SIZE * 2;

ArrayList<Node> myDudes = new ArrayList<Node>();
ArrayList<Event> schededEvents = new ArrayList<Event>();

class Node {
  PVector pos;
  float phase = 0;

  float dist(Node other) {
    float d = pos.dist(other.pos);
    if (CLOSE_BOUNDARY) {
      d = min(d, other.pos.dist(new PVector(pos.x + SIZE, pos.y + SIZE)));
      d = min(d, other.pos.dist(new PVector(pos.x + SIZE, pos.y       )));
      d = min(d, other.pos.dist(new PVector(pos.x + SIZE, pos.y - SIZE)));
      d = min(d, other.pos.dist(new PVector(pos.x       , pos.y + SIZE)));
      d = min(d, other.pos.dist(new PVector(pos.x       , pos.y       )));
      d = min(d, other.pos.dist(new PVector(pos.x       , pos.y - SIZE)));
      d = min(d, other.pos.dist(new PVector(pos.x - SIZE, pos.y + SIZE)));
      d = min(d, other.pos.dist(new PVector(pos.x - SIZE, pos.y       )));
      d = min(d, other.pos.dist(new PVector(pos.x - SIZE, pos.y - SIZE)));
    }
    return d;
  }
  
  void seeLight(Node other) {
    float intensity = 1f / sq(dist(other));
    phase += intensity * phase * .025;
  }

  void loop(int dt) {
    phase += dt * .0007;
    if (phase >= 1) {
      phase = 0;
      blink();
    }
  }

  void blink() {
    for (Node node : myDudes) {
      if (this == node) continue;
      float d = dist(node);
      if (d >= SIZE / 2) continue;
      float when = millis();
      if (LOCALITY) {
        when += d * 1000 / LIGHT_SPEED;
      }
      schedule(node, this, when);
    }
  }
}

class Event {
  Node seer;
  Node blinker;
  float when;
  Event(Node seer, Node blinker, float when) {
    this.seer = seer;
    this.blinker = blinker;
    this.when = when;
  }
}

void schedule(Node seer, Node blinker, float when) {
  schededEvents.add(new Event(seer, blinker, when));
}

int last_millis = 0;
void loop() {
  int dt = millis() - last_millis;
  last_millis += dt;
  for (Node node : myDudes) {
    node.loop(dt);
  }
  Iterator<Event> itr = schededEvents.iterator();
  while (itr.hasNext()) {
    Event e = itr.next();
    if (e.when <= millis()) {
      e.seer.seeLight(e.blinker);
      itr.remove();
    }
  }
}

void setup() {
  size(1600, 1600);
  noStroke();
  ellipseMode(CORNER);
  for (int i = 0; i < SIZE; i ++) {
    for (int j = 0; j < SIZE; j ++) {
      Node node = new Node();
      myDudes.add(node);
      node.pos = new PVector(i, j);
    }
  }
  randomize();
}

void draw() {
  loop();
  background(0);
  float w = width  / SIZE;
  float h = height / SIZE;
  for (Node node : myDudes) {
    int luminos = round(sq(1f - node.phase) * 255);
    fill(luminos, luminos, 0);
    ellipse(
      node.pos.x * w, node.pos.y * h, 
      w, h
    );
  }
}

void mousePressed() {
  randomize();
}

void randomize() {
  for (Node x : myDudes) {
    x.phase = random(1);
  }
}
