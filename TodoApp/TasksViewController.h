//
//  TodoListViewController.h
//  TodoApp
//
//  Created by Jerry on 14/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoCell.h"
#import "AddTaskViewController.h"

@interface TasksViewController : UITableViewController <AddTaskViewControllerDelegate, TodoCellIconTouchDelegate> {
    NSMutableArray* _allTasks;
    NSMutableArray* _undoneTasks;
    NSMutableArray* _completedTasks;
}

@property (nonatomic, assign) NSInteger listId;

//@property (nonatomic, strong) NSMutableArray *allTasks;
- (void) setAllTasks: (NSMutableArray*) allTasks;

@end
