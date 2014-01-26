//
//  SelectIconViewController.h
//  TodoApp
//
//  Created by Jerry on 16/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconItem.h"

@protocol SelectIconDelegate <NSObject>
- (void) selectIcon : (IconItem*) item;
@end

@interface SelectIconViewController : UITableViewController

@property (nonatomic, weak) id<SelectIconDelegate> selectIconDelegate;

- (IBAction)doneSelectIcon :(id)sender;

@end
