# Assignment II

### Butian Xiong 120090584

## Basic Operation for Thread

- To compile a program with thread operation inside it, we need to use the following lines

```bash
gcc threads.c -o threads -lpthread
# Then we simply use ./threads to execute it
```

- Create Pthread

```c
int pthread_create(pthread_t *thread, const pthread_attr_t *attr, void *(*start_routine) (void *), void *arg);
```

### **Parameters:**

1. **`thread`**: A pointer to a **`pthread_t`** variable that will store the thread ID of the newly created thread.
2. **`attr`**: A pointer to a **`pthread_attr_t`** structure that specifies thread attributes (like stack size, scheduling policy, etc.). You can pass **`NULL`** for this parameter if you want to use the default attributes.
3. **`start_routine`**: A pointer to the function that the thread should execute once it's created. The function should return **`void *`** and take a single **`void *`** argument.
4. **`arg`**: A pointer to any data you want to pass to the thread's start routine.

### **Return value:**

- If successful, **`pthread_create`** returns **`0`**. Otherwise, an error number is returned to indicate the error.

```c
#include <stdio.h>
#include <pthread.h>

void *thread_function(void *arg) {
    int *val = (int *)arg;
    printf("Hello from thread! Value passed: %d\n", *val);
    return NULL;
}

int main() {
    pthread_t thread_id;
    int value = 42;

    // Create a new thread
    if (pthread_create(&thread_id, NULL, thread_function, &value) != 0) {
        fprintf(stderr, "Error creating thread\n");
        return 1;
    }

    // Wait for the thread to finish
    pthread_join(thread_id, NULL);

    printf("Thread finished!\n");
    return 0;
}
```

### **Explanation:**

1. We include the necessary headers with **`#include`**.
2. **`void *thread_function(void *arg)`**: This is the function that our thread will execute once it's created. We're passing an integer value to this function, though for flexibility, it receives a pointer to void (**`void *`**). Inside the function, we cast it back to the appropriate type (**`int *`**).
3. Inside **`main()`**, we declare a variable **`pthread_t thread_id;`** to store the ID of our newly created thread.
4. We also declare an integer variable **`value`** with a value of **`42`**. We'll pass this value to our thread function.
5. **`pthread_create(&thread_id, NULL, thread_function, &value)`**: We call **`pthread_create`** to create a new thread. We pass:
    - A pointer to our **`thread_id`** variable.
    - **`NULL`** for the thread attributes (using default attributes).
    - Our **`thread_function`** as the function the thread should run.
    - A pointer to our **`value`** variable as the argument for the thread function.
6. If **`pthread_create`** returns a non-zero value, there was an error creating the thread, and we print an error message.
7. We call **`pthread_join(thread_id, NULL)`** to wait for our thread to finish executing. If we didn't have this, the main program might finish executing before our thread had a chance to run.
8. Finally, we print "Thread finished!" after our thread has completed its work.

When you run this program, the main program will create a new thread, which will print a message with the passed value. After the thread finishes its work, the main program will print "Thread finished!".

### Conditional Variable

### **1. Why We Need Condition Variables:**

- We use condition variables because they allow us to synchronize threads based on the actual data or condition.
- For instance, in your case, we want to synchronize the operation of threads based on whether the update is ready or not.
- Condition variables are particularly beneficial when you want a thread to wait until a particular condition is met so that CPU time is not wasted in busy waiting.

### **2. How Condition Variables are Used:**

- **Initialization**: You initialize a condition variable using **`pthread_cond_init`**.
- **Waiting**: If the condition is not met, a thread can wait using **`pthread_cond_wait`**. This function is used to block the thread and release the mutex atomically.
- **Signaling**: When the condition is met, another thread can signal using **`pthread_cond_signal`** or **`pthread_cond_broadcast`**. This will wake up one or all waiting threads respectively.

### **3. Why It Works:**

- Let's go through the sequence of actions in your code:
    1. The main thread locks the mutex and checks if an update is ready.
    2. It sets the **`update_ready`** flag to signal that an update is ready.
    3. It then signals the condition variable, indicating that the waiting threads (frog and log threads) can proceed.
    4. The frog and log threads are waiting for the condition variable to be signaled. They start executing once it is signaled.
    5. After doing their part of the job (updating positions), they reset the **`update_ready`** flag and signal the condition variable, allowing the main thread to proceed.
- **Mutex Locking and Unlocking within `pthread_cond_wait`**:
    - When **`pthread_cond_wait`** is called, it will atomically unlock the mutex, allowing other threads to lock it.
    - When the thread is signaled and resumes execution, it will re-acquire the mutex lock.
- **Handling Spurious Wakeups**:
    - Condition variables can have spurious wakeups, where the thread wakes up even when it's not explicitly signaled.
    - The while loop (**`while (!update_ready)`**) is used to handle this by re-checking the condition even after a wakeup.

In summary, condition variables, combined with mutexes, offer a powerful synchronization mechanism to coordinate the execution of multiple threads based on the state of shared data or specific conditions. This way, they help in achieving fine-grained synchronization, ensuring that threads execute in the desired order and manner based on the actual conditions at runtime.

