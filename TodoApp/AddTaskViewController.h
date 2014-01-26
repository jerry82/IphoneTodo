//
//  AddTaskViewController.h
//  TodoApp
//
//  Created by Jerry on 15/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskItem.h"

@class AddTaskViewController;

@protocol AddTaskViewControllerDelegate <NSObject>
- (void) addTaskViewController : (AddTaskViewController *) controller
                        addDone: (TaskItem *) item;
- (void) addTaskViewControllerDidCancel:(AddTaskViewController *)controller;
@end



@interface AddTaskViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextView *tvDescription;
@property (strong, nonatomic) IBOutlet UISegmentedControl *smPriority;
@property (strong, nonatomic) IBOutlet UISwitch *sStatus;
@property (nonatomic, weak) id <AddTaskViewControllerDelegate> delegate;
@property (nonatomic, strong) TaskItem* editItem;

- (IBAction) addDone : (id) sender;
- (IBAction) cancel : (id) sender;

@end

