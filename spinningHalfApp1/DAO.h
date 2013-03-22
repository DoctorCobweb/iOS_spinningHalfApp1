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
@property (nonatomic) sqlite3 *servicesDB;
@property BOOL finishedSavingToGigsDatabase;
@property BOOL finishedSavingToServicesDatabase;
@property BOOL gigsTABLEEmpty;
@property BOOL servicesTABLEEmpty;

- (NSString *)getDocumentsDirectory;
- (void)createGigDatabaseAndTable;
- (void)createServicesDatabaseAndTable;
- (void)dropServicesTable;
- (BOOL)clearGigsTable;
- (BOOL)clearServicesTable;
- (void)saveGigData:(NSMutableArray *)gigsArray;
- (void)saveServicesData:(NSMutableArray *)servicesArray;
- (NSMutableArray *)getAllGigs;
- (NSMutableArray *)getAllServices;
-(BOOL)isGigsDatabaseEmpty;
-(BOOL)isServicesDatabaseEmpty;

@end
