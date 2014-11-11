//
//  EditTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Nicholas Wakeford on 11/8/14.
//  Copyright (c) 2014 Nicholas Henry Dean Wakeford. All rights reserved.
//

#import "EditTaskViewController.h"

@interface EditTaskViewController ()

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskTextField.delegate = self;
    self.detailTextView.delegate = self;
    
    self.taskTextField.text = self.taskObjectFromSender.title;
    self.detailTextView.text = self.taskObjectFromSender.details;
    self.datePicker.date = self.taskObjectFromSender.date;
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

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    self.taskObjectFromSender.title = self.taskTextField.text;
    self.taskObjectFromSender.details = self.detailTextView.text;
    self.taskObjectFromSender.date = self.datePicker.date;
    
    [self.delegate didSaveTask];
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
