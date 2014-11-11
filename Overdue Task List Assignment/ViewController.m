//
//  ViewController.m
//  Overdue Task List Assignment
//
//  Created by Nicholas Wakeford on 11/8/14.
//  Copyright (c) 2014 Nicholas Henry Dean Wakeford. All rights reserved.
//

#import "ViewController.h"
#import "TaskObject.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lazy Instantiation of properties

-(NSMutableArray *)taskObjects {
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc] init];
    }
    return _taskObjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *myTasksAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS];
    for (NSDictionary *dictionary in myTasksAsPropertyLists) {
        TaskObject *task = [self taskObjectForDictionary:dictionary];
        [self.taskObjects addObject:task];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Segue toAddTaskViewController
    if ([segue.destinationViewController isKindOfClass:[AddTaskViewController class]]) {
        AddTaskViewController *nextViewController = segue.destinationViewController;
        nextViewController.delegate = self;
    }
    
    //Segue toDetailTaskViewController
    if ([segue.destinationViewController isKindOfClass:[DetailTaskViewController class]]) {
        DetailTaskViewController *nextViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        TaskObject *selectedTask = self.taskObjects[path.row];
        nextViewController.taskObjectFromSender = selectedTask;
        nextViewController.delegate = self;
    }
}

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender {
    if (self.tableView.editing) self.tableView.editing = NO;
    else self.tableView.editing = YES;
}

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskViewController" sender:sender];
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.taskObjects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        TaskObject *taskObject = self.taskObjects[indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:taskObject.date];
        
        cell.textLabel.text = taskObject.title;
        cell.detailTextLabel.text = stringFromDate;
        
        //Makes cell color red if overdue and yellow if not.
        if ([self isDateGreaterThanDate:[NSDate date] and:taskObject.date]) {
            //sRGB color values devided by 256 to aproximate
            //Red
            cell.backgroundColor = [UIColor colorWithRed:0.999 green:0.3 blue:0.22 alpha:1.0];
        } else {
            //Yellow
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.92 blue:0.05 alpha:1.0];
        }
        //Makes cell color green if completed
        if (taskObject.isComplete) cell.backgroundColor = [UIColor colorWithRed:0.51 green:0.995 blue:0.005 alpha:1.0];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskObject *task = self.taskObjects[indexPath.row];
    [self updateCompletionOfTask:task forIndexPath:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskObjects removeObjectAtIndex:indexPath.row];
         NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS] mutableCopy];
        if (!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
        [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toDetailTaskViewController" sender:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    TaskObject *moveTask = self.taskObjects[sourceIndexPath.row];
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:moveTask atIndex:destinationIndexPath.row];
    [self saveTasks:self.taskObjects];
}

#pragma mark - AddTaskViewControllerDelegate

-(void)didCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(TaskObject *)task {
    [self.taskObjects addObject:task];
    
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS] mutableCopy];
    if (!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
     
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

#pragma mark - DetailTaskViewControllerDelegate

-(void)editSavedTask {
    [self saveTasks:self.taskObjects];
    
    [self.tableView reloadData];
}


#pragma mark - Helper Methods

-(NSDictionary *)taskObjectAsAPropertyList:(TaskObject *)taskObject {
    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title, TASK_DESCRIPTION : taskObject.details, TASK_DATE : taskObject.date, TASK_COMPLETION : [NSNumber numberWithBool:taskObject.isComplete]};
    return dictionary;
}

-(TaskObject *)taskObjectForDictionary:(NSDictionary *)dictionary {
    TaskObject *taskObject = [[TaskObject alloc] initWithData:dictionary];
    return taskObject;
}

-(BOOL)isDateGreaterThanDate:(NSDate *)date and:(NSDate *)dueDate {
    NSTimeInterval currentDate = [date timeIntervalSince1970];
    NSTimeInterval taskDate = [dueDate timeIntervalSince1970];
    if (currentDate > taskDate) return YES;
    else return NO;
}

-(void)updateCompletionOfTask:(TaskObject *)task forIndexPath:(NSIndexPath *)indexPath {
    //Removes the outdated task from NSUserDefaults
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS] mutableCopy];
    if (!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
    
    //Changes the completion status of task
    if (task.isComplete) task.isComplete = NO;
    else task.isComplete = YES;
    
    //Loads the updated task into NSUserDefaults
    [taskObjectsAsPropertyLists insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

-(void)saveTasks:(NSMutableArray *)taskList {
    NSMutableArray *taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    for (TaskObject *task in taskList) {
        [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
