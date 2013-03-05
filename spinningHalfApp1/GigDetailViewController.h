//
//  GigDetailViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 5/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gig.h"

@interface GigDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *gigDetailShowLabel;
@property (strong, nonatomic) IBOutlet UILabel *gigDetailDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *gigDetailVenueLabel;
@property (weak, nonatomic) IBOutlet UITextView *gigDetailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *gigDetailTixUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *gigDetailPriceLabel;

//this will hold the reference to the gig selected in table view. passed
//in from the segue push.
@property (strong, nonatomic) Gig *theSelectedGig;

@end
