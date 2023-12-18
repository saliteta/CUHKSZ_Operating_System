#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <curses.h>
#include <termios.h>
#include <fcntl.h>
#include <pthread.h>


#define ROW 11
#define COLUMN 50 
#define LOG_LENGTH 15
#define SPEED 1
#define NUMBER_OF_LOGS 9

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t frog_cond = PTHREAD_COND_INITIALIZER;
pthread_cond_t log_cond = PTHREAD_COND_INITIALIZER;
pthread_cond_t main_cond = PTHREAD_COND_INITIALIZER;

int FROG_UPDATE_READY = 0;
int LOG_UPDATE_READY = 0;
typedef struct {
    int heading_position;
    int direction;
    int speed;
} Log;

typedef struct {
    int x, y;
    int x_speed, y_speed;
} Frog;

typedef struct {
    Log *logs;
    int log_count;
} Logs;

typedef struct {
    Logs logs;
    Frog frog;
    char **map;
} GameMap;

char map[ROW][COLUMN];


void *handle_logs_movement(Logs *logs) {
    for (int i = 0; i < logs->log_count; i++) {
        Log *current_log = &logs->logs[i];

        // Update the heading position of the log based on its speed and direction
        current_log->heading_position += (current_log->direction * current_log->speed);

        // Handling the boundary conditions for the log's heading position
        if (current_log->heading_position >= COLUMN) {
            current_log->heading_position %= COLUMN;
        } else if (current_log->heading_position < 0) {
            current_log->heading_position = COLUMN - (-current_log->heading_position % COLUMN);
        }
    }
    return NULL;
}
    
// The printed result should be handled in the parent thread
void initialize_game(char gameMap[ROW][COLUMN], Logs *logs) {
    // Using memset to set all characters in the game map to space
    memset(gameMap, ' ', ROW * COLUMN);
    
    srand(time(NULL)); // Seed for random number generation
    
    for (int i = 0; i < logs->log_count; i++) {
        logs->logs[i].heading_position = rand() % COLUMN; // Random head position from 0 to COLUMN-1
        logs->logs[i].speed = SPEED;
        
        if (i % 2 == 0) {
            logs->logs[i].direction = 1; // Moving right
        } else {
            logs->logs[i].direction = -1; // Moving left
        }
    }
}

void initialize_map(char gameMap[ROW][COLUMN]) {
    // Using memset to set all characters in the game map to space
    memset(gameMap, ' ', ROW * COLUMN);
    
   }


void update_map(char gameMap[ROW][COLUMN], Logs *logs, Frog *frog) {
    // Setting the boundaries
    for(int i = 0; i < COLUMN; i++) {
        gameMap[0][i] = '|';
        gameMap[ROW-1][i] = '|';
    }
    
    // Updating the map based on logs' positions
    for(int i = 0; i < logs->log_count; i++) {
        Log log = logs->logs[i];
        for(int j = 0; j < LOG_LENGTH; j++) {
            int position = (log.heading_position + j) % COLUMN; // Handling the wrap-around
            gameMap[i+1][position] = '='; // Assuming logs are placed from the second row onward
        }
    }
    
    
    // check if the frog is in the map
    if ((frog->x>=COLUMN) || (frog->x<0) || (frog->y >= ROW) || (frog->y<0)){
        system("clear");
    	printf("you have just fallen out of the map\n");
    	exit(0);
    }
    
    // move the frog and judge are we winning the game or not
    if (gameMap[frog->y][frog->x] == ' '){
    	system("clear");
    	printf("you have just fallen to the river\n");
    	exit(0);
    }
    else{
    	gameMap[frog->y][frog->x] = '0';
    	if (frog->y == 0){
    		system("clear");
    		printf("you have just win the game ;) \n");
    		exit(0);
    	}
    }
}

void print_map(char gameMap[ROW][COLUMN]){
	system("clear");
        for(int i = 0; i < ROW; ++i) {
            for(int j = 0; j < COLUMN; ++j) {
                printf("%c", gameMap[i][j]);
            }
            printf("\n");
        }
}


