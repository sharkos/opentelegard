#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <curses.h>
#include <term.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

/*
 * For the terminal info
 */
static char term_buffer[8192];

/*
 * For the capabilities
 */
char    *setfore = NULL, 
	*setback = NULL,  
	*resetcolor = NULL, 
	*standstr = NULL, 
	*exit_stand = NULL,
	*inicolor_str = NULL, 
	*clrnames  = NULL,
	*bold = NULL,    
	*dim = NULL,
	*reverse = NULL,
	*blinking = NULL,
	*exit_attr = NULL, 
	*opair = NULL;
      
int      maxcolors = 0,
	maxpairs  = 0,
	do_force_16  = 0;





/******************
 * Initialize the terminal info
 */
void init_terminal_data ()
{
  char *termtype = getenv ("TERM");
  int success;

  if (termtype == 0) {
    fprintf(stderr,"Specify a terminal type with `setenv TERM <yourtype>'.\n");
    exit(1);
  }

  success = tgetent (term_buffer, termtype);
  if (success < 0) {
    fprintf(stderr,"Could not access the termcap data base.\n");
    exit(1);
  }
  if (success == 0) {
    fprintf(stderr,"Terminal type `%s' is not defined.\n", termtype);
    exit(1);
  }
}

/*******************
 * Print a band with background of all available colors
 */
void colormap( int do_boldstand ) 
{
	int back;
	for( back = 0; back < maxcolors; back++ ) {
		char *strB;
		strB = strdup(tparm(setback,back));
		printf("%s        %s",strB,resetcolor);
		if( back%8 == 7 )
			printf("\n");
	}
	if (do_boldstand) {
		for( back = 0; back < maxcolors; back++ ) {
			char *strB;
			strB = strdup(tparm(setfore,back));
			printf("%s%s%s        %s%s%s",bold,standstr,strB,resetcolor,
			       exit_stand,exit_attr);
			if( back%8 == 7 )
				printf("\n");
		}
	}
	for ( back = 0; back < maxcolors; back++ ) {
		char *strB;
		strB = strdup(tparm(setfore,back));
		printf("%sXXXXXXXX%s",strB,resetcolor);
		if( back%8 == 7 )
			printf("\n");
	}
	if ( bold ) {
		for ( back = 0; back < maxcolors; back++ ) {
			char *strB;
			strB = strdup(tparm(setfore,back));
			printf("%s%sXXXXXXXX%s%s",bold,strB,resetcolor,exit_attr);
			if( back%8 == 7 )
				printf("\n");
		}
	}
}


/*********************
 * Print a table with all the fore and background 
 * color combinations, with bold and optionally standout
 */
void combinations_of_colors(int do_standout, int do_boldstand) 
{
	int fore, back;
	for( fore = 0; fore < maxcolors; fore ++ ) 
		for( back = 0; back < maxcolors; back ++ ) {
			char *strF, *strB;
			char *sstrF, *sstrB;
			strB = strdup(tparm(setback,back));
			strF = strdup(tparm(setfore,fore));
			printf( "%s%s%s [%3d|%3d]%s%s", "",strF,strB,fore,back,resetcolor,"");
			/* Bold */
			printf( "%s%s%sB[%3d|%3d]%s%s", bold,strF,strB,fore,back,resetcolor,exit_attr);
			/* Standout usually does not work good... do only if asked for */
			/* Since standout usually reverses, we'll reverse the fore and back too */
			sstrB = strdup(tparm(setback,fore));
			sstrF = strdup(tparm(setfore,back));
			if (do_standout)
				printf( "%s%s%sS[%3d|%3d]%s%s",standstr,sstrF,sstrB,fore,back,resetcolor,exit_stand);
			if (do_boldstand)
				printf( "%s%s%s%sS[%3d|%3d]%s%s%s",bold,standstr,sstrF,sstrB,fore,back,resetcolor,exit_stand,exit_attr);
			printf( "\n" );
		}
	printf( "\n" );
	  
}


/** Query and assign a capability 
 */
void capability(char**buf,char*code,char**var,char*message)
{
	char *val = tgetstr(code,buf);
	if ( ! val ) {
		*var=NULL;
		printf("%s\n",message);
	} else {
		*var=strdup(val);
	}
}


/****************************
 * Retrieve the capabilities
 */
