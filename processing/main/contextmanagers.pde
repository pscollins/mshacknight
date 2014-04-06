abstract class  AbstractSchemeManager<T extends AbstractScheme> {
	ArrayList<T> schemes;
	T currentScheme;
	int currentIndex;

	AbstractSchemeManager() {
		currentIndex = 0;
		schemes = new ArrayList<T>();
		currentScheme = null;
	}

	void initialize() {
		currentScheme.transition();
	}


	void render() {
		currentScheme.render();
	}

	void transition(boolean isRight) {
		currentIndex += isRight ? 1 : -1;
		currentIndex = Math.abs(currentIndex % schemes.size());
		println("new index: ", currentIndex);
		currentScheme = schemes.get(currentIndex);
		currentScheme.transition();
	}
}


class ColorSchemeManager extends AbstractSchemeManager<ColorScheme> {
	ColorSchemeManager(int pageWidth) {
		super();
		println("init color scheme");

		color blue = color(51, 204, 255);
		color grey = color(50, 50, 50, 150);

		// WINDOWS 8 COLOR SCHEME

		color taupe = color(135, 121, 78);
		color red = color(229, 20, 0);
		color green = color(0, 138, 0);
		color magenta = color(216, 0, 115);
		color steel = color(100, 118, 135);
		color cobalt = color(0, 80, 239);

		color semiSteel = color(100, 118, 135, 150);
		color semiWhite = color(255, 255, 255, 200);

		schemes.add((new ColorScheme(cobalt, semiWhite)));
		schemes.add((new ColorScheme(red,
		                             semiWhite)));

		SineWave toAdd = new SineWave(pageWidth);
		for (ColorScheme scheme : schemes) {
			scheme.addSteppable(toAdd);
		}

		currentScheme = schemes.get(currentIndex);
	}
}

class KeySchemeManager extends AbstractSchemeManager<KeyScheme> {

	KeySchemeManager(Minim minim, KeyLayout layout) {
		super();
		println("init key scheme manager");

		schemes.add(
			(new KeyScheme(
				"/home/patrick/hacking/web/mshacknight/processing/main/audio-1/",
				layout, minim)));
		println("got the first scheme done");
		schemes.add((new KeyScheme("/home/patrick/hacking/web/mshacknight/processing/main/audio-2", layout, minim)));


		// schemes.add((new KeyScheme("/home/patrick/hacking/web/mshacknight/processing/main/audio-3", layout, minim)));

		println("got #2");
		println("schemes: ", schemes);
		currentScheme = schemes.get(currentIndex);
		println("set current scheme: ", currentScheme);
	}

	void checkToPlay(PVector position, LoopManager loopManager) {
		currentScheme.checkToPlay(position, loopManager);
	}

}


class LazyKeySchemeManager extends AbstractSchemeManager<LazyKeyScheme> {
	String[] paths = {
		"/home/patrick/hacking/web/mshacknight/processing/main/audio-1/",
		"/home/patrick/hacking/web/mshacknight/processing/main/audio-2/"};
	// 	"/home/patrick/hacking/web/mshacknight/processing/main/audio-3"
	// };

	Minim minim;
	KeyLayout layout;


	LazyKeySchemeManager(Minim _minim, KeyLayout _layout) {
		super();
		println("init lazy key scheme manager");

		layout = _layout;
		minim = _minim;

		initScheme(0);

		// schemes.add(
		// 	(new KeyScheme(
		// 		paths[0].get(),
		// 		layout,
		// 		minim)));

		println("set current scheme: ", currentScheme);
	}

	private void initScheme(int scheme) {
		currentScheme =
			(new LazyKeyScheme(
				paths[scheme],
				layout,
				minim));
		currentScheme.initialize();
	}


	void transition(boolean isRight) {
		currentIndex += isRight ? 1 : -1;
		currentIndex = Math.abs(currentIndex % paths.length);

		LazyKeyScheme oldScheme = currentScheme;

		oldScheme.close();

		println("new index: ", currentIndex);
		// currentScheme = schemes.get(currentIndex);
		initScheme(currentIndex);
		currentScheme.transition();
	}


	void checkToPlay(PVector position, LoopManager loopManager) {
		currentScheme.checkToPlay(position, loopManager);
	}

}
