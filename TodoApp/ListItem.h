//
//  ListItem.h
//  TodoApp
//
//  Created by Jerry on 13/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IconItem.h"

@interface ListItem : NSObject {
}

@property (nonatomic, assign) NSInteger primaryKey;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) IconItem* iconItem;

@end
