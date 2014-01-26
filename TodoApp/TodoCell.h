//
//  TodoCell.h
//  TodoApp
//
//  Created by Jerry on 14/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskItem.h"

@class TodoCell;
@protocol TodoCellIconTouchDelegate<NSObject>
-(void)todoCellPriorityImageTouch: (TodoCell*) cell indexPath: (NSIndexPath*) path;
@end


@interface TodoCell : UITableViewCell {
    NSInteger _priority;
}

@property (weak, nonatomic) id<TodoCellIconTouchDelegate> iconTouchDelegate;

//@property (strong, nonatomic) IBOutlet UILabel *lbPriority;

@property (strong, nonatomic) IBOutlet UILabel *lbText;

@property (strong, nonatomic) IBOutlet UIImageView *imgPriority;

@property (assign, nonatomic) BOOL completed;

@property (retain, nonatomic) NSIndexPath *indexPath;

- (void) setPriority : (NSInteger)priority;

- (void) setCompleted:(BOOL)completed;

- (void) togglePriorityImage;

@end