## Program Design for Main Task

### Data Structure

- We have a tree like data structure, the top layer or the root of the data structure is GameMap
- GameMap including logs, frog, and a map. This map is a char that used to print. The char is defined as [Row] [Column]
- Logs is a data structure contains an array of pointer to each log, and the number of log
- frog contains the current position of frog denote as x and y, and current speed denote as x_speed, y_speed
- Log contains heading position which is the column number of the first “=”, and direction which can either be 1 or -1, and speed

Detailed code list here:

```c
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
```

### Function Design (Without Thread)

### **1. `handle_logs_movement(Logs *logs)`**

- **Purpose**: Moves the logs horizontally across the screen.
- **Operations**:
    - Updates the position of each log based on its speed and direction.
    - Handles boundary conditions to ensure logs wrap around the screen.

### **2. `initialize_game(char gameMap[ROW][COLUMN], Logs *logs)`**

- **Purpose**: Initializes the game’s settings, setting up the logs’ initial positions.
- **Operations**:
    - Sets up the game map with space characters.
    - Initializes the positions, speed, and direction of the logs.

### **3. `initialize_map(char gameMap[ROW][COLUMN])`**

- **Purpose**: Initializes the game map with space characters.
- **Operations**:
    - Fills the map with space characters, effectively clearing it.

### **4. `update_map(char gameMap[ROW][COLUMN], Logs *logs, Frog *frog)`**

- **Purpose**: Updates the game map based on the current positions of the logs and the frog.
- **Operations**:
    - Sets up the boundaries in the map.
    - Updates the logs’ positions in the map.
    - Checks and updates the frog’s position, handles game termination conditions such as falling off the map or into the river, and winning the game.

### **5. `print_map(char gameMap[ROW][COLUMN])`**

- **Purpose**: Prints the current state of the game map to the terminal.
- **Operations**:
    - Clears the terminal and prints the current state of the game map.

### **6. `kbhit(void)`**

- **Purpose**: Checks if a keyboard key has been pressed.
- **Operations**:
    - Modifies terminal settings to detect key presses without waiting for Enter.
    - Returns 1 if a key is pressed; otherwise, it returns 0.

### **7. `handle_keyboard_hit(Frog *frog)`**

- **Purpose**: Handles the keyboard input to control the frog’s movement.
- **Operations**:
    - Changes the frog’s speed based on the key pressed (W, A, S, D).
    - Handles quitting the game when the Q key is pressed.

### **8. `adjust_frog_speed(Frog *frog)`**

- **Purpose**: Adjusts the frog’s speed based on its position.
- **Operations**:
    - Modifies the frog’s speed, especially when it is on a log.

### **9. `update_frog_position(Frog *frog)`**

- **Purpose**: Updates the frog’s position based on its speed.
- **Operations**:
    - Adjusts the frog’s position coordinates.
    - Resets the frog’s speed after the position is updated.

### **Summary**

- The functions work together to manage and update the game's state.
- **`handle_logs_movement`** and **`initialize_game`** focus on setting up and moving the logs.
- **`update_map`**, **`print_map`**, **`handle_keyboard_hit`**, **`adjust_frog_speed`**, and **`update_frog_position`** are centered around handling the frog's movements and interactions with the game map.
- **`kbhit`** is a utility function to assist in non-blocking keyboard input detection.
- Each function plays a specific role in ensuring the game runs smoothly, handling various aspects like user input, game entity movements, and display updates.

### Thread Function Design

### **1. `frog_thread_function(void* arg)`**

- **Multithreading Utilization**:
    - This function is executed in a separate thread and deals exclusively with the frog’s movements.
    - **`pthread_mutex_lock(&mutex)`** is used to ensure synchronized access to shared resources, preventing data races.
    - **`pthread_cond_wait(&frog_cond, &mutex)`** makes this thread wait until the main thread signals that it's ready for the frog to be updated.
    - After updating the frog’s position, it signals the main thread using **`pthread_cond_signal(&main_cond)`** to continue its execution.
- **Tasks Performed**:
    - Handles keyboard hits to update the frog's direction.
    - Adjusts the frog's speed and updates its position.

### **2. `log_thread_function(void* arg)`**

- **Multithreading Utilization**:
    - This function is run in a separate thread and is solely responsible for updating the logs’ movements.
    - Utilizes mutex locks to ensure that shared data is accessed and modified safely.
    - The condition variable **`log_cond`** is used to synchronize the execution with the main thread.
- **Tasks Performed**:
    - Handles the movement of logs within the game.

### **3. `main()`**

- **Multithreading Utilization**:
    - Creates two threads, one for the frog and another for the logs, using **`pthread_create()`**.
    - Utilizes mutex and condition variables to synchronize the execution of these threads.
    - Signals the frog and log threads to start their tasks by setting flags and using **`pthread_cond_signal()`**.
    - Waits for both threads to complete their tasks using **`pthread_cond_wait()`**, ensuring synchronization.
