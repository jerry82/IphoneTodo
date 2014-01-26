//
//  Todo.h
//  TodoApp
//
//  Created by Jerry on 14/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface TaskItem : NSObject {
}

@property (nonatomic, assign) NSInteger primaryKey;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) BOOL isCompleted;

@end
