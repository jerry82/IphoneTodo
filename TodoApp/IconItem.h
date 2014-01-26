//
//  IconItem.h
//  TodoApp
//
//  Created by Jerry on 16/5/13.
//  Copyright (c) 2013 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconItem : NSObject

@property (nonatomic, assign) NSInteger primaryKey;
@property (nonatomic, retain) NSString* iconName;
@property (nonatomic, retain) NSString* iconFile;

@end
