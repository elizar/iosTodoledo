//
//  TodoDb.m
//  todo
//
//  Created by Elizar Pepino on 8/15/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import "TodoDb.h"

@interface TodoDb () {
    sqlite3_stmt *_statement;
}
- (BOOL)isDatabaseOpened;
@end

@implementation TodoDb

static TodoDb *_database;

- (id)init {
    if ((self = [super init])) {
        if ([self isDatabaseOpened]) {
            // Create `todo` table if not exist
            NSString *query = @"CREATE TABLE if NOT EXISTS todo (id integer primary key, title text, done int, dateCreated text, dateUpdated text)";
            const char *query_statement = [query UTF8String];
            char *errorMsg;
            if (sqlite3_exec(_database, query_statement, NULL, NULL, &errorMsg) != SQLITE_OK) {
                NSLog(@"DB Error: %s", errorMsg);
            } else {
                NSLog(@"Table `todo` successfully created!");
            }
            sqlite3_close(_database);
        }
    }
    return self;
}

+ (TodoDb *)database {
    if (_database == nil) {
        _database = [[TodoDb alloc] init];
    }
    return _database;
}

#pragma mark - DB Methods

// open a db connection to sqlite
// and then returns YES if successful or NO if query fails
- (BOOL)isDatabaseOpened
{
    BOOL isOpened = YES;
    // get the App's document dir
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // append file name
    NSString *sqLiteDb = [docPath stringByAppendingString:@"todoledo.db"];
    // get the file from path, or create one if it does not exist
    if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
        isOpened = NO;
        NSLog(@"DB Error: %s", sqlite3_errmsg(_database));
    }
    
    return isOpened;
}

- (NSArray *)all {
    
    if (![self isDatabaseOpened]) {
        return @[];
    }
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT id, title, done, dateCreated, dateUpdated FROM todo ORDER BY id DESC";
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &_statement, nil) == SQLITE_OK) {
        while (sqlite3_step(_statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(_statement, 0);
            char *titleChar = (char *) sqlite3_column_text(_statement, 1);
            int doneInt = sqlite3_column_int(_statement, 2);
            char *dateCreatedChar = (char *) sqlite3_column_text(_statement, 3);
            char *dateUpdatedChar = (char *) sqlite3_column_text(_statement, 4);
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
            
            [results addObject:todo];
        }
        sqlite3_finalize(_statement);
        sqlite3_close(_database);
    }
    return results;
}

- (BOOL)insertNewTodoWithTitle:(NSString *)title
{
    if (![self isDatabaseOpened]) {
        return NO;
    }
    
    BOOL result = YES;
    
    NSString *today = [[NSDate date] description];
    
    NSString *query = [NSString stringWithFormat:@"insert into todo (title, dateCreated, dateUpdated) values (\"%@\", \"%@\", \"%@\")", title, today, today];
    const char *qs = [query UTF8String];
    char *errorMsg;
    
    if (sqlite3_exec(_database, qs, NULL, NULL, &errorMsg) != SQLITE_OK) {
        result = NO;
        NSLog(@"%s", errorMsg);
    }
    
    sqlite3_close(_database);
    return result;
}

@end
