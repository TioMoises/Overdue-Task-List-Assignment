//
//  EditTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Nicholas Wakeford on 11/8/14.
//  Copyright (c) 2014 Nicholas Henry Dean Wakeford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskObject.h"

@protocol EditTaskViewControlerDelegate <NSObject>

-(void)didSaveTask;

@end

@interface EditTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <EditTaskViewControlerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *taskTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) TaskObject *taskObjectFromSender;

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;

@end
