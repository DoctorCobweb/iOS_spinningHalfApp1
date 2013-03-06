//
//  DAO.m
//  spinningHalfApp1
//
//  Created by andre trosky on 6/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "DAO.h"


@implementation DAO {
    NSString *docsDir;
    NSArray *dirPaths;
}

@synthesize databasePath;
@synthesize gigGuideDB;

- (NSString *)getDocumentsDirectory {
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    return docsDir;
}

- (void)createDatabaseAndTable{
    //NSString *docsDir = [[NSString alloc] initWithString:[self.getDocumentsDirectory]];
    NSString *mDocsDir = self.getDocumentsDirectory;
    NSLog(@"DAO: mDocsDir = %@", mDocsDir);
    
    
    
    //build the path to the database file
    //it should be located at:
    //"<application_home>/Documents/gigsDB.db"
    databasePath = [[NSString alloc] initWithString:[mDocsDir stringByAppendingPathComponent:@"gigsDB.db"]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ([fileMgr fileExistsAtPath:databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        
        //sqlite3_open will create a database if it doesnt already exist.
        if (sqlite3_open(dbpath, &gigGuideDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS gigsTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUTHOR TEXT, SHOW TEXT, DATE TEXT, VENUE TEXT, DESCRIPTION TEXT, TIXURL TEXT, PRICE TEXT)";
            
            if (sqlite3_exec(gigGuideDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"DAO_ERROR: Failed to create the table.");
                NSLog(@"DAO_ERROR: errMsg: %s", errMsg);
            } else {
            NSLog(@"DAO_SUCCESS: Created database: \"gigsDB.db\" and table \"gigsTABLE\".");
            }
            sqlite3_close(gigGuideDB);
        } else {
            NSLog(@"DAO_ERROR: Failed to open/create database");
        }
    }
}

- (void)saveData
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &gigGuideDB) == SQLITE_OK) {
        NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO gigsTABLE (author, show, date, venue, description, tixurl, price) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", @"TEST_author", @"TEST_show", @"TEST_date", @"TEST_venue", @"TEST_description", @"TEST_tixurl", @"TEST_price"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(gigGuideDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"DAO_SUCCESS: TEST data has been inserted into gigsTABLE.");
        } else {
            NSLog(@"DAO_ERROR: TEST data failed to be inserted.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(gigGuideDB);
    }
}

- (void)getData
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &gigGuideDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT show, date, venue, description, tixurl, price FROM gigsTABLE WHERE author=\"%@\"", @"TEST_author"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(gigGuideDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *showField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *dateField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *venueField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *descriptionField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *tixurlField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *priceField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSLog(@"DAO_SUCCESS: Result matched for query. The first row returned is: show=%@, date=%@, venue=%@, description=%@, tixurl=%@, price=%@", showField, dateField, venueField, descriptionField, tixurlField, priceField);
                
            } else {
                NSLog(@"DAO_ERROR: No result matched from database query");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(gigGuideDB);
    }
}




@end
