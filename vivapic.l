%{
    #include <stdio.h>
    #include "vivapic.tab.h"
%}

%option noyywrap

%%

end                     {return EXIT_COMMAND;}
[[:space:]]+             ;
[-]?[0-9]+              {yylval.iVal = atoi(yytext); return INT;}
[-]?[0-9]*(\.)?[0-9]+   {yylval.fVal = atof(yytext); return FLOAT;}
;                       {return END_STATEMENT;}
point                   {return POINT;}
vector                  {return VECTOR;}
circle                  {return CIRCLE;}
block                   {return BLOCK;}
color_change            {return COLOR_CHANGE;}
[.]+                    {printf("\nNot a command.\n");}

%%

