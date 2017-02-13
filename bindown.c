#include <stdio.h>

bool is_code_line(char bs[]){
	if((bs[0] == bs[1] == bs[2] == bs[3] == ' ')
				|| bs[0] == 9){
		return (true);			
	}
	return(false);
}



int main(int argc, char *argv[]){
	if(argc != 2){
		printf("Usage: bindown filename\n");
		return(0);
	}
	FILE *f = fopen(argv[1], "r");
	char bigstring[2048];
	while(! feof(f)){
		fgets(bigstring, 2048, f);
		if(is_code_line(bigstring)){

		}
	}
	return(0);
}