void get_capabilities()
{
	char buffer[2500]="", *buf=buffer;

	/*
	 * Get the capabilities
	 */
	maxcolors = tgetnum("Co");
	if ( maxcolors <= 0 ) {
		printf("I am sorry, your terminal does not show color in the capabilities\n");
	}
	maxpairs = tgetnum("pa");
	if (maxpairs <= 0 ) {
		printf("I am sorry, your terminal does not have the max color pairs information\n");
	}
	
	capability(&buf,"AF",&setfore,
		   "I am sorry, your terminal does not have the set foreground color string in the capabilities");
	capability(&buf,"AB",&setback,
		   "I am sorry, your terminal does not have the set background color string in the capabilities");
	capability(&buf,"op",&resetcolor,
		   "I am sorry, your terminal does not have the reset current color string in the capabilities");
	capability(&buf,"md",&bold,
		   "I am sorry, your terminal does not have the bold string in the capabilities");
	capability(&buf,"mh",&dim,
		   "I am sorry, your terminal does not have the dim string in the capabilities");
	capability(&buf,"mr",&reverse,
		   "I am sorry, your terminal does not have the reverse string in the capabilities");
	capability(&buf,"mb",&blinking,
		   "I am sorry, your terminal does not have the blinking string in the capabilities");
	capability(&buf,"so",&standstr,
		   "I am sorry, your terminal does not have the standout string in the capabilities");
	capability(&buf,"se",&exit_stand,
		   "I am sorry, your terminal does not have the exit standout string in the capabilities");
	capability(&buf,"me",&exit_attr,
		   "I am sorry, your terminal does not have the exit attribute string in the capabilities");
	capability(&buf,"Ic",&inicolor_str,
		   "I am sorry, your terminal does not have the init color string in the capabilities");
	capability(&buf,"Yw",&clrnames,
		"I am sorry, your terminal does not have the color names string in the capabilities");
	capability(&buf,"op",&opair,
		"I am sorry, your terminal does not have the original pairs string in the capabilities");
}


/********************
 * Query the RGB map
 */
void query_rgb()
{
	int i, fd=fileno(stdin);
	long mode;
	struct termios ts;
	
	if ( ! isatty(fd) || ! isatty(fileno(stdout)) ) 
		printf("Sorry, but stdin and/or stdout is not the terminal tty so I cannot query it\n");
	else {
		if ( ! inicolor_str ) 
			printf("According to your terminal info this terminal rgb query will hang. Press ^C to abort the query.\n");

		/* 
		 * We need to do the equivalent of cbreak()
		 */
		tcgetattr(fd,&ts);
		mode=ts.c_lflag; /* Save mode so we can restore afterwards */
		ts.c_lflag &= ~(ECHO|ECHONL|ICANON|ISIG|IEXTEN);
		tcsetattr(fd, TCSANOW,&ts);
		ts.c_lflag = mode;

		/* Ask for the colors */
		for ( i = 0 ; 1 ; i ++ ) {
			char buffer[1000], 
				*buf=buffer, 
				*end=buffer+sizeof(buffer)-1;
			int interrupted = 0;
			
			/* This is a string retrieved from Noah
			 * Friedmans xterm-frobs.el. I could not find
			 * any termcap entry that verifies it 
			 */
			printf("\e]4;%d;?;\e\\",i);
			fflush(stdout);
			memset(buffer,0,sizeof(buffer));
			while( buf!=end ) {
				fd_set fdsr, fdse,fdsw;
				int fds;
				struct timeval t;
				
				t.tv_sec = 0;
				t.tv_usec = 100000; /* 100ms */

				FD_ZERO(&fdsr);
				FD_ZERO(&fdse);
				FD_ZERO(&fdsw);
				FD_SET(fd, &fdsr);
				FD_SET(fd, &fdse);
				fds = select(fd+1,&fdsr,&fdsw,&fdse,&t);
				if ( fds < 1) {
					tcsetattr(fd, TCSANOW,&ts);
					return;
				}
				if ( ! FD_ISSET(fd, &fdsr) ) {
					tcsetattr(fd, TCSANOW,&ts);
					return;
				}
				read(fd,buf,1);
				if ( *buf == '\\') {
					/* The response sequence ends with the only "\" 
					   of the response
					*/
					break;
				}
				if ( *buf == '' ) {
					/* 
					   If the terminal did not reply, chances are 
					   this is not supported and the user used ^C
					*/
					interrupted=1;
					break;
				}
				*buf++;
			}
			if (interrupted)
				break;

			/* Extract the rgb values */
			buf=strstr(buffer,"rgb:");
			if( buf ) {
				buf+=4;
				char *end = strstr(buf,"\e\\");
				if(end)
					  *end='\0';
			} else {
				buf="Did not find info";
			}
			printf("Color %d: %s\n",i,buf);
			fflush(stdout);
		}

		/* Restore terminal settings */
		tcsetattr(fd, TCSANOW,&ts);
	}
}


