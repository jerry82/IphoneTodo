//
//  AppDelegate.h
//  TodoApp
//
//  Created by Jerry on 14/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "FMDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableArray *todoList;
    FMDatabase *db;
    NSString* dbPath;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSMutableArray *todoList;

@end
