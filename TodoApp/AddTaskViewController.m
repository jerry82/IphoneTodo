//
//  AddTaskViewController.m
//  TodoApp
//
//  Created by Jerry on 15/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "AddTaskViewController.h"
#import "TaskItem.h"


@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

@synthesize tvDescription, smPriority, sStatus;
@synthesize editItem;
@synthesize delegate;

#pragma mark ViewController code

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//---init---------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tvDescription.editable = YES;
    
    if (editItem == nil) {
        self.title = @"Add Task";
        [self.sStatus setOn:NO];
    }
    else {
        self.title = @"Edit Task";
        self.tvDescription.text = editItem.title;
        self.smPriority.selectedSegmentIndex = editItem.priority - 1;
        self.sStatus.selected = editItem.isCompleted;
        [self.sStatus setOn:editItem.isCompleted];
        
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


//---button actions---------------------------------------
#pragma mark implementation
- (IBAction) addDone : (id) sender {
    
    TaskItem *item = [[TaskItem alloc]init];
    if (editItem != nil) {
        item.primaryKey = editItem.primaryKey;
    }
    item.title = tvDescription.text;
    item.priority = smPriority.selectedSegmentIndex + 1;
    item.isCompleted = sStatus.isOn;
    
    [self.delegate addTaskViewController:self addDone:item];
}

- (IBAction) cancel:(id)sender {
    
    [self.delegate addTaskViewControllerDidCancel:self];
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



@end
