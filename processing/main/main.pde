import ddf.minim.*;
import de.voidplus.leapmotion.*;
import java.util.*;

int screenWidth = 1000;
int screenHeight = 500;
int numButtons = 5;
int numRows = 2;
int spacing = 40;
LeapMotion leap;
ColorSchemeManager colorManager;
LoopManager loopManager;
// KeySchemeManager keyManager;
LazyKeySchemeManager keyManager;

class Key {
	int x;
 	int y;
	int width;
	int height;
	AudioPlayer note;
	// LoopingPlayer note;
	boolean isLooping;

	Key(int _x, int _y, int _width, String path, Minim minim){
		println("init key for ", path);
		println("with minim ", minim);
		x = _x;
		y = _y;
		width = _width;
		height = _width;
		note = minim.loadFile(path);
		// note = new LoopingPlayer(path);
		isLooping = false;
	}

	void draw() {
		rect(x, y, width, height);
	}


	void play() {
		if(!isLooping) {
			note.play();
			note.rewind();
		}
	}


	void loop() {
		println("looping!");
		note.loop();
		note.rewind();
		isLooping = true;
	}


	void stop() {
		note.pause();
		note.rewind();
		isLooping = false;
	}

	boolean isTouching(PVector touch) {
//		println("Checking for touch at:", touch.x, touch.y);
//		println("My coords:", x, y, "width: ", width);

		return ((touch.x >= x && touch.x <= x + width) &&
		        (touch.y >= y && touch.y <= y + height));
	}

}



class VolumeManager {
	ArrayList<Key> keys;
}

class LoopManager {
	Key lastClicked;
	Stack<Key> loopingKeys;

	LoopManager() {
		lastClicked = null;
		loopingKeys = new Stack<Key>();
	}

	void set(Key key) {
		println("setting last clicked to ", key);
		lastClicked = key;
	}

	void start() {
		println("starting");
		println("last clicked: ", lastClicked);
		if(lastClicked != null &&
		   loopingKeys.indexOf(lastClicked) == -1) {
			loopingKeys.push(lastClicked);
			lastClicked.loop();
		}
	}

	void stopLast() {
		if(loopingKeys.size() > 0) {
			Key toStop = loopingKeys.pop();
			toStop.stop();
		}
	}

	void printDiagnostics() {
		println("printing diagnostics");
		println("stack size: ", loopingKeys.size());
	}
}

void setup() {
	size(screenWidth, screenHeight, P3D);
	colorManager = new ColorSchemeManager();
	colorManager.initialize();

	KeyLayout layout = new KeyLayout(numRows,
	                                 numButtons,
	                                 screenWidth,
	                                 screenHeight,
	                                 spacing);
	Minim minim = new Minim(this);

	keyManager = new LazyKeySchemeManager(minim, layout);
	keyManager.initialize();
	println("about to init leap");
	leap = new LeapMotion(this).withGestures();
	println("about to init loop manager");
	loopManager = new LoopManager();



	// int step = screenWidth / numButtons;
	// int middleY = screenHeight / 2 - step;


	// for (int row = 0; row < numRows; row++) {
	// 	for (int x = spacing / 2; x < screenWidth; x += step) {
	// 		Key toAdd = new Key(x, middleY, step - spacing, "./piano-1.mp3", minim);
	// 		keys.add(toAdd);
	// 		println("Added");
	// 	}
	// 	middleY += step;
	// }
}

void drawFingers() {
	// HANDS
	for(Hand hand : leap.getHands()){

		hand.draw();
		int     hand_id          = hand.getId();
		PVector hand_position    = hand.getPosition();
		PVector hand_stabilized  = hand.getStabilizedPosition();
		PVector hand_direction   = hand.getDirection();
		PVector hand_dynamics    = hand.getDynamics();
		float   hand_roll        = hand.getRoll();
		float   hand_pitch       = hand.getPitch();
		float   hand_yaw         = hand.getYaw();
		float   hand_time        = hand.getTimeVisible();
		PVector sphere_position  = hand.getSpherePosition();
		float   sphere_radius    = hand.getSphereRadius();

		// FINGERS
		for(Finger finger : hand.getFingers()){

			// Basics
			finger.draw();
			int     finger_id         = finger.getId();
			PVector finger_position   = finger.getPosition();
			PVector finger_stabilized = finger.getStabilizedPosition();
			PVector finger_velocity   = finger.getVelocity();
			PVector finger_direction  = finger.getDirection();
			float   finger_time       = finger.getTimeVisible();

			// Touch Emulation
			int     touch_zone        = finger.getTouchZone();
			float   touch_distance    = finger.getTouchDistance();

			switch(touch_zone){
			case -1: // None
				break;
			case 0: // Hovering
				// println("Hovering (#"+finger_id+"): "+touch_distance);
				break;
			case 1: // Touching
				// println("Touching (#"+finger_id+")");
				break;
			}
		}
	}
}

void draw() {
	colorManager.render();
	keyManager.render();
	drawFingers();
}

void mousePressed(){
	PVector position = new PVector(mouseX, mouseY);
	keyManager.checkToPlay(position, loopManager);
}


// If you draw the circle clockwise, the normal vector points in the
// same general direction as the pointable object drawing the
// circle. If you draw the circle counterclockwise, the normal points
// back toward the pointable. If the angle between the normal and the
// pointable object drawing the circle is less than 90 degrees, then
// the circle is clockwise. (from the javascript documentation)

// if (circle.pointable.direction.angleTo(circle.normal) <= PI/4) {
//      clockwiseness = "clockwise";
// }

void leapOnCircleGesture(CircleGesture g, int state) {
	println("got circle gesture");
	loopManager.printDiagnostics();

	switch(state) {
	case 1:
	case 3:
		if(isClockwise(g)) {
			loopManager.start();
		} else {
			loopManager.stopLast();
		}

	default:
		break;
	}
}

// http://stackoverflow.com/questions/2150050/finding-signed-angle-between-vectors
double getVectorAngle(PVector a, PVector b) {
	double angle = Math.atan2(a.y - b.y, a.x - b.x);
	return angle;
}

boolean isClockwise(CircleGesture g) {
	PVector normal = g.getNormal();
	PVector direction = g.getFinger().getDirection();
	double angle = getVectorAngle(normal, direction);
	boolean isClockwise = Math.abs(angle) > Math.PI/4;

	println("angle between finger and circle: ", angle);
	println("is clockwise? ", isClockwise);

	return isClockwise;
}



void leapOnKeyTapGesture(KeyTapGesture g){
	int       id               = g.getId();
	Finger    finger           = g.getFinger();
	PVector   position         = g.getPosition();
	PVector   direction        = g.getDirection();
	long      duration         = g.getDuration();
	float     duration_seconds = g.getDurationInSeconds();

	println("ScreenTapGesture: "+id);
	keyManager.checkToPlay(position, loopManager);
}

void leapOnSwipeGesture(SwipeGesture g, int state) {
	int       id               = g.getId();
	Finger    finger           = g.getFinger();
	PVector   position         = g.getPosition();
	PVector   position_start   = g.getStartPosition();
	PVector   direction        = g.getDirection();
	float     speed            = g.getSpeed();
	long      duration         = g.getDuration();
	float     duration_seconds = g.getDurationInSeconds();

	println("Swipe detected! Direction is: ", direction);

	switch(state) {
	case 3: // Transition on the end of the swipe

		boolean isRight = direction.x > 500;
		println("isRight? ", isRight);
		colorManager.transition(isRight);
		keyManager.transition(isRight);
	default:
		break;
	}


}
