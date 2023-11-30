//Shell Scripting array sort

#!/bin/bash

arr=(1 2 3 4 5 6 7 8 9 10)
echo "Array is ${arr[@]}"

echo "Choose an array operation to perform"
echo "1. Print array length"
echo "2. Insert an element"
echo "3. Delete an element"

read choice
case $choice in
    1) echo "Array length is ${#arr[@]}"
    ;;
    2) echo "Enter the element to insert"
        read element
        echo "Enter the position to insert"
        read position
        arr=(${arr[@]:0:$position} $element ${arr[@]:$position})
        echo "Array is ${arr[@]}"
    ;;
    3) eecho "Enter the position to delete"
        read position
        unset arr[$position]
        echo "Array is ${arr[@]}"
    ;;
esac

// Accept and Display Data

#!/bin/bash

# Check if at least one argument is passed
if [ $# -lt 1 ]; then
  echo "No arguments passed"
  exit 1
fi

# Display passed arguments 
echo "Number of arguments: $#"
echo "List of arguments:"

for arg in $@; do
  echo $arg
done

echo "Arguments printed successfully!"

To run in bash
./display_arguments.sh arg1 arg2 arg3

////////////////////

/* Write a program demonstrating use of different system calls (Implementation of
Any 2 to 3 System calls.) */

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main() {
    // Write
    int n;
    printf("Write System Call:\n");
    n = write(1, "Hello", 5);
    printf("\n");
    write(1, "Hello", 2); // prints only 2 characters
    printf("\n");

    // write(1, "Hello", 20); // Causes buffer overflow, commented out
    printf("\n");
    printf("Value of n is %d\n", n);

    printf("\n");
    printf("Read System Call:\n");
    // Read
    // We cannot read directly; first, we have to store it in some memory (buffer)
    int m;
    char b[30]; // memory (buffer) max storage: 30
    m = read(0, b, 30);
    write(1, b, m);

    // Close
    close(0); // Close standard input (stdin)
    close(1); // Close standard output (stdout)

    return 0;
}

/////////////////////////////////////////////////////////////////////////////////////

//Producer Consumer Using Mutex

#include<pthread.h>
#include<semaphore.h>
#include<stdio.h>
#include<stdlib.h>

#define maxitems 5
#define buffersize 5

sem_t empty;
sem_t full;
int in=0;
int out=0;

int buffer[buffersize];
pthread_mutex_t mutex;

void *producer(void *pno)
{
    int item;
    for(int i=0;i<maxitems;i++)
    {
        item=rand();
        sem_wait(&empty);
        pthread_mutex_lock(&mutex);
        buffer[in]=item;
        printf("Producer %d:insert item %d at %d \n",*((int*)pno),buffer[in],in);
        in=(in+1)%buffersize;
        pthread_mutex_unlock(&mutex);
        sem_post(&full);
    }
}

void *consumer(void *cno)
{
    for(int i=0;i<maxitems;i++)
    {
        sem_wait(&full);
        pthread_mutex_lock(&mutex);
        int item=buffer[out];
        printf("Consumer %d:Remove item %d at %d \n",*((int*)cno),item,out);
        out=(out+1)%buffersize;
        pthread_mutex_unlock(&mutex);
        sem_post(&empty);
    }
}
int main()
{
    pthread_t pro[5],con[5];
    pthread_mutex_init(&mutex,NULL);
    sem_init(&empty,0,buffersize);
    sem_init(&full,0,0);
    
    int a[5]={1,2,3,4,5};
    
    for(int i=0;i<5;i++)
    {
        pthread_create(&pro[i],NULL,(void*)producer,(void*)&a[i]);
    }
    for(int i=0;i<5;i++)
    {
        pthread_create(&con[i],NULL,(void*)consumer,(void*)&a[i]);
    }
    
    for(int i=0;i<5;i++)
    {
        pthread_join(pro[i],NULL);
    }
    for(int i=0;i<5;i++)
    {
        pthread_join(con[i],NULL);
    }
    pthread_mutex_destroy(&mutex);
    sem_destroy(&empty);
    sem_destroy(&full);
    
    return 0;
}

/////////////////////////////////////////////////////////////
//Producer Consumer Using Semaphore

#include<stdio.h>
#include<pthread.h>
#include<semaphore.h>
#include<stdlib.h>
sem_t s,empty,full;
int queue[5],avail;
void *producer(void);
void *consumer(void);

int main(void)
{
    pthread_t prod_h,cons_h;
    avail=0;
    sem_init(&s,0,1);
    sem_init(&empty,0,2);
    sem_init(&full,0,0);
    pthread_create(&prod_h,0,producer,NULL);
    pthread_create(&cons_h,0,consumer,NULL);
    pthread_join(prod_h,0);
    pthread_join(cons_h,0);
    exit(0);
}

void *producer(void)
{
    int prod=0;
    int item;
    while(prod<5)
    {
        item=rand()%1000;
        sem_wait(&empty);
        sem_wait(&s);
        queue[avail]=item;
        avail++;
        prod++;
        printf("The item produced in buffer %d \n",item);
        sleep(3);
        sem_post(&s);
        sem_post(&full);
        if(prod==5)
        {
            printf("Buffer is full \n");
        }
    }
    pthread_exit(0);
}

void *consumer(void)
{
    int cons=0,my_item;
    while(cons<5)
    {
        sem_wait(&full);
        sem_wait(&s);
        cons++;
        avail--;
        my_item=queue[avail];
        
        sem_post(&s);
        sem_post(&empty);
        printf("Consumed by %d: ",my_item);
        sleep(1);
        if(cons==0)
        {
            printf("Buffer is empty \n");
        }
    }
    pthread_exit(0);
}

///////////////////////////////////////////////

//Multithreading for Matrix Operations using Pthreads

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define SIZE 3

int A[SIZE][SIZE] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
int B[SIZE][SIZE] = {{9, 8, 7}, {6, 5, 4}, {3, 2, 1}};
int C[SIZE][SIZE];

struct thread_data {
    int row;
};

void *multiply(void *arg) {
    struct thread_data *data = (struct thread_data *)arg;
    int row = data->row;

    for (int col = 0; col < SIZE; col++) {
        C[row][col] = 0;
        for (int k = 0; k < SIZE; k++) {
            C[row][col] += A[row][k] * B[k][col];
        }
    }
    pthread_exit(NULL);
}

int main() {
    pthread_t threads[SIZE];
    struct thread_data thread_data_array[SIZE];

    for (int i = 0; i < SIZE; i++) {
        thread_data_array[i].row = i;
        int status = pthread_create(&threads[i], NULL, multiply, (void *)&thread_data_array[i]);
        if (status != 0) {
            printf("Error in creating thread %d\n", i);
            exit(-1);
        }
    }

    for (int i = 0; i < SIZE; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Matrix A:\n");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%d ", A[i][j]);
        }
        printf("\n");
    }

    printf("\nMatrix B:\n");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%d ", B[i][j]);
        }
        printf("\n");
    }

    printf("\nMatrix C (Result of A * B):\n");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    return 0;
}

