//
//  AddTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Nicholas Wakeford on 11/8/14.
//  Copyright (c) 2014 Nicholas Henry Dean Wakeford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskObject.h"

@protocol AddTaskViewControllerDelegate <NSObject>

@required

-(void)didCancel;
-(void)didAddTask:(TaskObject *)task;

@end

@interface AddTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <AddTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *taskTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
