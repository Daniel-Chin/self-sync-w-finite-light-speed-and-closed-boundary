import java.util.Iterator;

// static final boolean LOCALITY = false;
static final boolean LOCALITY = true;

static final int SIZE = 500;
// static final float LIGHT_SPEED = 10;
static final float LIGHT_SPEED = 5.655;
// static final float LIGHT_SPEED = 1.885;
static final float TORUS_BIG_R = .9;
static final float TORUS_SMALL_R = .3;
static final float SCALE = 1000;
static final float CAM_RADIUS = 3;
static final float CIRCLE_SIZE = .14;
static final boolean RING = false;

Sphere sphere;
Torus torus;
ArrayList<Event> schededEvents = new ArrayList<Event>();
PVector camera_pos = new PVector(0, - CAM_RADIUS, 0);
// boolean spread_stage = true;

class Node {
  Sphere parent;
  PVector pos;
  float phase = 0;
  PVector center_cache;
  float rad_cache;

  float dist(Node that) {
    return pos.dist(that.pos);
  }
  
  void seeLight(Node that) {
    float intensity = 1f / sq(dist(that));
    phase += intensity * phase * .0005;
  }

  void loop(int dt) {
    phase += dt * .0007;
    if (phase >= 1) {
      phase = 0;
      blink();
    }
  }

  void blink() {
    for (Node node : parent.myDudes) {
      if (this == node) continue;
      float d = dist(node);
      if (d >= 1) continue;
      float when = millis();
      if (LOCALITY) {
        when += d * 1000 / LIGHT_SPEED;
      }
      schedule(node, this, when);
    }
  }

