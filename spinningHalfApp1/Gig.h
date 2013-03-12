//
//  Gig.h
//  spinningHalfApp1
//
//  Created by andre trosky on 5/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gig : NSObject

@property (nonatomic, strong) NSString *primaryId;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *show;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *venue;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *tixUrl;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *imageFile;



@end
