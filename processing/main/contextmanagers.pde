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
		currentIndex = currentIndex % schemes.size();
		println("new index: ", currentIndex);
		currentScheme = schemes.get(currentIndex);
		currentScheme.transition();
	}
}


class ColorSchemeManager extends AbstractSchemeManager<ColorScheme> {
	ColorSchemeManager() {
		super();
		println("init color scheme");

		schemes.add((new ColorScheme(color(255), color(50))));
		schemes.add((new ColorScheme(color(50), color(255))));
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
		"/home/patrick/hacking/web/mshacknight/processing/main/audio-2"};
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

		println("got #2");
		println("schemes: ", schemes);
		currentScheme = schemes.get(currentIndex);
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
		currentIndex = currentIndex % schemes.size();

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
