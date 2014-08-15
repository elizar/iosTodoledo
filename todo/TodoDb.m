//
//  TodoDb.m
//  todo
//
//  Created by Elizar Pepino on 8/15/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import "TodoDb.h"

@implementation TodoDb

static TodoDb *_database;

- (id)init {
    if ((self = [super init])) {
        NSLog(@"");
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"todoledo"
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    NSLog(@"%@", [[NSDate date] description]);
    return self;
}

+ (TodoDb *)database {
    if (_database == nil) {
        _database = [[TodoDb alloc] init];
    }
    return _database;
}

- (NSArray *)todoDbInfos {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT id, title, done, dateCreated, dateUpdated FROM todo ORDER BY id ASC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *titleChar = (char *) sqlite3_column_text(statement, 1);
            int doneInt = sqlite3_column_int(statement, 2);
            char *dateCreatedChar = (char *) sqlite3_column_text(statement, 3);
            char *dateUpdatedChar = (char *) sqlite3_column_text(statement, 4);
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-mm-dd hh:mm:ss Z"];
            // convertions
            BOOL done = doneInt;
            NSString *title = [[NSString alloc] initWithUTF8String:titleChar];
            NSString *dateCreated = [[NSString alloc] initWithUTF8String:dateCreatedChar];
            NSString *dateUpdated = [[NSString alloc] initWithUTF8String:dateUpdatedChar];
            Todo *todo = [[Todo alloc]init];
            todo.title = title;
            todo.uniqueId = uniqueId;
            todo.done = done;
            todo.dateCreated = (NSDate *) [df dateFromString:dateCreated];
            todo.dateUpdated = (NSDate *) [df dateFromString:dateUpdated];
            
            [retval addObject:todo];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}
@end
