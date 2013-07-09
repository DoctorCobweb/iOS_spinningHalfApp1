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
    gigDetailPriceLabel.text = theSelectedGig.price;
    
    /*
    //*******************************************************************************
    //PLAYING AROUND WITH PASSKIT ETC.
    
    if ([PKPassLibrary isPassLibraryAvailable]) {
        NSLog(@"GIG_DETAIL_VIEW_CONTROLLER: Pass Library is available");
        
        
        NSString *name = @"/newtonFaulknerTicket.pkpass";
        
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = dirPaths[0];
        NSString *passFile = [docsDir stringByAppendingFormat:name];
        
        NSLog(@"GIG_DETAIL_VIEW_CONTROLLER: passFile location: %@", passFile);
        
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
     */
    
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
