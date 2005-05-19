# a modified version of scheduler.rb
# author: John Labovitz <j...@johnlabovitz.com>

# Schedules tasks in a cron-like manner, but uses a nearly-English  
# syntax for scheduling tasks.
# It uses threads to do the waiting, although the tasks themselves are  
# run sequentially in the main thread.

# Note that it doesn't handle absolute times or dates (eg, 'at 3.pm',  
# 'on 2005-05-18') yet.
# It would also be nice to handle +Runt+ objects.

## Example
#
#   class MyScheduler < Scheduler
#
#     def schedule
#       at startup do
#         do_my_startup_task
#       end
#
#       at shutdown do
#         do_my_shutdown_task
#       end
#
#       every minute do
#         do_something_frequently
#       end
#
#       every 2.hours do
#         do_something_occasionally
#       end
#
#     end
#
#   end
#
#   sched = MyScheduler.new
#   sched.start
#
#   # or to run it only for one hour...
#
#   sched.start(1.hour)
##


require 'time'
require 'thread'

module Scheduler
  #
  # A +Scheduler+ object keeps track of tasks to be run.  Usual usage  
  # is to subclass Scheduler, and
  # define your own +schedule+ method to set up the schedule.  Once  
  # you've created a new Scheduler
  # object, you can call +start+ to start the schedule running.
  #
  class Scheduler
    # A +Task+ represents something to do after an interval of time  
    # has happened.
    class Task
      # The amount of time to wait until the task will be run.  If  
      # this is set to the symbol
      # +:startup+ or +:shutdown+, the task will be run only once, at  
      # schedule startup or shutdown, respectively.
      #
      # FIXME: It would be nice if +interval+ could be a +Time+ or  
      #    +Date+ object, or a crontab-like string, or a +Runt::Event+.
      attr_accessor :interval
      
      # A block or Proc object that will be run when the time interval  
      # has passed.
      attr_accessor :proc
      
      # The internal thread that is responsible for actually waiting  
      # the time interval.
      attr_accessor :thread
      
      # Create a new task.  If supplied, +interval+ and +proc+  
      # correspond to their respective methods.
      
      def initialize(interval=nil, proc=nil)
        self.interval = interval
        self.proc = proc
        self.thread = nil
      end
      
      # Run the block or Proc associated with a task.
      def run
        self.proc.call
      end
      
      # Schedule the task.  This actually starts a thread that waits  
      # until the specified time interval has passed, then adds the
      # task to a run queue that the main +Scheduler+ object waits on.
      def schedule(scheduler)
        case self.interval
        when :startup, :shutdown
          # ignore it
        else
          self.thread = Thread.new do
            loop do
              sleep self.interval
              scheduler.run_queue << self
            end
          end
         self.thread.abort_on_exception = true
        end
      end
      
    end
    
    # The list of all tasks in the schedule, including startup and  
    # shutdown tasks.
    attr_accessor :tasks
    
    # The run-queue, representing all the tasks whose interval has  
    # passed, and should be run.
    attr_accessor :run_queue
    
    # Create a new schedule.  The object's +#schedule+ method, if any,  
    # will be called to create the schedule.  Note that the schedule's
    # +#run+ method must be called to get actually start the schedule.
    def initialize
      self.tasks = Array.new
      self.run_queue = Queue.new
      self.schedule
    end
    
    # Add a task to the schedule.  If +interval+ is a number (Fixnum  
    # or Float), it represents the  number of seconds to wait between
    # successive runs of the task. If +interval+ is a Time or Date
    # object, the task will be run once at the specified time
    def add_task(interval, &block)
      tasks << Task.new(interval, block)
    end
    
    # Return all tasks that should be run at startup.
    def startup_tasks
      self.tasks.select { |t| t.interval == :startup }
    end
    
    # Return all tasks that should be run at shutdown.
    def shutdown_tasks
      self.tasks.select { |t| t.interval == :shutdown }
    end
    
    # Return all tasks that should be scheduled.
    def scheduled_tasks
      self.tasks.select { 
        |t| t.interval != :startup && t.interval != :shutdown
      }
    end
    
    # Various helpful aliases that encourage readable schedules.
    def second;   1.second;   end
    def minute;   1.minute;   end
    def hour;     1.hour;     end
    def day;      1.day;      end
    
    def startup;  :startup;   end
    def shutdown; :shutdown;  end
    
    alias every add_task
    alias at    every
    alias on    every
    
    # Set up schedules.  This method should be implemented by a  
    # subclass of Scheduler.
    def schedule
      # implemented by subclass
    end
    
    # Start a schedule.  If +period+ is supplied, the schedule will  
    # only run for that many seconds.  Otherwise, it will run forever, or until there  
    # are no tasks to run.
    def start(period=nil)
      # Run any startup tasks.
      self.startup_tasks.each { |t| t.run }
      
      # If caller only wants to run for a while, start a thread that will
      # sleep that long, then kill off all the threads.  +nil+ is posted to
      # the queue as a signal that the scheduler should stop running.
      if period
        Thread.new do
          Thread.abort_on_exception = true
          sleep period
          self.scheduled_tasks.each {
            |t| t.thread.exit if t.thread && t.thread.alive? }
          self.run_queue << nil
        end
      end
      
      # Schedule all the tasks.
      self.scheduled_tasks.each { |t| t.schedule(self) }
      
      # Run any tasks whose threads have placed the task onto the run  
      # queue, until +nil+ is received.
      while (task = self.run_queue.pop) do
        task.run
      end
      
      # Run any shutdown tasks.
      self.shutdown_tasks.each { |t| t.run }
    end
  end 
end
