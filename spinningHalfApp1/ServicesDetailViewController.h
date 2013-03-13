//
//  ServicesDetailViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 13/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) NSString *serviceImageName;


- (IBAction)close:(id)sender;

@end