/////////////////////////////////////////////////////////
// FCFS non-premptive
#include "stdio.h"
#include "stdlib.h"
struct process
{
	int process_id;
	int arrival_time;
	int burst_time;
	int waiting_time;
	int turn_around_time;
};
int main()
{
	int n,i;
	printf("Enter number of processes: ");
	scanf("%d",&n);
	struct process proc[n];
	for(i=0;i<n;i++)
	{
		printf("\n");
		printf("Enter arrival time for process%d: ",i+1);
		scanf("%d",&proc[i].arrival_time);
		printf("Enter burst time for process%d: ",i+1);
		scanf("%d",&proc[i].burst_time);
		proc[i].process_id = i+1;
	}
	int service_time[n];
	service_time[0]=0;
	proc[0].waiting_time=0;	

	for(i=1;i<n;i++)
	{
		service_time[i]=service_time[i-1]+proc[i-1].burst_time;
		proc[i].waiting_time = service_time[i]-proc[i].arrival_time;

		if(proc[i].waiting_time<0)
			proc[i].waiting_time=0;
	}

	for(i=0;i<n;i++)
	{
		proc[i].turn_around_time = proc[i].burst_time + proc[i].waiting_time;
	}
	printf("\n\n");
	printf("Process\tBurst Time\tArrival Time\tWaiting Time\tTurn-Around Time\tCompletion Time\n");
	int total_waiting_time=0,total_turn_around_time=0;
	for(i=0;i<n;i++)
	{
		total_waiting_time+=proc[i].waiting_time;
		total_turn_around_time+=proc[i].turn_around_time;

		int completion_time=proc[i].turn_around_time + proc[i].arrival_time;

		printf("%d\t\t%d\t\t%d\t\t%d\t\t%d\t\t%d\n",proc[i].process_id,proc[i].burst_time, proc[i].arrival_time, proc[i].waiting_time,proc[i].turn_around_time,completion_time);
	}
	printf("Average waiting time: %f\n", (float)total_waiting_time/n);
	printf("Average turn around time: %f\n",(float)total_turn_around_time/n);
}

// FCFS Another Method 

#include <stdio.h>

