//
//  DAO.m
//  spinningHalfApp1
//
//  Created by andre trosky on 6/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "DAO.h"
#import "Gig.h"
#import "Service.h"


@implementation DAO {
    NSString *docsDir;
    NSArray *dirPaths;
}

@synthesize databasePath;
@synthesize gigGuideDB;
@synthesize servicesDB;
@synthesize finishedSavingToGigsDatabase;
@synthesize finishedSavingToServicesDatabase;
@synthesize gigsTABLEEmpty;
@synthesize servicesTABLEEmpty;

- (NSString *)getDocumentsDirectory {
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    return docsDir;
}

- (void)createGigDatabaseAndTable{
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
            //sqlite3_close(gigGuideDB);
        } else {
            NSLog(@"DAO_ERROR: Failed to open/create gigsDB.db database");
        }
        sqlite3_close(gigGuideDB);
    }
}

- (void)createServicesDatabaseAndTable{
    NSString *mDocsDir = self.getDocumentsDirectory;
    NSLog(@"DAO: mDocsDir = %@", mDocsDir);
    
    
    
    //build the path to the database file
    //it should be located at:
    //"<application_home>/Documents/servicesDB.db"
    databasePath = [[NSString alloc] initWithString:[mDocsDir stringByAppendingPathComponent:@"servicesDB.db"]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if ([fileMgr fileExistsAtPath:databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        
        //sqlite3_open will create a database if it doesnt already exist.
        if (sqlite3_open(dbpath, &servicesDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS servicesTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, INFO_1 TEXT, INFO_2 TEXT,  INFO_3 TEXT)";
            
            if (sqlite3_exec(servicesDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"DAO_ERROR: Failed to create servicesTABLE table.");
                NSLog(@"DAO_ERROR: errMsg: %s", errMsg);
            } else {
                NSLog(@"DAO_SUCCESS: Created database: \"servicesDB.db\" and table \"servicesTABLE\".");
            }
            //sqlite3_close(servicesDB);
        } else {
            NSLog(@"DAO_ERROR: Failed to open/create sevicesDB.db database");
        }
        sqlite3_close(servicesDB);
    }
}

- (BOOL)clearServicesTable{
    servicesTABLEEmpty = NO;
    NSString *mDocsDir = self.getDocumentsDirectory;
    //NSLog(@"DAO: mDocsDir = %@", mDocsDir);
    
    
    
    //build the path to the database file
    //it should be located at:
    //"<application_home>/Documents/gigsDB.db"
    databasePath = [[NSString alloc] initWithString:[mDocsDir stringByAppendingPathComponent:@"servicesDB.db"]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    const char *dbpath = [databasePath UTF8String];
    if ([fileMgr fileExistsAtPath:databasePath] == YES) {
        
        
        //sqlite3_open will create a database if it doesnt already exist.
        if (sqlite3_open(dbpath, &servicesDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "DELETE FROM servicesTABLE";
            
            if (sqlite3_exec(servicesDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"DAO_ERROR: Failed to delete all rows in servicesTABLE");
                NSLog(@"DAO_ERROR: errMsg: %s", errMsg);
                
                sqlite3_close(servicesDB);
                return NO;
            } else {
                NSLog(@"DAO_SUCCESS: Deleted all rows from table \"servicesTABLE\".");
                servicesTABLEEmpty = YES;
            }
            sqlite3_close(servicesDB);
            return YES;
        } else {
            NSLog(@"DAO_ERROR: Failed to open/create servicesDB.db database");
            sqlite3_close(servicesDB);
            return NO;
        }
    }
    sqlite3_close(servicesDB);
    NSLog(@"DAO_ERROR: There doesnt seem to be a database called servicesDB.db here");
    return YES;
}


- (void)saveServicesData:(NSMutableArray *)servicesArray
{
    finishedSavingToServicesDatabase = NO;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    /*
     //variable used in for-loop below.
     int i = 0;
     NSLog(@"----------------------------------\n");
     
     for (Service *_dummyService in servicesArray){
     NSLog(@"DAO: SAVEDATA: servicesArray CONTENT: Service(%d): %@\n, %@\n, %@\n, %@\n",
     i,
     _dummyService.title,
     _dummyService.info_1,
     _dummyService.info_2,
     _dummyService.info_3);
     i++;
     NSLog(@"----------------------------------\n");
     }
     
     */
     
    
    int countOfServices = [servicesArray count];
    
    if (sqlite3_open(dbpath, &servicesDB) == SQLITE_OK) {
        
        
        for (int j = 0; j < countOfServices; j++) {
            Service *tmp_service = [servicesArray objectAtIndex:j];
            
            NSString *insertSQL =[NSString stringWithFormat:@"INSERT INTO servicesTABLE (title, info_1, info_2, info_3) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", tmp_service.title, tmp_service.info_1, tmp_service.info_2, tmp_service.info_3];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(servicesDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"DAO_SUCCESS: SERVICE data has been inserted into servicesTABLE.");
            } else {
                NSLog(@"DAO_ERROR: SERVICE data failed to be inserted into servicesTABLE.");
            }
            //this deletes the prepared statement. needed to
            //avoid memory leaks.
            sqlite3_finalize(statement);
        }
        sqlite3_close(gigGuideDB);
    }
    finishedSavingToServicesDatabase = YES;
}


-(void)dropServicesTable {
    servicesTABLEEmpty = NO;
    NSString *mDocsDir = self.getDocumentsDirectory;

    //build the path to the database file
    //it should be located at:
    //"<application_home>/Documents/servicesDB.db"
    databasePath = [[NSString alloc] initWithString:[mDocsDir stringByAppendingPathComponent:@"servicesDB.db"]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    const char *dbpath = [databasePath UTF8String];
    if ([fileMgr fileExistsAtPath:databasePath] == YES) {
        
        
        //sqlite3_open will create a database if it doesnt already exist.
        if (sqlite3_open(dbpath, &servicesDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "DROP TABLE servicesTABLE";
            
            if (sqlite3_exec(servicesDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"DAO_ERROR: Failed to delete all rows in servicesTABLE");
                NSLog(@"DAO_ERROR: errMsg: %s", errMsg);
                
                sqlite3_close(servicesDB);

            } else {
                NSLog(@"DAO_SUCCESS: Deleted all rows from table \"servicesTABLE\".");
                servicesTABLEEmpty = YES;
            }
            sqlite3_close(servicesDB);

        } else {
            NSLog(@"DAO_ERROR: Failed to open/create servicesDB.db database");
            sqlite3_close(servicesDB);

        }
    }
    sqlite3_close(servicesDB);
    NSLog(@"DAO_ERROR: There doesnt seem to be a database called servicesDB.db here.");
}




- (BOOL)clearGigsTable{
    gigsTABLEEmpty = NO;
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
                
                sqlite3_close(gigGuideDB);
                return NO;
            } else {
                NSLog(@"DAO_SUCCESS: Deleted all rows from table \"gigsTABLE\".");
                gigsTABLEEmpty = YES;
            }
            sqlite3_close(gigGuideDB);
            return YES;
        } else {
            NSLog(@"DAO_ERROR: Failed to open/create database");
            sqlite3_close(gigGuideDB);
            return NO;
        }
    }
    sqlite3_close(gigGuideDB);
    NSLog(@"DAO_ERROR: There doesnt seem to be a database called gigsDB.db here");
    return YES;
}

- (void)saveGigData:(NSMutableArray *)gigsArray
{
    finishedSavingToGigsDatabase = NO;
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
                NSLog(@"DAO_SUCCESS: GIG data has been inserted into gigsTABLE.");
            } else {
                NSLog(@"DAO_ERROR: SERVICE data failed to be inserted gigsTABLE.");
            }
            //this deletes the prepared statement. needed to
            //avoid memory leaks.
            sqlite3_finalize(statement);
        }
        sqlite3_close(gigGuideDB);
    }
    finishedSavingToGigsDatabase = YES;
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
                
                //NSLog(@"DAO_GIG_QUERY_RESULT: Result matched for query. The row[%d] returned is: primaryId=%@, author=%@, show=%@, date=%@, venue=%@, description=%@, tixurl=%@, price=%@", i, primaryIdField, authorField, showField, dateField, venueField, descriptionField, tixUrlField, priceField);
                
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
                NSLog(@"DAO_ERROR: No results were matched for the query.");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(gigGuideDB);
    }
