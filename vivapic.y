/*****************************************************************************
Name: Felix Clinthorne
Class: CIS 343
Date: October 26th, 2020
A Bison program emulating MS Paint that allows a user to enter various
commands to create shapes and vectors, forming simple drawings. Complete with
color manipulation.
*****************************************************************************/

/* Section 1: Definitions and declarations */
%{
    #include <stdio.h>
    #include <stdlib.h>

    #include "vivapic.h"

    int yylex();
    void yyerror(const char* s);

    int pointBounds(int x, int y);
    int vectorBounds(int x, int y, int u, int v);
    int circleBounds(int x, int y, int r);
    int blockBounds(int x, int y, int w, int h);

    int colorCheck(int r, int g, int b);

%}

%define parse.error verbose

%start statement_list

%union{
  int iVal;
  float fVal;
}

%token END_STATEMENT
%token EXIT_COMMAND

%token POINT
%token VECTOR
%token CIRCLE
%token BLOCK

%token COLOR_CHANGE

%token INT
%token FLOAT

%type<iVal> INT
%type<fVal> FLOAT

/* Section 2: Grammar rules */
%%

statement_list: statement
              | statement statement_list;

statement:      point
              | vector
              | circle
              | block
              | color_change
              | exit_command
              | error { yyerrok; yyclearin; printf("\nNot a valid command. Please try again.\n"); }
              ;

  point: POINT INT INT END_STATEMENT
  { if (pointBounds($2, $3) == 0) {
    point($2, $3); }
  }
  ;

  vector: VECTOR INT INT INT INT END_STATEMENT
  { if (vectorBounds($2, $3, $4, $5) == 0) {
    vector($2, $3, $4, $5); }
  }
  ;

  circle: CIRCLE INT INT INT END_STATEMENT
  { if (circleBounds($2, $3, $4) == 0) {
    circle($2, $3, $4); }
  }
  ;

  block: BLOCK INT INT INT INT END_STATEMENT
  { if (blockBounds($2, $3, $4, $5) == 0) {
    block($2, $3, $4, $5); }
  }
  ;

  color_change: COLOR_CHANGE INT INT INT END_STATEMENT
  { if (colorCheck($2, $3, $4) == 0) {
    color_change($2, $3, $4); }
  }
  ;

  exit_command: EXIT_COMMAND END_STATEMENT { exit(EXIT_SUCCESS); }
  ;

%%

/* Section 3: C functions */
int main (int argc, char** argv) {
  setup();
  yyparse();
  finish();
  return 0;
}

void yyerror (const char *s) {
  fprintf (stderr, "%s\n", s);
}

int pointBounds (int x, int y) {
  if (x > WIDTH || y > HEIGHT || x < 0 || y < 0) {
    yyerror("Invalid x and/or y value(s): Surpasses screen limit or negative value(s) detected.");
    return 1;
  }
  return 0;
}

int vectorBounds (int x, int y, int u, int v) {
  if (x > 1000 || y > 2000 ||
    u > 1000 || v > 2000) {
    yyerror("Vector point(s) off-screen. Please try again.\n");
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
    yyerror("Rectangle is off-screen. Please try again.\n");
    return 1;
  } else if (x < 0 || y < 0 || w < 0 || h < 0){
    yyerror("x, y, height, or width value(s) is/are negative.  Please try again.\n");
    return 1;
    } else { return 0; }
}

int colorCheck (int r, int g, int b) {
  if (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255) {
    yyerror("RGB values should be above 0 and below 255. Please check your values and try again.\n");
    return 1;
  } else { return 0; }
}