int main() {
    int n, i, at[20], bt[20], wt[20], tat[20], avwt = 0, avtat = 0;

    printf("Enter the number of processes: ");
    scanf("%d", &n);

    printf("Enter arrival time and burst time for each process:\n");
    for (i = 0; i < n; i++) {
        printf("P[%d]: ", i + 1);
        scanf("%d %d", &at[i], &bt[i]);
    }

    wt[0] = 0;
    for (i = 1; i < n; i++) {
        wt[i] = wt[i - 1] + bt[i - 1] - at[i] + at[i - 1];
        avwt += wt[i];
    }

    for (i = 0; i < n; i++) {
        tat[i] = wt[i] + bt[i];
        avtat += tat[i];
    }

    printf("Process\tArrival Time\tBurst Time\tWaiting Time\tTurnaround Time\n");
    for (i = 0; i < n; i++) {
        printf("P[%d]\t%d\t\t%d\t\t%d\t\t%d\n", i + 1, at[i], bt[i], wt[i], tat[i]);
    }

    avwt /= n;
    avtat /= n;

    printf("Average Waiting Time: %d\n", avwt);
    printf("Average Turnaround Time: %d\n", avtat);

    return 0;
}
/////////////////////////////////////////////////////////

// SJF Non-Preemptive

// C++ implementation of shortest job first
// using the concept of segment tree

#include <bits/stdc++.h>
using namespace std;
#define ll long long
#define z 1000000007
#define sh 100000
#define pb push_back
#define pr(x) printf("%d ", x)

struct util {

	// Process ID
	int id;
	// Arrival time
	int at;
	// Burst time
	int bt;
	// Completion time
	int ct;
	// Turnaround time
	int tat;
	// Waiting time
	int wt;
}

// Array to store all the process information
// by implementing the above struct util
ar[sh + 1];

struct util1 {

	// Process id
	int p_id;
	// burst time
	int bt1;
};

util1 range;

// Segment tree array to
// process the queries in nlogn
util1 tr[4 * sh + 5];

// To keep an account of where
// a particular process_id is
// in the segment tree base array
int mp[sh + 1];

// Comparator function to sort the
// struct array according to arrival time
bool cmp(util a, util b)
{
	if (a.at == b.at)
		return a.id < b.id;
	return a.at < b.at;
}

// Function to update the burst time and process id
// in the segment tree
void update(int node, int st, int end,
			int ind, int id1, int b_t)
{
	if (st == end) {
		tr[node].p_id = id1;
		tr[node].bt1 = b_t;
		return;
	}
	int mid = (st + end) / 2;
	if (ind <= mid)
		update(2 * node, st, mid, ind, id1, b_t);
	else
		update(2 * node + 1, mid + 1, end, ind, id1, b_t);
	if (tr[2 * node].bt1 < tr[2 * node + 1].bt1) {
		tr[node].bt1 = tr[2 * node].bt1;
		tr[node].p_id = tr[2 * node].p_id;
	}
	else {
		tr[node].bt1 = tr[2 * node + 1].bt1;
		tr[node].p_id = tr[2 * node + 1].p_id;
	}
}

// Function to return the range minimum of the burst time
// of all the arrived processes using segment tree
util1 query(int node, int st, int end, int lt, int rt)
{
	if (end < lt || st > rt)
		return range;
	if (st >= lt && end <= rt)
		return tr[node];
	int mid = (st + end) / 2;
	util1 lm = query(2 * node, st, mid, lt, rt);
	util1 rm = query(2 * node + 1, mid + 1, end, lt, rt);
	if (lm.bt1 < rm.bt1)
		return lm;
	return rm;
}

// Function to perform non_preemptive
// shortest job first and return the
// completion time, turn around time and
// waiting time for the given processes
void non_preemptive_sjf(int n)
{

	// To store the number of processes
	// that have been completed
	int counter = n;

	// To keep an account of the number
	// of processes that have been arrived
	int upper_range = 0;

	// Current running time
	int tm = min(INT_MAX, ar[upper_range + 1].at);

	// To find the list of processes whose arrival time
	// is less than or equal to the current time
	while (counter) {
		for (; upper_range <= n;) {
			upper_range++;
			if (ar[upper_range].at > tm || upper_range > n) {
				upper_range--;
				break;
			}

			update(1, 1, n, upper_range,
				ar[upper_range].id, ar[upper_range].bt);
		}

		// To find the minimum of all the running times
		// from the set of processes whose arrival time is
		// less than or equal to the current time
		util1 res = query(1, 1, n, 1, upper_range);

		// Checking if the process has already been executed
		if (res.bt1 != INT_MAX) {
			counter--;
			int index = mp[res.p_id];
			tm += (res.bt1);

			// Calculating and updating the array with
			// the current time, turn around time and waiting time
			ar[index].ct = tm;
			ar[index].tat = ar[index].ct - ar[index].at;
			ar[index].wt = ar[index].tat - ar[index].bt;

			// Update the process burst time with
			// infinity when the process is executed
			update(1, 1, n, index, INT_MAX, INT_MAX);
		}
		else {
			tm = ar[upper_range + 1].at;
		}
	}
}

