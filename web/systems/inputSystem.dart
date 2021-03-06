part of spacebook;

class InputSystem extends IntervalEntitySystem {
  static const int UP = 38; //arrow up
  static const int DOWN = 40; // arrow down
  static const int LEFT = 37; // arrow left
  static const int RIGHT = 39; // arrow right
  static const int SPACE = 32; // space
  static const int KEY_I = 73; // i


  bool moveUp = false;
  bool moveDown = false;

  bool moveLeft = false;
  num  lastLeft = -1;
  num leftBarrelRolls = 0;

  bool moveRight = false;

  bool fireLaser = false;
  bool zuckerbergIntensifies = false;

  ComponentMapper<Velocity> velocityMapper;
  ComponentMapper<PlayerLaser> laserMapper;
  ComponentMapper<Intensity> intensityMapper;
  ComponentMapper<Rotation> rotationMapper;
  TagManager tagManager;

  CanvasElement canvas;

  InputSystem(Screen screen) : super(20, Aspect.getAspectForAllOf([Velocity, PlayerLaser, Intensity])) {
    canvas = screen.canvas;
  }

  void initialize() {
    window.onKeyDown.listen(handleKeyDown);
    window.onKeyUp.listen(handleKeyUp);
    canvas.onMouseDown.listen(handleMouseDown);
    canvas.onMouseUp.listen(handleMouseUp);
  }

  void processEntities(Iterable<Entity> entities) {
    Entity player = tagManager.getEntity(TAG_PLAYER);
    Velocity velocity = velocityMapper.get(player);
    PlayerLaser laser = laserMapper.get(player);
    Rotation rotation = rotationMapper.get(player);

    Entity zuck = tagManager.getEntity(TAG_ZUCKER);
    Intensity i = intensityMapper.get(zuck);

    num moveSpeed = 200;

    if (moveUp) {
      velocity.y = -moveSpeed;
    } else if (moveDown) {
      velocity.y = moveSpeed;
    }
      else {
      velocity.y = 0;
    }
    if (moveLeft) {
      velocity.x = -moveSpeed;
    } else if(moveRight) {
      velocity.x = moveSpeed;
    } else {
      velocity.x = 0;
    }

    if (fireLaser) {
      laser.firing = true;
      fireLaser = false;
    }

    if (zuckerbergIntensifies) {
      i.i1 += 10;
      i.i2 += 38;
      zuckerbergIntensifies = false;
    }

    if (leftBarrelRolls > 0) {
      leftBarrelRolls -= world.delta;
      rotation.theta += 40;
      print("leftBarrelRolls: ${leftBarrelRolls}");
      print("rotation: ${rotation.theta}");
      if (rotation.theta >= 360) {
        rotation.theta = 0;
      }
    } else {
      rotation.theta = 0;
    }
  }

  void handleKeyDown(KeyboardEvent e) {
    int keyCode = e.keyCode;
    if (keyCode == UP) {
      moveUp = true;
    } else if (keyCode == DOWN) {
      moveDown = true;
    } else if (keyCode == LEFT) {
      moveLeft = true;
      if (lastLeft < 0) {
        lastLeft = new DateTime.now().millisecondsSinceEpoch;
      }
      num time = new DateTime.now().millisecondsSinceEpoch;
      if (time - lastLeft < 500) {
        print("leftBarrelRolls: ${leftBarrelRolls}");
        leftBarrelRolls = 600;
      }
      print("lastLeft: ${lastLeft}");
      print("time: ${time}");
      lastLeft = time;
    } else if (keyCode == RIGHT) {
      moveRight = true;
    } else if (keyCode == SPACE) {
      fireLaser = true;
    } else if (keyCode == KEY_I) {
      zuckerbergIntensifies = true;
    }
  }

  void handleKeyUp(KeyboardEvent e) {
    int keyCode = e.keyCode;
    if (keyCode == UP) {
      moveUp = false;
    } else if (keyCode == DOWN) {
      moveDown = false;
    } else if (keyCode == LEFT) {
      moveLeft = false;
    } else if (keyCode == RIGHT) {
      moveRight = false;
    }
  }

  void handleMouseDown(MouseEvent e) {
  }

  void handleMouseUp(MouseEvent e) {
  }
}

