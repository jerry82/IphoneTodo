//
//  AddListViewController.h
//  TodoApp
//
//  Created by Jerry on 14/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconItem.h"
#import "IconCell.h"
#import "SelectIconViewController.h"
#import "DBManager.h"
#import "ListItem.h"

@protocol AddListDoneDelegate <NSObject>
- (void) addListDone;
@end

@interface AddListViewController : UITableViewController <SelectIconDelegate> {
    IconItem* _selectedIcon;
}

@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UILabel *lbIconName;
@property (strong, nonatomic) IBOutlet UITextView *tvListName;
@property (weak, nonatomic) id<AddListDoneDelegate> delegate;

@property (nonatomic, strong) ListItem* editingListItem;

- (IBAction) doneAddList:(id)sender;

@end