return gigs;
}

//THIS SHOULD RETURN AN NSArray of gigs from the query
- (NSMutableArray *)getAllServices
{
    NSMutableArray *services = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    int i = 0;
    
    if (sqlite3_open(dbpath, &servicesDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM servicesTABLE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(servicesDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            /*
             if (sqlite3_step(statement) != SQLITE_ROW) {
             NSLog(@"DAO_ERROR: No result matched from database query");
             }
             */
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *primaryIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *info_1Field = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *info_2Field = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *info_3Field = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                /*
                NSLog(@"----------------------------------\n");

                NSLog(@"DAO_SERVICE_QUERY_RESULT: Result matched for query. The row[%d] returned is: primaryId=%@, title=%@, info_1=%@, info_2=%@, info_3=%@", i, primaryIdField, titleField, info_1Field, info_2Field, info_3Field);
                
                NSLog(@"----------------------------------\n");
                 */
                
                Service *_tmpService = [Service new];
                _tmpService.primaryId = primaryIdField;
                _tmpService.title = titleField;
                _tmpService.info_1 = info_1Field;
                _tmpService.info_2 = info_2Field;
                _tmpService.info_3 = info_3Field;
                                
                [services addObject:_tmpService];
                
                i++;
            }
            
            if (i == 0) {
                NSLog(@"DAO_ERROR: No results were matched for the query.");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(servicesDB);
    }
    return services;
}



//NOTE:u must always closed the database and finalize any
//statements before EACH return. Otherwise, u get Err: Database locked.
-(BOOL)isGigsDatabaseEmpty{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &gigGuideDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM gigsTABLE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(gigGuideDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
             if (sqlite3_step(statement) != SQLITE_ROW) {
             NSLog(@"DAO_DATABASE IS EMPTY: No rows in gigsTABLE database");
                 sqlite3_finalize(statement);
                 sqlite3_close(gigGuideDB);
                 return YES;
             } else {
                 sqlite3_finalize(statement);
                 sqlite3_close(gigGuideDB);
                 return NO;
             }
        }
        sqlite3_close(gigGuideDB);
    } else {
        NSLog(@"DAO_ERROR: Unable to open the database.");
    }
    //if control reaches here then assume there are no rows in table,
    //go and fetch them.
    //potential BUG??
    sqlite3_close(gigGuideDB);
    return YES;
}

//NOTE:u must always closed the database and finalize any
//statements before EACH return. Otherwise, u get Err: Database locked.
-(BOOL)isServicesDatabaseEmpty{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &servicesDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM servicesTABLE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(servicesDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) != SQLITE_ROW) {
                NSLog(@"DAO_SERVICES_TABLE IS EMPTY: No rows in servicesTABLE.");
                sqlite3_finalize(statement);
                sqlite3_close(servicesDB);
                return YES;
            } else {
                sqlite3_finalize(statement);
                sqlite3_close(servicesDB);
                return NO;
            }
        }
        sqlite3_close(servicesDB);
    } else {
        NSLog(@"DAO_ERROR: Unable to open the servicesDB.db database.");
    }
    //if control reaches here then assume there are no rows in table,
    //go and fetch them.
    //potential BUG??
    sqlite3_close(servicesDB);
    return YES;
}



@end