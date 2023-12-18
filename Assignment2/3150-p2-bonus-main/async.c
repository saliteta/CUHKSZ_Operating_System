#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "async.h"

// A struct for tasks in the task queue
typedef struct task {
    void (*handler)(int);
    int arg;
    struct task* next;
} task_t;

// Mutex and condition variable
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond_var = PTHREAD_COND_INITIALIZER;

// Task queue as a global variable
task_t* task_queue = NULL;

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