- **Tasks Performed**:
    - Initializes the game.
    - Manages the synchronization of the frog and log threads.
    - Continuously updates the game map and prints it to the screen, maintaining the game's visual representation.

### **Summary**

- **Mutex Locks**: Mutexes are used extensively for ensuring that shared resources, like game entities’ states, are accessed and modified in a thread-safe manner.
- **Condition Variables**:
    - Used for synchronization. The main thread waits for the frog and log threads to complete their tasks and vice versa.
    - The main thread signals the worker threads (frog and log threads) to start their updates, and the worker threads signal back once they complete their tasks.
- **Signal Handling**:
    - Condition signals are utilized to notify waiting threads to proceed, ensuring that each part (frog movement, log movement, map update) is completed at the appropriate time.
- **Flags**:
    - Flags like **`FROG_UPDATE_READY`** and **`LOG_UPDATE_READY`** are used as conditional variables to check whether a particular thread's task is completed or not.

This architecture ensures a smooth, synchronized execution flow where the main thread and worker threads cooperate and wait for each other’s tasks to be completed before proceeding, maximizing the efficiency and correctness of the multithreaded game application.

## Environment

### OS: Ubuntu 20.04

### Linux Kernel: 5.15.0-86-generic

### gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0

## How to Execute

```c
gcc source.c -o game -lpthread
./game
```

## Result

![Untitled](Assignment%20II%2042149f869e5a47c2aece0a9730b1600b/Untitled.png)

![Untitled](Assignment%20II%2042149f869e5a47c2aece0a9730b1600b/Untitled%201.png)

## Bonus Task

Since I have already used conditional variable at the first task, there is no need to explain it in details

## Implementation

Create a worker function and have a infinite loop there to check if there is some task in the queue, if not start to wait, if not write another while lop with a conditional_wait there to wait 

```c
// The worker thread function
void* worker(void* arg) {
    while (1) {
        pthread_mutex_lock(&lock);

        while (task_queue == NULL) {
            pthread_cond_wait(&cond_var, &lock);
        }

        // Pop a task from the queue
        task_t* task = task_queue;
        task_queue = task->next;

        pthread_mutex_unlock(&lock);

        // Execute the task
        task->handler(task->arg);

        // Free the task
        free(task);
    }
    return NULL;
}
```

Call worker in the async_run instead of call function directly

```c
void async_init(int num_threads) {
    pthread_t threads[num_threads];
    for (int i = 0; i < num_threads; i++) {
        pthread_create(&threads[i], NULL, worker, NULL);
    }
    
    printf("thread has been created\n");

    // Detach threads
    for (int i = 0; i < num_threads; i++) {
        pthread_detach(threads[i]);
    }
}

void async_run(void (*handler)(int), int arg) {
    // Allocate a new task
    task_t* task = malloc(sizeof(task_t));
    task->handler = handler;
    task->arg = arg;
    task->next = NULL;
    printf("the first function has been called\n");
    pthread_mutex_lock(&lock);

    // Add task to the task queue
    if (task_queue == NULL) {
        task_queue = task;
    } else {
        task_t* tmp = task_queue;
        while (tmp->next != NULL) {
            tmp = tmp->next;
        }
        tmp->next = task;
    }

    pthread_cond_signal(&cond_var);
    pthread_mutex_unlock(&lock);
}
```

## Result

```bash
saliteta@saliteta-VirtualBox:~/workspace/bonous$ ./httpserver --proxy 127.0.0.1:8000 --port 8000 --num-threads 5clear
thread has been created
Listening on port 8000...
Accepted connection from 127.0.0.1 on port 20180
the first function has been called
Thread 140134407526144 will handle proxy request 0.
request thread 0 start to work
response thread 0 start to work
Accepted connection from 127.0.0.1 on port 21204
the first function has been called
Thread 140134399133440 will handle proxy request 1.
Accepted connection from 127.0.0.1 on port 24788
the first function has been called
response thread 1 start to work
request thread 1 start to work
Thread 140134390740736 will handle proxy request 2.
Accepted connection from 127.0.0.1 on port 25812
the first function has been called
request thread 2 start to work
Thread 140134373955328 will handle proxy request 3.
Accepted connection from 127.0.0.1 on port 29908
the first function has been called
Thread 140134382348032 will handle proxy request 4.
request thread 3 start to work
Accepted connection from 127.0.0.1 on port 30932
the first function has been called
response thread 2 start to work
response thread 4 start to work
response thread 3 start to work
request thread 4 start to work
Accepted connection from 127.0.0.1 on port 33492
the first function has been called
request thread 0 read failed, status 0
request thread 0 write failed, status 0
request thread 0 exited
Socket closed, proxy request 0 finished.

Thread 140134407526144 will handle proxy request 5.
Accepted connection from 127.0.0.1 on port 54915
the first function has been called
response thread 5 start to work
request thread 5 start to work
Accepted connection from 127.0.0.1 on port 59011
the first function has been called
^CCaught signal 2: Interrupt
Closing socket 3
```