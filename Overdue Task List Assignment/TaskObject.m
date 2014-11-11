//
//  TaskObject.m
//  Overdue Task List Assignment
//
//  Created by Nicholas Wakeford on 11/8/14.
//  Copyright (c) 2014 Nicholas Henry Dean Wakeford. All rights reserved.
//

#import "TaskObject.h"

@implementation TaskObject

-(id)init {
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data {
    self = [super init];
    
    self.title = data[TASK_TITLE];
    self.details = data[TASK_DESCRIPTION];
    self.date = data[TASK_DATE];
    self.isComplete = [data[TASK_COMPLETION] boolValue];
    
    return self;
}

@end
