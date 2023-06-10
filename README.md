# Project 5

![project meme](meme.jpg)

In this project you will implement a FIFO queue as a monitor that can be used to
solve the bounded buffer problem. Your queue will have a fixed capacity and will
block calling threads when it is full or empty. Bounded buffers are extremely
common in Operating Systems. When you write code in Java, Python, C#, etc. it
may seem like you have infinite memory. However, infinite memory is just an
abstraction that the OS provides, in reality you are limited by the physical
hardware the OS is running on.

## Important Links

- Review the [grading rubric](https://shanepanter.com/cs452/grading-rubric.html)

## Task 1 - Bounded Queue

Your job is to implement a bounded queue that is defined in `lab.h`. Your queue
should be able to have multiple threads adding and removing items without loss
of data or crashing. The provided testing code is setup to allow you to easily
test your implementation. Unit testing multi-threaded code is very difficult so
in this project we will do our testing in main.cpp.You can see all the options
that the testing code gives you with the **-h** flag.

```text
$ ./myprogram -h
Usage: myprogram [-c num consumer] [-p num producer] [-i num items] [-s queue size]
```

## Task 2 - Analysis

Once you have completed the implementing your code we want to analyze the
impact of having different numbers of producers and consumers.

I have provided you with a bash script `createplot.sh` and a gnuplot macro file
named `graph.plt` what will generate a nice plot showing the differences when
using a different number of producers and consumers. You will need to install
[gnuplot](http://www.gnuplot.info/) on your machine to complete this task. If
you can't or don't want to install gnuplot on your machine you can use one of
the lab machines that has it already installed.

Assuming that everything is working you can now generate your plot as follows:

```bash
$./createplot.sh -f student_plot -s 100
Running myprogram to generate data
Created plot student_plot.png from data.dat file
```

After the script finishes you should see a new file named `student_plot.png`.
You will need to add this to your retrospective. Your results will vary
depending on your hardware and current system load however you should be
able to produce something close. If your graph is not even close to the
example below there may be a problem in your implementation.

![example plot](example_plot.png)

## Task 3 - Stress test

The hard part about multi threaded programming is sometimes things work even
when the code is horribly broken! Running the code multiple times can sometimes
help to show these errors as shown below. Each example was from the exact same
code base and it produces different results depending on the timing (scheduling)
of the OS level threads.

You will need to implement a bash script named **stress.sh** that runs your
program with different numbers of producers, consumers, items, and sizes to make
sure you don't have any **race conditions** or deadlocks in your code. You can
use the very simple example below as a starting point you script will need to
be more robust that what is shown below.

```bash
$ while true
do
./myprogram -c 8 -p 5 -i 10000 -s 100 &>> /dev/null
done
```

### Run #1 Error

In this example you can see that due to a race condition in the code somehow the
consumer was able to consume 11 items when the producer only produced 10!
Clearly there is something wrong! In industry this kind of error **only** shows
up on Friday at 4:45pm!

```bash
shane|(master *%>):_solution$ ./myprogram
Creating 1 producers each producing 10 items for a total of 10
Creating 1 consumer threads
Consumer thread: 0x700002d6b000
consuming an item
Producer thread: 0x700002ce8000 - producing 10 items
dequeue: queue is empty!
ACK!! dequeue a NULL item! This should never happen!
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
Producer thread: 0x700002ce8000 - Done producing!
consuming an item
Consumer Thread: 0x700002d6b000 - Done consuming!
ERROR! Consumer got a null item!
Total produced:10
Total consumed:11
```

### Run #2 Correct

In this run you can see everything works great! This is how the code will run
Monday - Thursday, no issues here!! Both executions are from the exact same
executable.

```bash
$ ./myprogram
Creating 1 producers each producing 10 items for a total of 10
Creating 1 consumer threads
Producer thread: 0x7000081e2000 - producing 10 items
Consumer thread: 0x700008265000
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
consuming an item
Producer thread: 0x7000081e2000 - Done producing!
Consumer Thread: 0x700008265000 - Done consuming!
Total produced:10
Total consumed:10
```

## Task 4 - Cross platform

This task is mandatory for **Grad Students**. Undergrads can attempt this task
for extra credit.

After you complete the assignment on Linux using POSIX threads you will need to
port your code to **win32** and use the native windows threading primitives. You
will need to augment your code with pre-processor directives to call the
appropriate function depending on which system you are on. Microsoft provides a
very complete example for you to follow! All you need to do is adapt their
[example](https://docs.microsoft.com/en-us/windows/win32/sync/using-condition-variables)
to your solution.

As an example:

```C
#ifdef __linux__
    //linux code goes here
#leif _WIN32
    // windows code goes here
#else

#endif
```

## Task 5 - Complete the Retrospective

Once you have completed all the tasks open the file **Retrospective.md** and
complete each section that has a TODO label. Reference the grading rubric
for details on how this will be graded.

In your retrospective you must include your graph as an image and then talk
about the results. Were you able to generate something close to what the example
showed? Why or why not. What can you say about how the number of producers and
consumers impact performance.

## Task 6 - Add, Commit, Push your code

Once you are finished you need to make sure that you have pushed all your code
to GitHub for grading! The Video walk through linked in the beginning of this
document will show you how to accomplish this task.

## Hints

- [pthread tutorial](https://computing.llnl.gov/tutorials/pthreads/)
- [Intro to Threads](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-intro.pdf)
- [Condition Variables](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-cv.pdf)
- [Threads API](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-api.pdf)
- [Locks](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks.pdf)
- [Using Locks](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks-usage.pdf)
- [Locked Data Structures](https://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks-usage.pdf)
- [POSIX Threads Programming](https://hpc-tutorials.llnl.gov/posix/)
