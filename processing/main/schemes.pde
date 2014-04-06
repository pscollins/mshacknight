abstract class AbstractScheme {
	// abstract AbstractScheme();

	abstract void render();

	abstract void transition();
}



class ColorScheme extends AbstractScheme {
	color myBackground;
	color myFill;

	ColorScheme(color _background, color _fill) {
		myFill = _fill;
		myBackground = _background;
	}

	void render() {
		background(myBackground);
	}

	void transition() {
		fill(myFill);
		background(myBackground);
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
		File[] files = baseDir.listOfFiles();

		int step = layout.screenWidth / layout.columns;
		int middleY = screenHeight / 2;

		for (int row = 0; row < layout.rows; row++) {
			for (int column = 0; column < layout.columns; column++) {
				int x = column * step;
				int y = middleY + (row - 1) * step;
				Key toAdd = new Key(
					x, y, step - spacing,
					files[row*layout.columns + column].getName());
				println("Added");
			}
		}
	}


	void render() {
		for (Key key : keys) {
			key.draw();
		}
	}


	void transition() {
		render();
	}
}
