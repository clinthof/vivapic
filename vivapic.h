#ifndef			__VIVAPIC__
#define			__VIVAPIC__

#include <SDL2/SDL.h>

#define			HEIGHT	384
#define			OLDHEIGHT	768
#define			WIDTH	512
#define			OLDWIDTH	1024

struct color{
	int r;
	int g;
	int b;
};

SDL_Texture* texture;
SDL_Renderer* renderer;
SDL_Window* window;

void setup();
void color_change( int r, int g, int b);
void point( int x, int y );
void vector( int x1, int y1, int x2, int y2 );
void circle( int x, int y, int r);
void block( int x, int y, int w, int h);
void finish();
void sdl_ellipse(SDL_Renderer* r, int x0, int y0, int radiusX, int radiusY);
 
#endif
