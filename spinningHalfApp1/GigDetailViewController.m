//
//  GigDetailViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 5/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "GigDetailViewController.h"
#import "PurchaseTicketsViewController.h"
#import <PassKit/PassKit.h>

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
    
    //[gigDetailTixUrlButton setBackgroundImage:[UIImage imageNamed:@"orange_button.png"] forState:UIControlStateNormal];
    //[[gigDetailTixUrlButton appearance] setTintColor:[UIColor orangeColor]];
    
    
    //*******************************************************************************
    //UNCOMMENT THIS SECTION TO USE PASSBOOK PASS
    //PLAYING AROUND WITH PASSKIT ETC.
    
    if ([PKPassLibrary isPassLibraryAvailable]) {
        NSLog(@"Pass Library is available");
        
        
        NSString *name = @"newtonFaulknerTicket.pkpass";
        
        //create the full path to the .pkpass file
        NSString *passFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
        NSLog(@"%@", passFile);
        //add contents of .pkpass to instance of NSData
        NSData *passData = [NSData dataWithContentsOfFile:passFile];
        
        NSError *error = nil;
        
        //create the new PKPass object
        PKPass *thePass = [[PKPass alloc] initWithData:passData error:&error];
        
        //to display to pass object must use this special
        //view controller.
        PKAddPassesViewController *addController = [[PKAddPassesViewController alloc] initWithPass:thePass];
        addController.delegate = self;
        [self presentViewController:addController animated:YES completion:nil];
    }
     
    //************************************************************************************
    
}


//part of Pass Controller delegate protocol
- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
{
    //pass added
    [self dismissViewControllerAnimated:YES completion:nil];
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
