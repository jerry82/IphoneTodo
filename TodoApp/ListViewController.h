//
//  ListViewController.h
//  TodoApp
//
//  Created by Jerry on 13/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "ListItem.h"
#import "AddListViewController.h"

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController <AddListDoneDelegate>

@property (nonatomic, retain) NSMutableArray* allLists;

@end
