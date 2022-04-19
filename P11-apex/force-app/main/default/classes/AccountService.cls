public with sharing class AccountService {

    public static void createNewTask (List<Account> accounts){
        List<Task> Tasks = new List<Task>();
		for(Account a : accounts){
            Task newTask = new Task();
            newTask.WhatId = a.Id;
            newTask.Subject = 'Call';
            newTask.Priority = 'Normale';
            newTask.Status = 'Nouvelle';
            newTask.ReminderDateTime =System.today()+5;
            
            Tasks.add(newTask);
       }


        insert Tasks;
    }
}