//
//  TodoDb.h
//  todo
//
//  Created by Elizar Pepino on 8/15/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Todo.h"

@interface TodoDb : NSObject {
    sqlite3 *_database;
}

+ (TodoDb *)database;
- (NSArray *)todoDbInfos;
@end
