//
//  TodoCell.m
//  TodoApp
//
//  Created by Jerry on 14/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "TodoCell.h"

@implementation TodoCell

@synthesize iconTouchDelegate;
@synthesize lbText, imgPriority;
@synthesize completed = _completed;
@synthesize indexPath;

- (void)initialize {

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint location = [((UITouch*)[touches anyObject]) locationInView:self];
    if (CGRectContainsPoint(self.imgPriority.frame, location)) {
        [self togglePriorityImage];
        [self.iconTouchDelegate todoCellPriorityImageTouch:self indexPath:self.indexPath];
        return;
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void) setPriority:(NSInteger)priority {
    _priority = priority;
    [self setPriorityImage];
}

- (void) setPriorityImage {
    if (_completed) {
        self.imgPriority.image = [UIImage imageNamed:@"checkbox_tick.png"];
    }
    else {
        switch (_priority) {
            case 1:
                self.imgPriority.image = [UIImage imageNamed:@"checkbox_red.png"];
                break;
            case 2:
                self.imgPriority.image = [UIImage imageNamed:@"checkbox_yellow.png"];
                break;
            case 3:
                self.imgPriority.image = [UIImage imageNamed:@"checkbox_green.png"];
                break;
        
            default:
                break;
        }
    }
}

- (void) setCompleted:(BOOL) completed {
    _completed = completed;
}

- (void) togglePriorityImage {
    
    _completed = !_completed;
    [self setPriorityImage];
}

@end
