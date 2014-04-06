abstract class AbstractScheme {
	// abstract AbstractScheme();

	abstract void render();

	abstract void transition();
}



class ColorScheme extends AbstractScheme {
	color myBackground;
	color myFill;
	ArrayList<ISteppable> steppables;

	ColorScheme(color _background, color _fill) {
		myFill = _fill;
		myBackground = _background;
		steppables = new ArrayList<ISteppable>();
	}

	void render() {
		background(myBackground);

		for (ISteppable steppable : steppables) {
			steppable.step();
		}

		fill(myFill);
	}

	void addSteppable(ISteppable steppable) {
		steppables.add(steppable);
	}

	void transition() {
		fill(myFill);
		background(myBackground);

		for (ISteppable steppable : steppables) {
			steppable.initialize();
		}
	}

}


class KeyLayout {
	int rows;
	int columns;
	int screenWidth;
	int screenHeight;
	int spacing;

	KeyLayout(int _rows, int _columns, int _screenWidth,
	          int _screenHeight, int _spacing) {
		rows = _rows;
		columns = _columns;
		screenWidth = _screenWidth;
		screenHeight = _screenHeight;
		spacing = _spacing;
	}
}

class KeyScheme extends AbstractScheme {
	ArrayList<Key> keys;

	KeyScheme(String basePath, KeyLayout layout, Minim minim) {
		File baseDir = new File(basePath);
		String lastFile;
		println("opened the base dir");
		println("base: ", baseDir);
		println("files: ", baseDir.listFiles());
		ArrayDeque<File> files = new ArrayDeque<File>();

		for (File fileEntry : baseDir.listFiles()) {
			println("file: ", fileEntry);
			if(fileEntry.isFile()) {
				files.add(fileEntry);
			}
		}

		lastFile = files.peek().getAbsolutePath();
		println("files: ", files);
		keys = new ArrayList<Key>();

		int step = layout.screenWidth / layout.columns;
		int middleY = screenHeight / 2;

		for (int row = 0; row < layout.rows; row++) {
			for (int column = 0; column < layout.columns; column++) {
				int x = column * step + spacing/2;
				int y = middleY + (row - 1) * step;
				String newFile;
				try {
					newFile = files.removeFirst().getAbsolutePath();
					lastFile = newFile;
				} catch (NullPointerException e) {
					newFile = lastFile;
				}
				println("new file: ", newFile);
				Key toAdd = new Key(
					x, y, step - spacing,
					newFile,
					minim);
				keys.add(toAdd);
				println("Added");
			}
		}
	}

	void initialize(){
		render();
	}

	void render() {
		for (Key key : keys) {
			key.draw();
		}
	}

	void transition() {
		render();
	}

	void checkToPlay(PVector position, LoopManager loopManager) {
		for (Key key : keys) {
			if(key.isTouching(position)) {
				println("Got a hit! About to play...");
				key.play();
				loopManager.set(key);
			}
		}
	}
}


class LazyKeyScheme extends KeyScheme {
	LazyKeyScheme(String basePath, KeyLayout layout, Minim minim) {
		super(basePath, layout, minim);
		// basePath = _basePath;
		// layout = _layout;
		// minim = _minim;
		// isInitialized = false;
	}

	void close() {
		for (Key key : keys) {
			key.stop();
			key.note.close();
		}
	}
}
