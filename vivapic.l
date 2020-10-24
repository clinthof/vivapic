%{
    #include <stdio.h>
    #include <stdlib.h>

    #include "vivapic.h"
%}

%option noyywrap

%%

[[:space:]]+       ;
[0-9]*\.[0-9]+    {yylval.fVal = atof(yytext); return FLOAT;}
[0-9]+            {yylval.iVal = atoi(yytext); return INT;}
^end              {return END;}
[;]               {return END_STATEMENT;}
^point            {return POINT;}
^vector           {return VECTOR;}
^circle           {return CIRCLE;}
^block            {return BLOCK;}
^color_change     {return COLOR_CHANGE;}

%%
