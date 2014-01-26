//
//  IconCell.m
//  TodoApp
//
//  Created by Jerry on 16/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "IconCell.h"

@implementation IconCell

@synthesize lbIconName;
@synthesize imgIcon;

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

@end
