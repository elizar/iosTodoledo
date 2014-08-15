//
//  Todo.h
//  todo
//
//  Created by Elizar Pepino on 8/14/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Todo : NSObject

@property (nonatomic, assign) NSInteger uniqueId;
@property (nonatomic, copy) NSString *title;
@property BOOL done;
@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, copy) NSDate *dateUpdated;
@end
