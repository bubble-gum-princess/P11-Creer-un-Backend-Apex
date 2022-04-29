global class CreateTasksScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        database.executebatch(new CreateTasks());
    }
}
