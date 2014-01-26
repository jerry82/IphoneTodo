//
//  AppDelegate.m
//  TodoApp
//
//  Created by Jerry on 14/4/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import "AppDelegate.h"
#import "ListItem.h"
#import "DBManager.h"
#import "AppConfig.h"
#import "ListViewController.h"

@interface AppDelegate (Private)

- (void) createCopiedDBIfNeeded;
- (void) initDB;

@end

@implementation AppDelegate

@synthesize window, todoList;

- (void) createCopiedDBIfNeeded {
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *docDir = [paths objectAtIndex:0];
    
    //check and create directory
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:docDir isDirectory:&isDirectory]) {
        NSLog(@"target folder not found. creating folder...");
        NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
        [fileManager createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:attr error:&error];
        if (error) {
            NSLog(@"Error creating document folder: %@",[error localizedDescription]);
            return;
        }
    }
    
    NSString *writePath = [docDir stringByAppendingPathComponent:DATABASE_FILE];
    NSLog(@"writepath: %@", writePath);
    
    success = [fileManager fileExistsAtPath:writePath];
    
    if (success)
        return;
    
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_FILE];
   
    success = [fileManager copyItemAtPath:defaultPath toPath:writePath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Error: failed to copy data file with message '%@'", [error localizedDescription]);
    }
}

- (void) initDB {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    DatabasePath = [documentsDirectory stringByAppendingPathComponent:DATABASE_FILE];
    todoList = [[DBManager sharedInstance] getAllLists];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self createCopiedDBIfNeeded];
    [self initDB];
    
    UINavigationController *navController = (UINavigationController*) self.window.rootViewController;
    //TasksViewController *todoListViewController = (TasksViewController*) [[navController viewControllers] objectAtIndex:0];
    ListViewController *lvController = (ListViewController*) [[navController viewControllers] objectAtIndex:0];
    lvController.allLists = self.todoList;

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
