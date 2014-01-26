//
//  ListCell.h
//  TodoApp
//
//  Created by Jerry on 13/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgListIcon;

@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

@end