// Function to call the functions and perform
// shortest job first operation
void execute(int n)
{

	// Sort the array based on the arrival times
	sort(ar + 1, ar + n + 1, cmp);
	for (int i = 1; i <= n; i++)
		mp[ar[i].id] = i;

	// Calling the function to perform
	// non-preemptive-sjf
	non_preemptive_sjf(n);
}

// Function to print the required values after
// performing shortest job first
void print(int n)
{

	cout << "ProcessId "
		<< "Arrival Time "
		<< "Burst Time "
		<< "Completion Time "
		<< "Turn Around Time "
		<< "Waiting Time\n";
	for (int i = 1; i <= n; i++) {
		cout << ar[i].id << " \t\t "
			<< ar[i].at << " \t\t "
			<< ar[i].bt << " \t\t "
			<< ar[i].ct << " \t\t "
			<< ar[i].tat << " \t\t "
			<< ar[i].wt << " \n";
	}
}

// Driver code
int main()
{
	// Number of processes
	int n = 5;

	// Initializing the process id
	// and burst time
	range.p_id = INT_MAX;
	range.bt1 = INT_MAX;

	for (int i = 1; i <= 4 * sh + 1; i++) {
		tr[i].p_id = INT_MAX;
		tr[i].bt1 = INT_MAX;
	}

	// Arrival time, Burst time and ID
	// of the processes on which SJF needs
	// to be performed
	ar[1].at = 1;
	ar[1].bt = 7;
	ar[1].id = 1;

	ar[2].at = 2;
	ar[2].bt = 5;
	ar[2].id = 2;

	ar[3].at = 3;
	ar[3].bt = 1;
	ar[3].id = 3;

	ar[4].at = 4;
	ar[4].bt = 2;
	ar[4].id = 4;

	ar[5].at = 5;
	ar[5].bt = 8;
	ar[5].id = 5;

	execute(n);

	// Print the calculated time
	print(n);
}

/////////////////////////////////////////////////////////////////////////

// 	Shortest Job First Process Scheduling Non-Pre

#include "stdio.h"
#include "stdlib.h"
struct process
{
	int process_id;
	int arrival_time;
	int burst_time;
	int waiting_time;
	int turn_around_time;
};
int main()
{
	int n,i,j;
	int bt=0,k=1,tat=0,sum=0,min;
	printf("Enter number of processes: ");
	scanf("%d",&n);
	struct process proc[n],temp;
	for(i=0;i<n;i++)
	{
		printf("\n");
		printf("Enter arrival time for process%d: ",i+1);
		scanf("%d",&proc[i].arrival_time);
		printf("Enter burst time for process%d: ",i+1);
		scanf("%d",&proc[i].burst_time);
		proc[i].process_id = i+1;
	}

	for(i=0;i<n;i++)
	{
		for(j=0;j<n;j++)
		{
			if(proc[i].arrival_time < proc[j].arrival_time)
			{
				temp = proc[j];
				proc[j] = proc[i];
				proc[i] = temp;
			}
		}
	}

	for(i=0;i<n;i++)
	{
		bt+=proc[i].burst_time;
		min = proc[k].burst_time;
		for(j=k;j<n;j++)
		{
			if(bt>=proc[j].arrival_time && proc[j].burst_time<min)
			{
				temp=proc[k];
				proc[k]=proc[j];
				proc[j]=temp;
			}
		}
		k++;
	}
	proc[0].waiting_time=0;
	int wait_time_total=0;
	int turn_around_time_total=0;
	for(i=1;i<n;i++)
	{
		sum+=proc[i-1].burst_time;
		proc[i].waiting_time = sum-proc[i].arrival_time;
		wait_time_total += proc[i].waiting_time;
	}
	for(i=0;i<n;i++)
	{
		tat+=proc[i].burst_time;
		proc[i].turn_around_time = tat - proc[i].arrival_time;
		turn_around_time_total+=proc[i].turn_around_time;
	}
	printf("Process\tBurst Time\tArrival Time\tWaiting Time\tTurn-Around Time\n");

	for(i=0;i<n;i++)
	{

		printf("%d\t\t%d\t\t%d\t\t%d\t\t%d\n",proc[i].process_id,proc[i].burst_time, proc[i].arrival_time, proc[i].waiting_time,proc[i].turn_around_time);
	}
	printf("Average waiting time: %f\n", (float)wait_time_total/n);
	printf("Average turn around time: %f\n",(float)turn_around_time_total/n);

}

/////////////////////////////////////////////////////////////
// SJF Premptive

#include "stdio.h"

#include "stdlib.h"

struct process

{

	int process_id;

	int arrival_time;

	int burst_time;

	int waiting_time;

	int turn_around_time;

	int remain_time;

};

int main()

