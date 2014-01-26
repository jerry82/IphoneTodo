//
//  ListViewController.m
//  TodoApp
//
//  Created by Jerry on 13/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "ListViewController.h"
#import "TasksViewController.h"
#import "AddListViewController.h"
#import "ListCell.h"
#import "DBManager.h"

@interface ListViewController () {
    ListItem* _editingItem;
    ListItem* _selectedItem;
}

@end

@implementation ListViewController

@synthesize allLists = _allLists;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _allLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = (ListCell*) [tableView dequeueReusableCellWithIdentifier:@"ListItem" forIndexPath:indexPath];
    ListItem *item = [_allLists objectAtIndex:indexPath.row];
    
    cell.lbTitle.text = item.title;
    //cell.imgListIcon.image = [UIImage imageNamed:item.iconFileName];
    NSLog(@"icon: %@", item.iconItem.iconFile);

    
    cell.imgListIcon.image = [UIImage imageNamed:item.iconItem.iconFile];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell* cell = (ListCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEditing] == YES) {
        NSLog(@"editing mode");
        _editingItem = [[ListItem alloc] init];
        _editingItem = [_allLists objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"EditListSegue" sender:self];
    }
    else {
        NSLog(@"select mode");
        _selectedItem = [[ListItem alloc] init];
        _selectedItem = [_allLists objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"TasksSegue" sender:self];
    }
}

#pragma mark delete cell
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ListItem* item = [_allLists objectAtIndex:indexPath.row];
        int pk = item.primaryKey;
        
        if ([[DBManager sharedInstance] deleteList:pk]) {
            [_allLists removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        }
    }
}

#pragma mark segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"TasksSegue"]) {
        
        TasksViewController *tvController = segue.destinationViewController;
    
        NSMutableArray* tasks = [[DBManager sharedInstance] getAllTasksByListId:_selectedItem.primaryKey];
        [tvController setAllTasks:tasks];
        tvController.listId = _selectedItem.primaryKey;
        tvController.title = _selectedItem.title;
    }
    
    else if ([segue.identifier isEqualToString:@"AddListSegue"]) {
        
        AddListViewController *alvController = segue.destinationViewController;
        alvController.delegate = self;
    }
    
    else if ([segue.identifier isEqualToString:@"EditListSegue"]) {
        AddListViewController *elvController = segue.destinationViewController;
        elvController.editingListItem = _editingItem;
        elvController.delegate = self;
    }
}

#pragma mark - delegates
- (void) addListDone {
    
    [self.navigationController popViewControllerAnimated:YES];

    _allLists = [[DBManager sharedInstance] getAllLists];
    [self.tableView reloadData];
}


@end
