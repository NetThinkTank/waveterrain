// modified from http://www.openprocessing.org/sketch/6770

int width = null;
int height = null;

void setup() {
	width = window.innerWidth;
	height = window.innerHeight;

	if (width >= 740) {
		width = 640;
		height = 480;
	} else {
		width = 320;
		height = 200;
	}

	size(width, height);
	colorMode(HSB, 256);

	background(0);
	smooth();
}


int getY(int x, int periods, float amplitude) {
	float angle = TWO_PI * x / width;
	float y = ( sin(angle * periods) ) * amplitude;

	y = map(y, -1, 1, height - 1, 0);
	int yInt = floor(y);

	if (yInt < 0) {
		// console.log("yInt < 0");
		yInt = 0;
	}

	if (yInt > height - 1) {
		// console.log("yInt > height - 1");
		yInt = height - 1; 
	}

	return yInt;
}


int pixelID(int x, int y) {
	return width * y + x;
}



void stripePaint(int x, int y, color topColor, color bottomColor) {
	for (int i = y; i >=0; i--) {
		pixels[pixelID(x, i)] = topColor;
	}

	for (int i = y + 1; i < height; i++) {
		pixels[pixelID(x, i)] = bottomColor;
	}
}


void stripeModify(int x, int y, int topModifier, int bottomModifier) {
	for (int i = y; i >= 0; i--) {
		try {
			color c = pixels[pixelID(x, i)];
		} catch (Exception e) {
			console.log("STRIPE MODIFY TOP: ERROR GETTING COLOR");
		}

		int h = int(hue(c));
		int s = 255;
		int b = 255;

		if ( (h + topModifier <= 255) && (h + topModifier >= 0) ) {
			h = h + topModifier;
		} else {
			h = h - topModifier;
		}

		try {
			pixels[pixelID(x, i)] = color(h, s, b);
		} catch (Exception e) {
			console.log("STRIPE MODIFY TOP: ERROR SETTING COLOR");
		}
	}

	for (int i = y + 1; i < height; i++) {
		try {
			color c = pixels[pixelID(x, i)];
		} catch (Exception e) {
			console.log("STRIPE MODIFY BOTTOM: ERROR GETTING COLOR");
		}

		int h = int(hue(c));
		int s = 255;
		int b = 255;

		if ( (h + bottomModifier <= 255) && (h + bottomModifier >= 0) ) {
			h = h + bottomModifier;
		} else {
			h = h - bottomModifier;
		}

		try {
			pixels[pixelID(x, i)] = color(h, s, b);
		} catch (Exception e) {
			console.log("STRIPE MODIFY BOTTOM: ERROR SETTING COLOR");
		}
	}
}


void decoratePaint(int periods, float amplitude, color topColor, color bottomColor) {
	for (int x = 0; x < width; x++) {
		int y = getY(x, periods, amplitude);
		stripePaint(x, y, topColor, bottomColor);
	}

	updatePixels();
}


void decorateModify(int periods, float amplitude, int topModifier, int bottomModifier) {
	for (int x = 0; x < width; x++) {
		int y = getY(x, periods, amplitude);
		stripeModify(x, y, topModifier, bottomModifier);
	}

	updatePixels();
}


void draw() {
	int iterations = int(random(3, 5));

	color initialColorTop = color( int(random(0, 255)), 255, 255 );
	color initialColorBottom = color( int(random(0, 255)), 255, 255 );
	// color initialColorBottom = initialColorTop;
	// color initialColorBottom = color( ((hue(initialColorTop) + 128) % 256), 255, 255);

	int[] inverse = [-1, 1];

	loadPixels();

	decoratePaint(int(random(1, 5)), random(0, 1), initialColorTop, initialColorBottom);

	for (int i = 1; i <= iterations; i++) {
		int periods = int(random(1, 5));    
		float amplitude = random(0, 1);

		int topModifier = int(random(5, 9)) * inverse[int(random(0, 2))];
		int bottomModifier = int(random(5, 9)) * inverse[int(random(0, 2))];

		decorateModify(periods, amplitude, topModifier, bottomModifier);
	}

	noLoop();
}