{

	int n,i,j;

	int bt=0,k=1,tat=0,sum=0,min;

	printf("Enter number of processes: ");

	scanf("%d",&n);

	struct process proc[n],temp;

	for(i=0;i<n;i++)

	{

		printf("\n");

		printf("Enter arrival time for process%d: ",i+1);

		scanf("%d",&proc[i].arrival_time);

		printf("Enter burst time for process%d: ",i+1);

		scanf("%d",&proc[i].burst_time);

		proc[i].remain_time = proc[i].burst_time;

		proc[i].process_id = i+1;

	}

	int quantum_time,flag=0;

	printf("Enter time quantum: ");

	scanf("%d",&quantum_time);

	int processes_remaining=n;

	for(i=0;i<n;i++)

	{

		for(j=0;j<n;j++)

		{

			if(proc[i].arrival_time < proc[j].arrival_time)

			{

				temp = proc[j];

				proc[j] = proc[i];

				proc[i] = temp;

			}

		}

	}

	int wait_time_total=0,totalExecutionTime=0,turn_around_time_total=0;

	i=0;	

	while(processes_remaining!=0)

	{

		if(proc[i].remain_time<=quantum_time && proc[i].remain_time>0)

		{

			totalExecutionTime+=proc[i].remain_time;

			proc[i].remain_time = 0;

			flag=1;

		}

		else if(proc[i].remain_time>0)

		{

			proc[i].remain_time-=quantum_time;

			totalExecutionTime+=quantum_time;

		}

		if(flag==1 && proc[i].remain_time==0)

		{

			proc[i].waiting_time=totalExecutionTime-proc[i].arrival_time-proc[i].burst_time;

			wait_time_total+=proc[i].waiting_time;

			

			proc[i].turn_around_time=totalExecutionTime-proc[i].arrival_time;

			turn_around_time_total+=proc[i].turn_around_time;

			flag=0;

			processes_remaining--;

		}

		if(i==n-1)

		{

			i=0;

		}

		else if(proc[i+1].arrival_time<=totalExecutionTime)

			i++;

		else

			i=0;

	}

	printf("Process\tBurst Time\tArrival Time\tWaiting Time\tTurn-Around Time\n");

	for(i=0;i<n;i++)

	{

		printf("%d\t\t%d\t\t%d\t\t%d\t\t%d\n",proc[i].process_id,proc[i].burst_time, proc[i].arrival_time, proc[i].waiting_time,proc[i].turn_around_time);

	}

	printf("Average waiting time: %f\n", (float)wait_time_total/n);

	printf("Average turn around time: %f\n",(float)turn_around_time_total/n);

}
///////////////////////////////////////////////////////////////////////

// Priority Preemptive

#include <stdio.h>
#include <stdbool.h>

// Process struct definition
struct Process {
    int pid; // Process ID
    int arrival_time; // Arrival time
    int burst_time; // Burst time
    int remaining_time; // Remaining time
    int waiting_time; // Waiting time
    int turnaround_time; // Turnaround time
    int priority; // Priority of the process
    bool is_completed; // Indicates whether process has completed or not
};

// Function to find the process with the highest priority in the queue
int find_highest_priority(struct Process processes[], int n, int current_time) {
    int highest_priority_index = -1;
    int highest_priority = -1;
    
    for (int i = 0; i < n; i++) {
        if (processes[i].priority > highest_priority && processes[i].is_completed == false && processes[i].arrival_time <= current_time) {
            highest_priority_index = i;
            highest_priority = processes[i].priority;
        }
    }
    
    return highest_priority_index;
}

// Function to calculate waiting time and turnaround time for each process
void calculate_times(struct Process processes[], int n) {
    int current_time = 0;
    int completed_processes = 0;
    
    while (completed_processes != n) {
        int highest_priority_index = find_highest_priority(processes, n, current_time);
        
        if (highest_priority_index == -1) {
            current_time++;
            continue;
        }
        
        processes[highest_priority_index].remaining_time--;
        
        if (processes[highest_priority_index].remaining_time == 0) {
            processes[highest_priority_index].waiting_time = current_time - processes[highest_priority_index].arrival_time - processes[highest_priority_index].burst_time;
            processes[highest_priority_index].turnaround_time = current_time - processes[highest_priority_index].arrival_time;
            processes[highest_priority_index].is_completed = true;
            completed_processes++;
        }
        
        current_time++;
    }
}

// Function to print process details
void print_processes(struct Process processes[], int n) {
    printf("PID\tArrival Time\tBurst Time\tPriority\tWaiting Time\tTurnaround Time\n");
    
    for (int i = 0; i < n; i++) {
        printf("%d\t%d\t\t%d\t\t%d\t\t%d\t\t%d\n", processes[i].pid, processes[i].arrival_time, processes[i].burst_time, processes[i].priority, processes[i].waiting_time, processes[i].turnaround_time);
    }
    
    printf("\n");
}

