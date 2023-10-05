#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <signal.h>

int main(int argc, char *argv[]){

    pid_t pid, wpid;
    int status = 0;

    /* Check if the program name is provided */
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <path_to_program>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    
    printf("I am the parent process and my pid is %d\n", getpid());

    /* fork a child process */
    pid = fork();

    if (pid == 0) {
        printf("I am the child process and my pid is %d\n", getpid());
        /* This block will be executed by the child process */
        /* execute the given program */
        execl(argv[1], argv[1], (char *)NULL);

        /* If execl() fails */
        perror("execl");
        exit(EXIT_FAILURE);
    } else if (pid < 0) {
        /* Fork failed */
        perror("fork");
        exit(EXIT_FAILURE);
    } else {
        /* This block will be executed by the parent */

        /* wait for child process terminates */
        wpid = waitpid(pid, &status, WUNTRACED);

        /* check child process' termination status */
        if (WIFEXITED(status)) {
            printf("Child exited with status %d\n", WEXITSTATUS(status));
        } else if (WIFSIGNALED(status)) {
            printf("Parent process receives SIGCHLD signal\nchild process get ");
            switch (WIFSIGNALED(status))
            {
            case 6:
                printf("SIGABRT");
                break;
            case 14:
                printf("SIGALRM");
                break;
            case 7:
                printf("SIGBUS");
                break;
            case 8:
                printf("SIGFPE");
                break;
            case 1:
                printf("SIGHUP");
                break;
            case 4:
                printf("SIGILL");
                break;
            case 2:
                printf("SIGINT");
                break;
            case 9:
                printf("SIGKILL");
                break;
            case 13:
                printf("SIGPIPE");
                break;
            case 3:
                printf("SIGQUIT");
                break;
            case 11:
                printf("SIGSEGV");
                break;
            case 15:
                printf("SIGTERM");
                break;
            case 5:
                printf("SIGTRAP");
                break;
            default:
                break;
            }
            printf(" signal\n");
        }
        else if(WIFSTOPPED(status)){
            printf("Parent process receives SIGCHLD signal\nchild process get SIGSTOP signal\n");
        }
    }

    return 0;
}
