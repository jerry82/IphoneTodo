//
//  SelectIconViewController.m
//  TodoApp
//
//  Created by Jerry on 16/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "SelectIconViewController.h"
#import "DBManager.h"
#import "IconItem.h"
#import "IconCell.h"

@interface SelectIconViewController () {
    NSMutableArray* _allIcons;
    IconItem* _selectedIcon;
}

@end

@implementation SelectIconViewController

@synthesize selectIconDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _allIcons = [[NSMutableArray alloc] init];
        _selectedIcon = [[IconItem alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _allIcons = [[DBManager sharedInstance] getAllIcons];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _allIcons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IconCell *cell = (IconCell*) [tableView dequeueReusableCellWithIdentifier:@"IconItem" forIndexPath:indexPath];
    IconItem *item = [_allIcons objectAtIndex:indexPath.row];
    
    cell.lbIconName.text = item.iconName;
    cell.imgIcon.image = [UIImage imageNamed:item.iconFile];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //unselect all
    for (int k = 0; k < [tableView numberOfRowsInSection:0]; k++) {
        IconCell* eachCell = (IconCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:k inSection:0]];
        eachCell.accessoryType = UITableViewScrollPositionNone;
    }
    
    IconCell* cell = (IconCell*) [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    _selectedIcon = [_allIcons objectAtIndex:indexPath.row];
}

- (IBAction)doneSelectIcon:(id)sender {
    if (_selectedIcon != nil) {
        NSLog(@"_selectedIcon NOT NIL");
        [self.selectIconDelegate selectIcon:_selectedIcon];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
