#include <unistd.h>
#include <stdio.h>
#include <signal.h>

int main(int argc,char* argv[]){
	int i=0;

	printf("--------USER PROGRAM--------\n");
	sleep(5);
//	alarm(2);
	raise(SIGABRT);
	printf("user process success!!\n");
	printf("--------USER PROGRAM--------\n");
	return 100;
}

