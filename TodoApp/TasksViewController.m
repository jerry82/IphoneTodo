//
//  TodoListViewController.m
//  TodoApp
//
//  Created by Jerry on 14/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "TasksViewController.h"
#import "AppDelegate.h"
#import "TaskItem.h"
#import "TodoCell.h"
#import "AddTaskViewController.h"
#import "DBManager.h"

@implementation TasksViewController

@synthesize listId = _listId;

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//---display table view---------------------------------------
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 1)
        return @"Completed";
    else
        return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return _allTasks.count;
    if (section == 0) {
        return _undoneTasks.count;
    }
    else {
        return _completedTasks.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TodoItem";
    
    TodoCell *cell = (TodoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.iconTouchDelegate = self;
    cell.indexPath = indexPath;
    
    TaskItem *item;
    
    if (indexPath.section == 0) {
        item = [_undoneTasks objectAtIndex:indexPath.row];
    }
    else {
        item = [_completedTasks objectAtIndex:indexPath.row];
    }

    [cell setCompleted:item.isCompleted];
    [cell setPriority:item.priority];    
    cell.lbText.text = item.title;
    
    /*
    if (item.isCompleted == YES) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    */
    
    return cell;
}

#pragma mark delete cell
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TaskItem* item;
        if (indexPath.section == 0) {
            item = [_undoneTasks objectAtIndex:indexPath.row];
        }
        else {
            item = [_completedTasks objectAtIndex:indexPath.row];
        }
        
        int pk = item.primaryKey;
        
        if ([[DBManager sharedInstance] deleteTodo:pk]) {
            
            if (indexPath.section == 0)
                [_undoneTasks removeObjectAtIndex:indexPath.row];
            else
                [_completedTasks removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        }
    }
}

//---segue code---------------------------------------
#pragma mark segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navController = segue.destinationViewController;
    AddTaskViewController* atvController = [[navController viewControllers] objectAtIndex:0];
    atvController.delegate = self;
    
    if ([segue.identifier isEqualToString:@"AddTask"]) {
        atvController.editItem = nil;
    }
    else if ([segue.identifier isEqualToString:@"EditTask"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        TaskItem *item;
        if (indexPath.section == 0)
            item = [_undoneTasks objectAtIndex:indexPath.row];
        else
            item = [_completedTasks objectAtIndex:indexPath.row];
        
        atvController.editItem = item;
    }
}

//---helpers---------------------------------------
#pragma mark - Helpers
- (void) refreshTaskList {
    
    [self setAllTasks: [[DBManager sharedInstance] getAllTasksByListId:self.listId]];
    [self.tableView reloadData];
}

#pragma mark task retrival 
- (void) setAllTasks:(NSMutableArray *)tasks {
    _allTasks = tasks;
    
    if (_undoneTasks == nil) _undoneTasks = [[NSMutableArray alloc] init];
    if (_completedTasks == nil) _completedTasks = [[NSMutableArray alloc] init];
    
    [_undoneTasks removeAllObjects];
    [_completedTasks removeAllObjects];
    
    for (TaskItem* item in _allTasks) {
        if (item.isCompleted) {
            [_completedTasks addObject:item];
        }
        else {
            [_undoneTasks addObject:item];
        }
    }
}


//---delegate calls from AddTaskViewController---------------------------------------
#pragma mark AddTaskViewController Delegate
- (void) addTaskViewController:(AddTaskViewController *)controller addDone:(TaskItem *)item {
    
    if (item.title.length == 0) return;
    
    if (controller.editItem == nil)
        [[DBManager sharedInstance]insertTodo:item withListId:self.listId];
    else
        [[DBManager sharedInstance]updateTodo:item];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self refreshTaskList];
}

- (void) addTaskViewControllerDidCancel:(AddTaskViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//TODO: make the cell appears/disappears nicer
#pragma mark TodoCell Delegate
- (void) todoCellPriorityImageTouch:(TodoCell *)cell indexPath:(NSIndexPath *)path {
    
    TaskItem* item;
    if (path.section == 0) {
        item = [_undoneTasks objectAtIndex:path.row];        
        [item setIsCompleted:YES];
        [[DBManager sharedInstance] updateTodo:item];
        [self refreshTaskList];
    }
    else {
        item = [_completedTasks objectAtIndex:path.row];
        [item setIsCompleted:NO];
        [[DBManager sharedInstance] updateTodo:item];
        [self refreshTaskList];
    }
    
    /*
    if (path.section == 0) {
        
        item = [_undoneTasks objectAtIndex:path.row];
        NSLog(@"you clicked: %@", item.text);
        
        [_undoneTasks removeObjectAtIndex:path.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:YES];
        
        [_completedTasks insertObject:item atIndex:0];
        NSArray* insertPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];
        [self.tableView insertRowsAtIndexPaths:insertPath withRowAnimation:YES];

    }
    else {
     
        item = [_completedTasks objectAtIndex:path.row];
        NSLog(@"you clicked: %@", item.text);
        
        [_completedTasks removeObjectAtIndex:path.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:YES];
        
        [_undoneTasks insertObject:item atIndex:0];
        NSArray* insertPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.tableView insertRowsAtIndexPaths:insertPath withRowAnimation:YES];
    }
    */
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