/**************
 * Fake the capabilities the ansi terminal info
 * would return
 */
void force_ansi()
{
	if ( ! (maxcolors > 0) ) {
		maxcolors = 8;
		printf("WARNING: Forcing ANSI testing, 8 colors\n");
	}
	if ( maxcolors == 8 && do_force_16 ) {
		maxcolors = 16;
		printf("WARNING: Forcing 16 color testing\n");
	}
	if ( ! setfore ) {
		setfore="\e[3%p1%dm";
		printf("WARNING: Forcing ANSI set foreground: ^[%s\n", setfore+1);
	}
	if ( ! setback ) {
		setback="\e[4%p1%dm";
		printf("WARNING: Forcing ANSI set background: ^[%s\n", setback+1);
	}
	if ( ! resetcolor ) {
		resetcolor="\e[39;49m";
		printf("WARNING: Forcing ANSI reset colour  : ^[%s\n", resetcolor+1);
	}
}



int
main( int argc, char *argv[] )
{
  int     do_colormap = 0, 
	  do_combinations = 0, 
	  do_standout = 0, 
	  do_boldstand = 0,
	  do_query = 0;

  { /* Process arguments */
	  int i;
	  
	  for( i = 1; i < argc; i++ ) {
		  if( ! strcmp(argv[i],"-m") )
			  do_colormap = 1;
		  if( ! strcmp(argv[i],"-c") )
			  do_combinations=1;
		  if ( ! strcmp(argv[i], "-f" ) )
			  do_force_16 = 1;
		  if( ! strcmp(argv[i],"-s") )
			  do_standout=1;
		  if( ! strcmp(argv[i],"-bs") )
			  do_boldstand=1;
		  if( ! strcmp(argv[i],"-q") )
			  do_query=1;
	  }
  }

  init_terminal_data();

  get_capabilities();

  /*
   * Report the capabilities
   */
  printf("\n\nTerminal: %s\n",getenv("TERM"));
  if ( maxcolors > 0 )
    printf("You've got %d colours\n",maxcolors);
  if ( maxpairs > 0 )
    printf("You've got %d pairs of colors possible\n",maxpairs);

  if ( setfore )    printf("To set foreground: ^[%s\n", setfore+1);
  if ( setback )    printf("To set background: ^[%s\n", setback+1);
  if ( resetcolor ) printf("To reset colours : ^[%s\n", resetcolor+1);
  if ( standstr )   printf("To standout      : ^[%s\n", standstr+1);
  if ( bold )       printf("To bold          : ^[%s\n", bold+1);
  if ( dim )        printf("To dim           : ^[%s\n", dim+1);
  if ( reverse )    printf("To reverse       : ^[%s\n", reverse+1);
  if ( blinking )   printf("To blinking      : ^[%s\n", blinking+1);
  if ( exit_stand ) printf("To exit standout : ^[%s\n", exit_stand+1);
  if ( exit_attr )  printf("To exit attribute: ^[%s\n", exit_attr+1);
  if ( inicolor_str ) printf("To init color    : ^[%s\n", inicolor_str+1);
  if ( clrnames )   printf("To color names   : ^[%s\n", clrnames+1);
  if ( opair )      printf("To original pairs: ^[%s\n",   opair+1);
  
  

  /*
   * Let's try the ANSI defaults
   */
  if ( do_colormap || do_combinations ) {
	  force_ansi();
  }

  if ( do_query ) {
	  printf("\nQuery the RGB from the terminal:\n");
	  query_rgb();
  }

  if ( do_colormap ) {
	  printf("\nColormap:\n");
	  colormap( do_boldstand );
  }

  if ( do_combinations ) {
	  printf("\nColor combinations:\n");
	  combinations_of_colors( do_standout,
				  do_boldstand);
  }

  return 0;
}
