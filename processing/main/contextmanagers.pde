abstract class  AbstractSchemeManager<T extends AbstractScheme> {
	ArrayList<T> schemes;
	AbstractScheme currentScheme;
	int currentIndex;

	AbstractSchemeManager() {
		currentIndex = 0;
		schemes = new ArrayList<T>();
		currentScheme = null;
	}

	abstract void initialize();

	abstract void render();

	void transition(boolean isRight) {
		currentIndex += isRight ? 1 : -1;
		currentIndex = currentIndex % schemes.size();
		currentScheme = schemes.get(currentIndex);
		currentScheme.transition();
	}
}


class ColorSchemeManager extends AbstractSchemeManager<ColorScheme> {
	ColorSchemeManager() {
		super();

		schemes.add((new ColorScheme(color(255), color(50))));
		schemes.add((new ColorScheme(color(50), color(255))));
		currentScheme = schemes.get(currentIndex);
	}

	void initialize() {
		currentScheme.transition();
	}

	void render() {
		currentScheme.render();
	}
}

class KeySchemeManager extends AbstractManager {
	KeySchemeManager(Minim minim, KeyLayout layout) {
		super();
	}
}