// Determine a keyboard is hit or not. If yes, return 1. If not, return 0. 
int kbhit(void){
	struct termios oldt, newt;
	int ch;
	int oldf;

	tcgetattr(STDIN_FILENO, &oldt);

	newt = oldt;
	newt.c_lflag &= ~(ICANON | ECHO);

	tcsetattr(STDIN_FILENO, TCSANOW, &newt);
	oldf = fcntl(STDIN_FILENO, F_GETFL, 0);

	fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);

	ch = getchar();

	tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
	fcntl(STDIN_FILENO, F_SETFL, oldf);

	if(ch != EOF)
	{
		ungetc(ch, stdin);
		return 1;
	}
	return 0;
}

void handle_keyboard_hit(Frog *frog) {
    frog->x_speed = 0;
    frog->y_speed = 0;
    if(kbhit()) {
        char ch = getchar();
        switch(ch) {
            case 'w':
                frog->y_speed = -1; // Move up
                break;
            case 's':
                frog->y_speed = 1; // Move down
                break;
            case 'a':
                frog->x_speed = -1; // Move left
                break;
            case 'd':
                frog->x_speed = 1; // Move right
                break;
            case 'q':
            	system("clear");
            	printf("you have just quit the game\n");
            	exit(0);
            default:
                // handle other keys if necessary
                break;
        }

    }
}

void adjust_frog_speed(Frog *frog){
	if (frog->y == 0 || frog->y == ROW-1) return;
	else{
		if ((frog->y%2) == 0){
			frog->x_speed += -SPEED;
		}
		else{
			frog->x_speed += SPEED;
		}
		return;
	} 
}

void update_frog_position(Frog *frog) {
    frog->x += frog->x_speed;
    frog->y += frog->y_speed;
    // Reset the speed after updating the position
    frog->x_speed = 0;
    frog->y_speed = 0;
}



void* frog_thread_function(void* arg) {
    Frog* frog = (Frog*) arg; // treating the received argument as a pointer to Frog
    while (1) {

        pthread_mutex_lock(&mutex);
        while (!FROG_UPDATE_READY) {
            pthread_cond_wait(&frog_cond, &mutex);
        }

        handle_keyboard_hit(frog);
        adjust_frog_speed(frog);
        update_frog_position(frog);
        
        FROG_UPDATE_READY = 0;
        pthread_cond_signal(&main_cond);
        pthread_mutex_unlock(&mutex);

    }
    return NULL;
}


void* log_thread_function(void* arg) {
    Logs* logs = (Logs*) arg; // treating the received argument as a pointer to Logs
    while (1) {

        pthread_mutex_lock(&mutex);
        while (!LOG_UPDATE_READY) {
            pthread_cond_wait(&log_cond, &mutex);
        }

        handle_logs_movement(logs); // Passing the logs pointer directly
        
        LOG_UPDATE_READY = 0;
        pthread_cond_signal(&main_cond);
        pthread_mutex_unlock(&mutex);
    }
    return NULL;
}









int main() {
    char gameMap[ROW][COLUMN]; // Declare the game map
    Logs logs; //DECLARE the logs position
    logs.logs = malloc(sizeof(Log) * NUMBER_OF_LOGS);
    logs.log_count = NUMBER_OF_LOGS;
    Frog frog;
    frog.x = COLUMN / 2; // Initializing the frog's position
    frog.y = ROW - 1;
    frog.x_speed = 0;
    frog.y_speed = 0;
    initialize_game(gameMap, &logs); 
    
    
    pthread_t frog_thread, log_thread;
    pthread_create(&frog_thread, NULL, frog_thread_function, (void*) &frog);
    pthread_create(&log_thread, NULL, log_thread_function, (void*) &logs);
    
    while(1){


        
        FROG_UPDATE_READY = 1;
        LOG_UPDATE_READY = 1;
        pthread_mutex_lock(&mutex);
        pthread_cond_signal(&frog_cond);
        pthread_cond_signal(&log_cond);

        
        while(FROG_UPDATE_READY||LOG_UPDATE_READY){
		pthread_cond_wait(&main_cond, &mutex);
	}
        pthread_mutex_unlock(&mutex);
        
    	
        update_map(gameMap, &logs, &frog); // Update the game map with the new logs' positions
        
	print_map(gameMap);


	usleep(200000);
        initialize_map(gameMap);
    }
    return 0;
}