// Main function
int main() {
    int n;
    
    printf("Enter the number of processes: ");
    scanf("%d", &n);
    
    // Process array initialization
    struct Process processes[n];
    
    // Inputting process details
    for (int i = 0; i < n; i++) {
        printf("Enter the arrival time of process %d: ", i + 1);
        scanf("%d", &processes[i].arrival_time);
        printf("Enter the burst time of process %d: ", i + 1);
        scanf("%d", &processes[i].burst_time);
        printf("Enter the priority of process %d: ", i + 1);
        scanf("%d", &processes[i].priority);
        processes[i].pid = i + 1;
        processes[i].remaining_time = processes[i].burst_time;
        processes[i].is_completed = false;
    }
    
// Calculation of waiting time and turnaround time
calculate_times(processes, n);

// Printing the details of each process
print_processes(processes, n);

return 0;
}

// Priority Non-Preemptive

#include <stdio.h>

// Process struct definition
struct Process {
    int pid; // Process ID
    int arrival_time; // Arrival time
    int burst_time; // Burst time
    int waiting_time; // Waiting time
    int turnaround_time; // Turnaround time
    int priority; // Priority of the process
};

// Function to calculate waiting time and turnaround time for each process
void calculate_times(struct Process processes[], int n) {
    // Sort processes based on priority
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (processes[i].priority > processes[j].priority) {
                struct Process temp = processes[i];
                processes[i] = processes[j];
                processes[j] = temp;
            }
        }
    }

    // Calculate waiting time and turnaround time for each process
    processes[0].waiting_time = 0; // First process has 0 waiting time

    for (int i = 1; i < n; i++) {
        int waiting_time = 0;

        for (int j = 0; j < i; j++) {
            waiting_time += processes[j].burst_time;
        }

        processes[i].waiting_time = waiting_time - processes[i].arrival_time;

        if (processes[i].waiting_time < 0) {
            processes[i].waiting_time = 0;
        }

        processes[i].turnaround_time = processes[i].waiting_time + processes[i].burst_time;
    }
}

// Function to print process details
void print_processes(struct Process processes[], int n) {
    printf("PID\tArrival Time\tBurst Time\tPriority\tWaiting Time\tTurnaround Time\n");

    for (int i = 0; i < n; i++) {
        printf("%d\t%d\t\t%d\t\t%d\t\t%d\t\t%d\n", processes[i].pid, processes[i].arrival_time, processes[i].burst_time, processes[i].priority, processes[i].waiting_time, processes[i].turnaround_time);
    }

    printf("\n");
}

// Main function
int main() {
    int n;

    printf("Enter the number of processes: ");
    scanf("%d", &n);

    // Process array initialization
    struct Process processes[n];

    // Inputting process details
    for (int i = 0; i < n; i++) {
        printf("Enter the arrival time of process %d: ", i + 1);
        scanf("%d", &processes[i].arrival_time);
        printf("Enter the burst time of process %d: ", i + 1);
        scanf("%d", &processes[i].burst_time);
        printf("Enter the priority of process %d: ", i + 1);
        scanf("%d", &processes[i].priority);
        processes[i].pid = i + 1;
    }

    // Calculation of waiting time and turnaround time
    calculate_times(processes, n);

    // Printing process details
    print_processes(processes, n);

    return 0;
}

///////////////////////////////////////////////////////////////////////////////

// Round Robin 

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define N 100

struct process
{
	int process_id;
	int arrival_time;
	int burst_time;
	int waiting_time;
	int turn_around_time;
	int remaining_time;
};

int queue[N];
int front = 0, rear = 0;
struct process proc[N];

void push(int process_id)
{
	queue[rear] = process_id;
	rear = (rear+1)%N;
}

int pop()
{
	if(front == rear)
		return -1;

	int return_position = queue[front];
	front = (front +1)%N;
	return return_position;
}

