//
//  AddListViewController.m
//  TodoApp
//
//  Created by Jerry on 14/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "AddListViewController.h"

@interface AddListViewController ()

@end

@implementation AddListViewController

@synthesize imgIcon;
@synthesize lbIconName;
@synthesize delegate;
@synthesize editingListItem;

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
    
    //editing mode
    if ([self editingListItem] != nil) {
        self.tvListName.text = editingListItem.title;
        self.imgIcon.image = [UIImage imageNamed:editingListItem.iconItem.iconFile];
        self.lbIconName.text = editingListItem.iconItem.iconName;
        
        [self createSelectedIconObj:editingListItem.iconItem];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //add back button
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else
        return 1;
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SelectIconSegue"]) {
        //UINavigationController *navController = segue.destinationViewController;
        //SelectIconViewController* siVC = [[navController viewControllers] objectAtIndex:0];
        SelectIconViewController* siVC = (SelectIconViewController*) segue.destinationViewController;
        siVC.selectIconDelegate = self;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//---control helpers---------------------------------------
#pragma mark helpers
- (BOOL) textView: (UITextView *) tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [tv resignFirstResponder];
        return FALSE;
    }
    
    return TRUE;
}

#pragma mark - Buttons
- (IBAction) doneAddList:(id)sender {
    
    NSString* listname = [self.tvListName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (listname.length == 0) {
        [self alert:@"Warning" withMessage:@"Please enter List Name !"];
        return;
    }
    
    //ask user to select icon
    if (_selectedIcon == nil) {
        [self alert:@"Warning" withMessage:@"Please Select Icon"];
        return;
    }
    
    ListItem* item = [[ListItem alloc] init];
    item.title = listname;
    item.description = listname;
    item.primaryKey = editingListItem.primaryKey;
        
    item.iconItem = [[IconItem alloc] init];
    item.iconItem = _selectedIcon;
        
    if ([self editingListItem] == nil) {
        [[DBManager sharedInstance] insertList:item];
    }
    else {
        [[DBManager sharedInstance] updateList:item];
    }
            
    [self.delegate addListDone];
}

#pragma mark - helpers
- (void) createSelectedIconObj : (IconItem*) item {
    if (_selectedIcon == nil)
        _selectedIcon = [[IconItem alloc] init];
    
    _selectedIcon.primaryKey = item.primaryKey;
    _selectedIcon.iconName = item.iconName;
    _selectedIcon.iconFile = item.iconFile;
}

- (void) alert: (NSString*)title withMessage: (NSString*)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: title
                                                    message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Select Icon Delegate
- (void) selectIcon:(IconItem *)item {
    self.imgIcon.image = [UIImage imageNamed:item.iconFile];
    self.lbIconName.text = item.iconName;
    
    [self createSelectedIconObj:item];
    
    //[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setImgIcon:nil];
    [self setLbIconName:nil];
    [self setTvListName:nil];
    [super viewDidUnload];
}
@end
