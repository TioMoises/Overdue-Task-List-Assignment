//
//  AddTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Nicholas Wakeford on 11/8/14.
//  Copyright (c) 2014 Nicholas Henry Dean Wakeford. All rights reserved.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskTextField.delegate = self;
    self.detailTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    [self.delegate didAddTask:[self returnNewTaskObject]];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.delegate didCancel];
}

#pragma mark - Helper Methods

-(TaskObject *)returnNewTaskObject {
    NSDictionary *dictionary = @{TASK_TITLE : self.taskTextField.text, TASK_DESCRIPTION : self.detailTextView.text, TASK_DATE : self.datePicker.date, TASK_COMPLETION : @(NO)};
    TaskObject *taskObject = [[TaskObject alloc] initWithData:dictionary];
    return taskObject;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.taskTextField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.detailTextView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

@end
