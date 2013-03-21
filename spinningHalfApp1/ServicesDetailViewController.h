//
//  ServicesDetailViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 13/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"

@interface ServicesDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (strong, nonatomic) NSString *serviceImageName;

@property (strong, nonatomic) IBOutlet UITextView *info_1;
@property (strong, nonatomic) IBOutlet UITextView *info_2;
@property (strong, nonatomic) IBOutlet UITextView *info_3;
@property (strong, nonatomic) IBOutlet UILabel *navBarTitle;

@property (strong, nonatomic) Service *theSelectedService;


- (IBAction)close:(id)sender;

@end
