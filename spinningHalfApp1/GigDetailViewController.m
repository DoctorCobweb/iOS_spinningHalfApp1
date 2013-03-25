//
//  GigDetailViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 5/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "GigDetailViewController.h"
#import "PurchaseTicketsViewController.h"

@interface GigDetailViewController ()

@end

@implementation GigDetailViewController

@synthesize gigDetailShowLabel;
@synthesize gigDetailDateLabel;
@synthesize gigDetailVenueLabel;
@synthesize gigDetailDescriptionLabel;
@synthesize gigDetailTixUrlLabel;
@synthesize gigDetailTixUrlButton;
@synthesize gigDetailPriceLabel;
@synthesize theSelectedGig;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //self.navigationController.navigationItem.backBarButtonItem
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = theSelectedGig.show;
    
    //set label contents to that of the selected gig pass in during the segue.
    gigDetailShowLabel.text = theSelectedGig.show;
    gigDetailDateLabel.text = theSelectedGig.date;
    gigDetailVenueLabel.text = theSelectedGig.venue;
    gigDetailDescriptionLabel.text = theSelectedGig.description;
    gigDetailTixUrlLabel.text = theSelectedGig.tixUrl;
    //gigDetailTixUrlButton.setTitleLabel = theSelectedGig.tixUrl;
    gigDetailPriceLabel.text = theSelectedGig.price;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"onlineTicketPurchaseSegue"]) {
        PurchaseTicketsViewController *destViewController = segue.destinationViewController;
        
        
        
        destViewController.URL_STRING = theSelectedGig.tixUrl;
    }
}


@end
