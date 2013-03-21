//
//  Service.h
//  spinningHalfApp1
//
//  Created by andre trosky on 21/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject

@property (nonatomic, strong) NSString *primaryId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *info_1;
@property (nonatomic, strong) NSString *info_2;
@property (nonatomic, strong) NSString *info_3;

-(void)addInAllTheServiceContent;


@end
