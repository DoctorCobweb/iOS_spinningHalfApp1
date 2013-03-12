//
//  DAO.m
//  spinningHalfApp1
//
//  Created by andre trosky on 6/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "DAO.h"
#import "Gig.h"


@implementation DAO {
    NSString *docsDir;
    NSArray *dirPaths;
}

@synthesize databasePath;
@synthesize gigGuideDB;
@synthesize finishedSavingToDatabase;

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


- (BOOL)clearGigsTable{
    NSString *mDocsDir = self.getDocumentsDirectory;
    //NSLog(@"DAO: mDocsDir = %@", mDocsDir);
    
    
    
    //build the path to the database file
    //it should be located at:
    //"<application_home>/Documents/gigsDB.db"
    databasePath = [[NSString alloc] initWithString:[mDocsDir stringByAppendingPathComponent:@"gigsDB.db"]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    const char *dbpath = [databasePath UTF8String];
    if ([fileMgr fileExistsAtPath:databasePath] == YES) {
        
        
        //sqlite3_open will create a database if it doesnt already exist.
        if (sqlite3_open(dbpath, &gigGuideDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "DELETE FROM gigsTABLE";
            
            if (sqlite3_exec(gigGuideDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"DAO_ERROR: Failed to delete all rows in gigsTABLE");
                NSLog(@"DAO_ERROR: errMsg: %s", errMsg);
                return NO;
            } else {
                NSLog(@"DAO_SUCCESS: Deleted all rows from table \"gigsTABLE\".");
            }
            sqlite3_close(gigGuideDB);
            return YES;
        } else {
            NSLog(@"DAO_ERROR: Failed to open/create database");
            return NO;
        }
    }
    
    NSLog(@"There doesnt seem to be a database called gigsDB.db here");
    return YES;
}

- (void)saveData:(NSMutableArray *)gigsArray
{
    finishedSavingToDatabase = NO;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    /*
    //variable used in for-loop below.
    int i = 0;
    NSLog(@"----------------------------------\n");
    
    for (Gig *_dummyGig in gigsArray){
        NSLog(@"DAO: SAVEDATA: gigsArray CONTENT: Gig(%d): %@\n, %@\n, %@\n, %@\n, %@\n, %@\n, %@\n",
              i,
              _dummyGig.author,
              _dummyGig.show,
              _dummyGig.date,
              _dummyGig.venue,
              _dummyGig.description,
              _dummyGig.tixUrl,
              _dummyGig.price);
        i++;
        NSLog(@"----------------------------------\n");
    }
     */

    int countOfGigs = [gigsArray count];
    
    if (sqlite3_open(dbpath, &gigGuideDB) == SQLITE_OK) {
        
        
        for (int j = 0; j < countOfGigs; j++) {
            Gig *tmp_gig = [gigsArray objectAtIndex:j];
            
            NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO gigsTABLE (author, show, date, venue, description, tixurl, price) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", tmp_gig.author, tmp_gig.show, tmp_gig.date, tmp_gig.venue, tmp_gig.description, tmp_gig.tixUrl, tmp_gig.price];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(gigGuideDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"DAO_SUCCESS: TEST data has been inserted into gigsTABLE.");
            } else {
                NSLog(@"DAO_ERROR: TEST data failed to be inserted.");
            }
            //this deletes the prepared statement. needed to
            //avoid memory leaks.
            sqlite3_finalize(statement);
        }
        sqlite3_close(gigGuideDB);
    }
    finishedSavingToDatabase = YES;
}


//THIS SHOULD RETURN AN NSArray of gigs from the query
- (NSMutableArray *)getAllGigs
{
    NSMutableArray *gigs = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    int i = 0;
    
    if (sqlite3_open(dbpath, &gigGuideDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM gigsTABLE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(gigGuideDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            /*
            if (sqlite3_step(statement) != SQLITE_ROW) {
                NSLog(@"DAO_ERROR: No result matched from database query");
            }
             */
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *primaryIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *authorField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *showField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *dateField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *venueField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                NSString *descriptionField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                NSString *tixUrlField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                
                NSString *priceField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                
                NSLog(@"DAO_QUERY_RESULT: Result matched for query. The row[%d] returned is: primaryId=%@, author=%@, show=%@, date=%@, venue=%@, description=%@, tixurl=%@, price=%@", i, primaryIdField, authorField, showField, dateField, venueField, descriptionField, tixUrlField, priceField);
                
                Gig *_tmpGig = [Gig new];
                _tmpGig.primaryId = primaryIdField;
                _tmpGig.author = authorField;
                _tmpGig.show = showField;
                _tmpGig.date = dateField;
                _tmpGig.venue = venueField;
                _tmpGig.description = descriptionField;
                _tmpGig.tixUrl = tixUrlField;
                _tmpGig.price = priceField;
                
                [gigs addObject:_tmpGig];
                
                i++;
            }
            
            if (i == 0) {
                NSLog(@"No results were match for the query.");
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(gigGuideDB);
    }
return gigs;

}

@end