//
//  DetailTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Nicholas Wakeford on 11/8/14.
//  Copyright (c) 2014 Nicholas Henry Dean Wakeford. All rights reserved.
//

#import "DetailTaskViewController.h"

@interface DetailTaskViewController ()

@end

@implementation DetailTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDetailParameters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Segue toEditTaskViewController
    if ([segue.destinationViewController isKindOfClass:[EditTaskViewController class]]) {
        EditTaskViewController *nextViewController = segue.destinationViewController;
        nextViewController.taskObjectFromSender = self.taskObjectFromSender;
        nextViewController.delegate = self;
    }
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toEditTaskViewController" sender:nil];
}

#pragma mark - EditTaskViewControllerDelegate

-(void)didSaveTask {
    [self setDetailParameters];
    [self.delegate editSavedTask];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Methods

-(void)setDetailParameters {
    //Formats the date to be displayed as a string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:self.taskObjectFromSender.date];
    
    self.taskLabel.text = self.taskObjectFromSender.title;
    self.dateLabel.text = stringFromDate;
    self.detailLabel.text = self.taskObjectFromSender.details;
}

@end