int main()
{
	float wait_time_total = 0.0, tat = 0.0;
	int n,time_quantum;
	printf("Enter the number of processes: ");
	scanf("%d", &n);

	for(int i=0; i<n; i++)
	{
		printf("Enter the arrival time for the process%d: ",i+1);
		scanf("%d", &proc[i].arrival_time);
		printf("Enter the burst time for the process%d: ",i+1);
		scanf("%d", &proc[i].burst_time);
		proc[i].process_id = i+1;
		proc[i].remaining_time = proc[i].burst_time;
	}
	printf("Enter time quantum: ");
	scanf("%d",&time_quantum);

	int time=0; 
	int processes_left=n;   
	int position=-1; 		
	int local_time=0; 

	for(int j=0; j<n; j++)
		if(proc[j].arrival_time == time)
			push(j);

	while(processes_left)
	{
		if(local_time == 0) 
		{
			if(position != -1)
				push(position);

			position = pop();
		}

		for(int i=0; i<n; i++)
		{
			if(proc[i].arrival_time > time)
				continue;
			if(i==position)
				continue;
			if(proc[i].remaining_time == 0)
				continue;

			proc[i].waiting_time++;
			proc[i].turn_around_time++;
		}

		if(position != -1)
		{
			proc[position].remaining_time--;
			proc[position].turn_around_time++;
			
			if(proc[position].remaining_time == 0)
			{
				processes_left--;
				local_time = -1;
				position = -1;
			}
		}
		else
			local_time = -1; 

		time++;
		local_time = (local_time +1)%time_quantum;
		for(int j=0; j<n; j++)
			if(proc[j].arrival_time == time)	
				push(j);
	}

	printf("\n");

	printf("Process\t\tArrival Time\tBurst Time\tWaiting time\tTurn around time\n");
	for(int i=0; i<n; i++)
	{
		printf("%d\t\t%d\t\t", proc[i].process_id, proc[i].arrival_time);
		printf("%d\t\t%d\t\t%d\n", proc[i].burst_time, proc[i].waiting_time, proc[i].turn_around_time);

		tat += proc[i].turn_around_time;
		wait_time_total += proc[i].waiting_time;
	}

	tat = tat/(1.0*n);
	wait_time_total = wait_time_total/(1.0*n);

	printf("\nAverage waiting time     : %f",wait_time_total);
	printf("\nAverage turn around time : %f\n", tat);
	
}

////////////////////////////////////////////////////////////////////////////////////////

// FIFO Page Replacement

#include<stdio.h>

void fifo(int string[], int n, int size) {
    // Creating array for block storage
    int frames[n];
    // Initializing each block with -1
    for (int i=0; i<n; i++) {
        frames[i] = -1;
    }
    // Index to insert element
    int index = -1;
    // Counters
    int page_miss = 0;
    int page_hits = 0;
    // Traversing each symbol in FIFO
    for (int i=0; i<size; i++) {
        int symbol = string[i];
        int flag = 0;
        for (int j=0; j<n; j++) {
            if (symbol == frames[j]) {
                flag = 1;
                break;
            }
        }
        if (flag == 1) {
            printf("\nSymbol: %d Frame: ", symbol);
            for (int j=0; j<n; j++) {
                printf("%d ", frames[j]);
            }
            page_hits += 1;
        } else {
            index = (index + 1) % n;
            frames[index] = symbol;
            printf("\nSymbol: %d Frame: ", symbol);
            for (int j=0; j<n; j++) {
                printf("%d ", frames[j]);
            }
            page_miss += 1;
        }
    }
    printf("\nPage hits: %d", page_hits);
    printf("\nPage misses: %d", page_miss);
}

int main(void) {
    int string[] = {1,3,0,3,5,6,3};
    int no_frames = 3;
    int size = sizeof(string) / sizeof(int);
    fifo(string, no_frames, size);
    return 0;
}

/////////////////////////////////////////////

//LRU Page Replacement

#include <stdio.h>
#define MAX_PAGES 100

int findLRU(int time[], int n){
    int i, min = time[0], pos = 0;
    for(i = 1; i < n; i++){
        if(time[i] < min){
            min = time[i];
            pos = i;
        }
    }
    return pos;
}

int main(){
    int pages[MAX_PAGES], frames, n, i, j, k, faults = 0, hits = 0, pos;
    printf("Enter the number of frames: ");
    scanf("%d", &frames);
    printf("Enter the number of pages: ");
    scanf("%d", &n);
    printf("Enter the reference string: ");
    for(i = 0; i < n; i++){
        scanf("%d", &pages[i]);
    }
    int mem[frames], time[frames];
    for(i = 0; i < frames; i++){
        mem[i] = -1;
        time[i] = 0;
    }
    for(i = 0; i < n; i++){
        int pageExists = 0;
        for(j = 0; j < frames; j++){
            if(mem[j] == pages[i]){
                time[j] = i + 1;
                pageExists = 1;
                hits++;
                break;
            }
        }
        if(!pageExists){
            pos = findLRU(time, frames);
            mem[pos] = pages[i];
            time[pos] = i + 1;
            faults++;
        }
        printf("\nMemory State after reference %d:\n", pages[i]);
        for(k = 0; k < frames; k++){
            if(mem[k] == -1){
                printf("- ");
            } else {
                printf("%d ", mem[k]);
            }
        }
    }
    printf("\nTotal Page Faults: %d\n", faults);
    printf("Total Hits: %d\n", hits);
    return 0;
}

///////////////////////////////////////
// Optimal Page Replacement

#include <stdio.h>
#include <limits.h>

