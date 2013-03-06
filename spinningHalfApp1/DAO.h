//
//  DAO.h
//  spinningHalfApp1
//
//  Created by andre trosky on 6/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DAO : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *gigGuideDB;

- (NSString *)getDocumentsDirectory;
- (void)createDatabaseAndTable;
- (void)saveData;
- (void)getData;

@end
