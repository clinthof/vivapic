/* Definition and declarations */
%{
    #include <stdio.h>
    #include <stdlib.h>

    #include "vivapic.h"

    setup();
    int yylex();
    int yyerror(const char* s);

    int pointBounds(int x, int y);
    int vectorBounds(int x, int y, int u, int v);
    int circleBounds(int x, int y, int r);
    int blockBounds(int x, int y, int w, int h);

    int color_change_int(int r, int g, int b);
    float color_change_fl(int r, int g, int b);


%}

%define parse.error verbose

%start point
%start vector
%start circle
%start block

%union{
  int iVal;
  float fVal;
}

%type<iVal> INT
%type<fVal> FLOAT

%token END
%token END_STATEMENT

%token POINT
%token VECTOR
%token CIRCLE
%token BLOCK

%token COLOR_CHANGE

/* Grammar rules */
%%
program:        statement_list END END_STATEMENT;

statement_list: statement
              | statement statement_list;

statement:      point
              | vector
              | circle
              | block
              | color_change
              | error { yyerrok; yyclearin; printf(" Not a valid command.
              Please try again.\n"; }
              ;

  // FINISH CFGs

  point: POINT INT INT END_STATEMENT
  { if (bounds($2, $3) == 0) {
    point($2, $3); }
  }

  vector: VECTOR INT INT INT INT END_STATEMENT
  { if (vectorBounds($2, $3, $4, $5) == 0) {
    vector($2, $3, $4, $5); }
  }

  circle: CIRCLE INT INT INT END_STATEMENT
  { if (circleBounds($2, $3, $4)) {
    circle($2, $3, $4); }
  }

  block: BLOCK INT INT INT INT END_STATEMENT
  { if (blockBounds($2, $3, $4, $5)) {
    block($2, $3, $4, $5); }
  }

  color_change: COLOR_CHANGE INT INT INT END_STATEMENT
  {
  }


%%

/* C functions */
int main (int argc, char** argv) {
  yyparse();
  return 0;
}

void yyerror (char *s) {
  fprintf (stderr, "%s\n", s);
}

int bounds (int x, int y) {
  if (x > WIDTH || y > HEIGHT || x < 0 || y < 0) {
    yyerror("Invalid x and/or y value(s): Surpasses
    screen limit or negative value(s) detected.\n");
    return 1;
  }
  return 0;
}

int vectorBounds (int x, int y, int u, int v) {
  if (x > WIDTH || y > HEIGHT ||
    u > WIDTH || v > HEIGHT) {
    yyerror("Vector point(s) off-screen.
    Please try again.\n");
    return 1;
  }
  return 0;
}

int circleBounds (int x, int y, int r) {

  int d = r * 2; // diameter = 2 * circle's radius

  if (x > WIDTH || y > HEIGHT) {
    yyerror("Circle is off-screen. Try again.\n");
    return 1;
  } else if (x < 0 || y < 0) {
    yyerror("x and/or y is/are negative.\n");
    return 1;
    } else { return 0; }
}

int blockBounds (int x, int y, int w, int h) {
  if ((x+w) > WIDTH || (y+h) > HEIGHT) {
    yyerror("Rectangle is off-screen.
    Please try again.\n");
    return 1;
  } else if (x < 0 || y < 0 || w < 0 || h < 0){
    yyerror("x, y, height, or width value(s)
    is/are negative.  Please try again.\n");
    return 1;
    } else { return 0; }
}

int color_change_int (int r, int g, int b) {
  if (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255 ||) {
    yyerror("RGB values should be above 0 and below 255. Please
    check your values and try again.\n");
    return 1;
  } else { return 0; }
}

float color_change_fl (int r, int g, int b) {
  if (r < 0.0 || r > 255.0 || g < 0.0 || g > 255.0 || b < 0.0 || b > 255.0 ||) {
    yyerror("RGB values should be above 0 and below 255. Please
    check your values and try again.\n");
    return 1;
  } else { return 0; }
}