int main(){
    int frames, pages, i, j, k, l, hit = 0, fault = 0, max_dist, max_frame, flag;
    int reference_string[100], mem_layout[100][100], distance[100], hit_flag[100];
    
    printf("\nEnter the number of frames: ");
    scanf("%d", &frames);
    printf("\nEnter the number of pages: ");
    scanf("%d", &pages);
    printf("\nEnter the reference string: ");
    
    for(i = 0; i < pages; i++){
        scanf("%d", &reference_string[i]);
    }
    
    for(i = 0; i < frames; i++){
        mem_layout[i][0] = -1;
        hit_flag[i] = 0;
    }
    
    for(i = 0; i < pages; i++){
        hit = 0;
        for(j = 0; j < frames; j++){
            if(mem_layout[j][0] == reference_string[i]){
                hit = 1;
                hit_flag[i] = 1;
                break;
            }
        }
        if(hit == 0){
            fault++;
            flag = 0;
            for(j = 0; j < frames; j++){
                if(mem_layout[j][0] == -1){
                    mem_layout[j][0] = reference_string[i];
                    flag = 1;
                    break;
                }
            }
            if(flag == 0){
                for(j = 0; j < frames; j++){
                    distance[j] = INT_MAX;
                    for(k = i + 1; k < pages; k++){
                        if(reference_string[k] == mem_layout[j][0]){
                            distance[j] = k - i;
                            break;
                        }
                    }
                }
                max_dist = -1;
                for(j = 0; j < frames; j++){
                    if(distance[j] > max_dist){
                        max_dist = distance[j];
                        max_frame = j;
                    }
                }
                mem_layout[max_frame][0] = reference_string[i];
            }
        }
        for(j = 0; j < frames; j++){
            mem_layout[j][i + 1] = mem_layout[j][i];
        }
    }
    
    for(i = 0; i < pages; i++){
        if(hit_flag[i] == 1){
            hit++;
        }
    }
    
    printf("\nTotal Page Faults: %d", fault);
    printf("\nTotal Hits: %d", hit);
    
    return 0;
}
///////////////////////////////////////////////////////

//Deadlock Avoidance

#include<bits/stdc++.h>
using namespace std;
vector<vector<int>> allo;
vector<vector<int>> maxNeed;
vector<vector<int>> remNeed;
vector<int> avail;
vector<int> seq;
bool bankerAlgo(int n,int r){
      queue<int>q; // to add processes sequentially
      bool isDeadlock = false;
      for(int i=0;i<n;i++){
        q.push(i);
      }
      int count=0; // to count the number of process which is not get fullfilled 
      // if count==n in future then deadlock will occur 
    
      while(!q.empty()){
           int node = q.front();
           q.pop();
           bool needFill = true;
           for(int i=0;i<r;i++){
                if(avail[i]<remNeed[node][i]){
                    needFill = false;
                }
           }
           if(needFill){
                seq.push_back(node);
                count=0;
                // increasing availability
                for(int i=0;i<r;i++){
                   avail[i] += allo[node][i];
                }
           }
           else{
               count++;
               q.push(node);
           }
           if(count==n){  // deadlock occured
              isDeadlock = true;
              break;
           }
      }
    return isDeadlock;
}
void input2dArr(vector<vector<int>> &vec){
    int n = vec.size(), m = vec[0].size();
    for(int i=0;i<n;i++){
        for(int j=0;j<m;j++){
            cin>>vec[i][j];
        }
    }
}
void input1dArr(vector<int> &vec){
    int n = vec.size();
    for(int i=0;i<n;i++){
        cin>>vec[i];
    }
}
int main(){
    int n,r;
    cout<<"Enter the number of process and number of resources: ";
    cin>>n>>r;
    cout<<endl;
    allo = vector<vector<int>>(n,vector<int>(r));
    maxNeed = vector<vector<int>>(n,vector<int>(r));
    remNeed = vector<vector<int>>(n,vector<int>(r));
    avail = vector<int>(r);
    cout<<"Enter the allocated resources to each process: "<<endl;
    input2dArr(allo); // alloacated
    cout<<"Enter the max need to each process: "<<endl;
    input2dArr(maxNeed); //maxneed
    cout<<"Enter the availablelity of each resources: "<<endl;
    input1dArr(avail); //available resources
    // Finding the remaining need 
    for(int i=0;i<n;i++){
        for(int j=0;j<r;j++){
            remNeed[i][j] = maxNeed[i][j]-allo[i][j]; //remaining Need
        }
    }
    bool isDeadlock = bankerAlgo(n,r);
    if(isDeadlock){
        cout<<"Deadlock is occured so, No safe sequence of process is there "<<endl;
    }
    else{
        cout<<"No Deadlock is occured and safe seq is as follows: "<<endl;
        for(int i=0;i<n;i++){
            cout<<"P"<<seq[i]<<"<-";
        }cout<<endl;
    }
    return 0;    
}