  static final float DT = .00001;
  void spread() {
    PVector acc = new PVector(0, 0, 0);
    for (Node that : parent.myDudes) {
      PVector a = this.pos.copy();
      a.sub(that.pos);
      float distance = a.mag();
      a.normalize();
      a.mult(1 / sq(distance));
      if (Float.isNaN(a.x) || Float.isNaN(a.y) || Float.isNaN(a.z)) continue;
      acc.add(a);
    }
    acc.mult(DT);
    pos.add(acc);
    parent.applyConstraint(this);
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

class Sphere {
  ArrayList<Node> myDudes = new ArrayList<Node>();

  void samplePoints() {
    myDudes.clear();
    for (int i = 0; i < SIZE; i ++) {
      Node node = new Node();
      node.parent = this;
      node.pos = new PVector().random3D();
      node.phase = random(1);
      // node.phase = atan(node.pos.z / node.pos.x) / (2*PI);
      // if (node.pos.x < 0) node.phase += .5;
      myDudes.add(node);
    }
  }

  float hue(Node node) {
    float h = atan(node.pos.z / node.pos.x);
    if (node.pos.x < 0) {
      h += PI;
    }
    return h / (2 * PI) + .25;
  }

  float saturation(PVector pos) {
    return 1f - pow(abs(pos.y), 4);
  }

  void draw() {
    for (Node node : myDudes) {
      fill(
        hue(node),
        saturation(node.pos),
        1, 
        (pow(1f - node.phase, 8) + pow(node.phase, 8))
      );
      pushMatrix();
        translate(node.pos.x, node.pos.y, node.pos.z);
        orient(node);
        ellipse(0, 0, CIRCLE_SIZE, CIRCLE_SIZE);
      popMatrix();
    }
  }
  
  void orient(Node node) {
    rotateY(atan(node.pos.x / node.pos.z));
    if (node.pos.z < 0) {
      rotateY(PI);
    }
    rotateX(-atan(node.pos.y / sqrt(
      sq(node.pos.x) + sq(node.pos.z)
    )));
  }

  void loop(int dt) {
    for (Node node : myDudes) {
      node.spread();
    }
    for (Node node : myDudes) {
      node.loop(dt);
    }
  }

  void applyConstraint(Node x) {
    x.pos.normalize();
  }
}

class Torus extends Sphere {
  void samplePoints() {
    myDudes.clear();
    for (int i = 0; i < SIZE; i ++) {
      Node node = new Node();
      node.parent = this;
      float big = random(2 * PI);
      float small = random(2 * PI);
      float r = TORUS_BIG_R + cos(small) * TORUS_SMALL_R;
      float h = sin(small) * TORUS_SMALL_R;
      node.pos = new PVector(
        cos(big) * r, 
        h,
        sin(big) * r
      );
      node.phase = random(1);
      if (random(1) < .2) {
        // node.phase = big / (2 * PI);
        // node.phase = (big / (2 * PI) * 3) % 1;
        // node.phase = small / (2 * PI);
      }
      myDudes.add(node);
    }
  }

  void applyConstraint(Node node) {
    node.pos.mult(.998);
    float rad = atan(node.pos.z / node.pos.x);
    if (node.pos.x < 0) {
      rad += PI;
    }
    node.center_cache = new PVector(cos(rad), 0, sin(rad)).mult(TORUS_BIG_R);
    if (RING) {
      node.pos.x = node.center_cache.x * 1.5;
      node.pos.z = node.center_cache.z * 1.5;
      node.pos.y = constrain(node.pos.y, -.5, .5);;
      return;
    }
    node.pos = node.center_cache.copy().add(node.pos.sub(
      node.center_cache
    ).normalize().mult(TORUS_SMALL_R));
  }

  float hue(Node node) {
    PVector small_vec = node.pos.copy().sub(
      node.center_cache
    ).normalize();
    PVector base = node.center_cache.copy().normalize();
    float c = small_vec.copy().dot(base);
    node.rad_cache = atan(node.pos.y / TORUS_SMALL_R / c);
    if (c < 0) {
      node.rad_cache += PI;
    }
    return node.rad_cache / (2 * PI) + .25;
  }

  float saturation(PVector pos) {
    return 1;
    // return 1f - pow(abs(pos.y) / TORUS_SMALL_R, 4);
  }

  void orient(Node node) {
    rotateY(atan(node.pos.x / node.pos.z));
    if (node.pos.z < 0) {
      rotateY(PI);
    }
    if (! RING) {
      rotateX(-node.rad_cache);
    }
  }
}

void setup() {
  fullScreen(P3D);
  colorMode(HSB, 1, 1, 1, 1);
  sphere = new Sphere();
  torus  = new Torus ();
}

void mousePressed() {
  sphere.samplePoints();
  torus.samplePoints();
}

void draw() {
  loop();
  // camera_pos = new PVector(
  //   cos(-10f * mouseX / width) * CAM_RADIUS, 
  //   sin(-10f * mouseX / width) * CAM_RADIUS, 
  //   0
  // );
  camera(
    camera_pos.x * SCALE, 
    camera_pos.y * SCALE, 
    camera_pos.z * SCALE, 
    0, 0, 0, 
    0, 0, 1
  );
  background(0);
  scale(SCALE);
  if (sphere.myDudes.size() == 0) {
    fill(1);
    stroke(1);
    pushMatrix();
    translate(-1, 0, 0);
    rotateX(PI / 2);
    scale(.01);
    textSize(36);
    text("Click!", 0, 0, 0);
    popMatrix();
  }
  // strokeWeight(.0005);
  noStroke();
  // pushMatrix();
  //   translate(1.3, 0, 0);
  //   rotateZ(millis() * .0002);
  //   sphere.draw();
  // popMatrix();
  pushMatrix();
    // translate(-1.1, 0, 0);
    rotateZ((millis() - 6000) * .0002);
    torus.draw();
  popMatrix();
}

void schedule(Node seer, Node blinker, float when) {
  schededEvents.add(new Event(seer, blinker, when));
}

int last_millis = 0;
void loop() {
  int dt = millis() - last_millis;
  last_millis += dt;
  sphere.loop(dt);
  torus.loop(dt);
  Iterator<Event> itr = schededEvents.iterator();
  while (itr.hasNext()) {
    Event e = itr.next();
    if (e.when <= millis()) {
      e.seer.seeLight(e.blinker);
      itr.remove();
    }
  }
}
