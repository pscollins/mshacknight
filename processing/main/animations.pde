interface ISteppable {
	void initialize();
	void step();
}


class SineWave implements ISteppable {
	int xspacing = 16;   // How far apart should each horizontal location be spaced
	int w;              // Width of entire wave

	float theta = 0.0;  // Start angle at 0
	float amplitude = 200.0;  // Height of wave
	float period = 500.0;  // How many pixels before the wave repeats
	float dx;  // Value for incrementing X, a function of period and xspacing
	float[] yvalues;  // Using an array to store height values for the wave

	SineWave(int pageWidth) {
		w = width+16;
		dx = ((float)Math.PI * 2 / period) * xspacing;
		yvalues = new float[w/xspacing];
	}

	void initialize() {
		step();
	}

	void step() {
		calcWave();
		renderWave();
	}

	void calcWave() {
		// Increment theta (try different values for 'angular velocity' here
		theta += 0.02;

		// For every x value, calculate a y value with sine function
		float x = theta;
		for (int i = 0; i < yvalues.length; i++) {
			yvalues[i] = sin(x)*amplitude - 20;
			x+=dx;
		}
	}

	void renderWave() {
		noStroke();
		fill(255);
		// A simple way to draw the wave with an ellipse at each location
		for (int x = 0; x < yvalues.length; x++) {
			ellipse(x*xspacing, height/2+yvalues[x], 16, 16);
		}
	}
}
