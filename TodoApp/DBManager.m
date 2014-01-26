

//
//  DBManager.m
//  TodoApp
//
//  Created by Jerry on 17/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

NSString* DatabasePath;

@implementation DBManager

//---singleton pattern--------------------------------------------
+(id) sharedInstance {
    
    static dispatch_once_t pred;
    
    static DBManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[DBManager alloc]initWithPath];
    });
    
    return sharedInstance;
}

- (id) initWithPath {
    
    if (self = [super init]) {
        
        NSLog(@"%d", DatabasePath.length);
        
        if ([DatabasePath length] == 0)
            NSLog(@"DatabasePath is not set");
        else
            db = [FMDatabase databaseWithPath:DatabasePath];
    }
    
    return self;
}

//--- [list] --------------------------------------------
- (NSMutableArray *) getAllLists {
    
    NSMutableArray *lists = [[NSMutableArray alloc]init];
    
    if (![db open]) {
        NSLog(@"db failed to open");
        return nil;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT list.id, list.title, list.description, list.iconId, icon.filename, icon.name FROM list, icon WHERE list.iconId = icon.id"];

    while ([rs next]) {
        ListItem *item = [[ListItem alloc] init];
        IconItem* icon = [[IconItem alloc] init];
        
        item.primaryKey = [rs intForColumn:@"id"];
        item.title = [rs stringForColumn:@"title"];
        item.description = [rs stringForColumn:@"description"];
        
        icon.primaryKey = [rs intForColumn:@"iconId"];
        icon.iconFile = [rs stringForColumn:@"filename"];
        icon.iconName = [rs stringForColumn:@"name"];
        
        item.iconItem = icon;
        
        [lists addObject:item];
    }
    
    [db close];
    
    return lists;
}

- (void) insertList : (ListItem*) item {
    if (![db open]) {
        NSLog(@"db failed to open");
        return;
    }
    
    if ([db executeUpdate:@"INSERT INTO list(title, description, iconId) VALUES (?, ?, ?)",
         item.title,
         item.description,
         [NSNumber numberWithInt:item.iconItem.primaryKey]])
        NSLog(@"insert list done.");
    else
        NSLog(@"insert list failed.");
    
    [db close];
}

- (BOOL) deleteList:(NSInteger)listId {
    BOOL success = NO;
    
    if (![db open]) {
        NSLog(@"db failed to open");
        return NO;
    }
    
    success = [db executeUpdate:@"DELETE FROM task WHERE listId = ?",
               [NSNumber numberWithInt:listId]];
    success = [db executeUpdate:@"DELETE FROM list WHERE id = ?",
               [NSNumber numberWithInt:listId]];
    
    [db close];
    
    return success;
}

- (void) updateList : (ListItem*) item {
    
    if (![db open]) {
        NSLog(@"db failed to open");
        return;
    }
    
    if ([db executeUpdate:@"UPDATE list SET title=?, description=?, iconId = ? WHERE id=?",
         item.title,
         item.description,
         [NSNumber numberWithInt:item.iconItem.primaryKey],
         [NSNumber numberWithInt:item.primaryKey]])
        NSLog(@"update done");
    else
        NSLog(@"update failed");
    
    [db close];
}

//--- [task] --------------------------------------------
- (NSMutableArray *) getAllTasksByListId : (NSInteger) listId {
   
    NSMutableArray *tasks = [[NSMutableArray alloc]init];
    
    if (![db open]) {
        NSLog(@"db failed to open");
        return nil;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM task where listId = ?", [NSNumber numberWithInt:listId]];
    
    NSLog(@"listid: %d", listId);
    
    while ([rs next]) {
        TaskItem *item = [[TaskItem alloc]init];
        item.primaryKey = [rs intForColumn:@"id"];
        item.title = [rs stringForColumn:@"title"];
        item.priority = [rs intForColumn:@"priority"];
        item.isCompleted = [rs boolForColumn:@"completed"];
        
        [tasks addObject:item];
    }
    
    [db close];
    
    return tasks;
}

- (void) insertTodo : (TaskItem *) item  withListId:(NSInteger)listId {
    if (item != nil) {
        if (![db open]) {
            NSLog(@"db failed to open");
            return;
        }
                
        if ([db executeUpdate:@"INSERT INTO task(title, description, priority, completed, listId) VALUES (?, ?, ?, ?, ?)",
             item.title,
             item.description,
             [NSNumber numberWithInt:item.priority],
             [NSNumber numberWithBool:item.isCompleted],
             [NSNumber numberWithInt:listId]])
            
            NSLog(@"insert done");
        else
            NSLog(@"insert failed");
        
        [db close];
    }
}

- (BOOL) deleteTodo : (int) pk {

    BOOL success = false;
    
    if (![db open]) {
        return false;
    }
    
    if ([db executeUpdate:@"DELETE FROM task WHERE id = ?",
         [NSNumber numberWithInt:pk]]) {
        NSLog(@"delete done");
        success = true;
    }
    else
        NSLog(@"delete failed");
    
    [db close];
    
    return success;
}

- (void) updateTodo : (TaskItem *) item {
    
    if (![db open]) {
        return;
    }
 
    if ([db executeUpdate:@"UPDATE task SET title=?, description=?, priority=?, completed=? WHERE id=?",
         item.title,
         item.description,
         [NSNumber numberWithInt:item.priority],
         [NSNumber numberWithBool:item.isCompleted],
         [NSNumber numberWithInt:item.primaryKey]])
        
        NSLog(@"update done");
    else
        NSLog(@"update failed");
    
    [db close];
}

//---[icon]---
#pragma mark icon
- (NSMutableArray*) getAllIcons {
    
    if (![db open]) {
        return nil;
    }
    
    NSMutableArray* icons = [[NSMutableArray alloc] init];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM icon"];
    
    while ([rs next]) {
        IconItem *item = [[IconItem alloc] init];
        item.primaryKey = [rs intForColumn:@"id"];
        item.iconFile = [rs stringForColumn:@"filename"];
        item.iconName = [rs stringForColumn:@"name"];
        
        [icons addObject:item];
    }
    
    [db close];
    return icons;
}

- (IconItem*) getIcon : (NSInteger) iconId {
    
    if (![db open]) {
        return nil;
    }
    
    IconItem* item = [[IconItem alloc] init];
    FMResultSet* rs = [db executeQuery:@"SELECT * FROM icon WHERE id = ?", [NSNumber numberWithInt:iconId]];
    while ([rs next]) {
        item.primaryKey = [rs intForColumn:@"id"];
        item.iconFile = [rs stringForColumn:@"filename"];
        item.iconName = [rs stringForColumn:@"name"];
    }
    
    [db close];
    
    return item;
}

@end
