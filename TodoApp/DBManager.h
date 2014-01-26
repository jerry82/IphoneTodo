//
//  DBManager.h
//  TodoApp
//
//  Created by Jerry on 17/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#import "TaskItem.h"
#import "ListItem.h"
#import "IconItem.h"

extern NSString* DatabasePath;

@interface DBManager : NSObject {
    FMDatabase *db;
}

+ (id) sharedInstance;

//---[list]---
- (NSMutableArray *) getAllLists;
- (void) insertList : (ListItem*) item;
- (BOOL) deleteList : (NSInteger) listId;
- (void) updateList : (ListItem*) item;

//---[task]---
- (NSMutableArray *) getAllTasksByListId: (NSInteger) listId;
- (void) insertTodo : (TaskItem *) item withListId : (NSInteger) listId;
- (BOOL) deleteTodo : (int) pk;
- (void) updateTodo : (TaskItem *) item;

//---[icon]---
- (NSMutableArray*) getAllIcons;
- (IconItem*) getIcon : (NSInteger) iconId;

@end
