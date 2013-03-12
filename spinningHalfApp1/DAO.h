//
//  DAO.h
//  spinningHalfApp1
//
//  Created by andre trosky on 6/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
//#import "Gig.h"

@interface DAO : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *gigGuideDB;
@property BOOL finishedSavingToDatabase;

- (NSString *)getDocumentsDirectory;
- (void)createDatabaseAndTable;
- (BOOL)clearGigsTable;
- (void)saveData:(NSMutableArray *)gigsArray;
- (NSMutableArray *)getAllGigs;

@end
