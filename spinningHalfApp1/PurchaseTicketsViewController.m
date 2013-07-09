//
//  PurchaseTicketsViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 25/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "PurchaseTicketsViewController.h"
#import <PassKit/PassKit.h>

//*** ATTENTION ***
//the server for generating passbooks is found in the
//~/projects/node/express_stuff/nodecellar directory

@interface PurchaseTicketsViewController ()

@end

@implementation PurchaseTicketsViewController

@synthesize webView;
@synthesize URL_STRING;
@synthesize receivedData;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *localhost = @"http://localhost:3000/pass";
    NSURL *url = [NSURL URLWithString:localhost];
    //NSURL *url = [NSURL URLWithString:self.URL_STRING];
    //NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //[webView loadRequest:requestObj];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        //create the NSMutatbleData to hold the received data
        receivedData = [NSMutableData data];
    } else {
        //inform the user that the connection failed.
        NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: The connection failed.");
    }
    
    //NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: %@", URL_STRING);
    NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: Server address: %@", localhost);
}

//-----START: NSURLConnection delegate methods-----------------

//NSURLConnection delegate method.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    //this method is called when the server has determined that it
    //has enough info to create the NSURLResponse object.
    
    
    //it can be called multiple times, for example in the case of a
    //redirect, so each time we need to reset the data.
    
    //setLength extends or truncates the data to the specified Integer length
    [receivedData setLength:0];
}

//NSURLConnection delegate method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //log that we receiced another bundle of data.
    NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: connection:didReceiveData: Received a bundle of data.");
    //append the new data to receivedData
    [receivedData appendData:data];
}

//NSURLConnection delegate method.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //release the connection, and the data object
    //[connection release];
    
    //inform the user.
    NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: Connection failed. Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

//NSURLConnection delegate method.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: connection:didFinishLoading should only be called ONCE.");
    
    //log the size of downloaded data.
    NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: ***Succussful Download***. Received %d bytes of data",
          [receivedData length]);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: /Documents path is: %@", documentsDirectory);
    
    //write the downloaded file to Documents dir
    NSString *passFile = [documentsDirectory stringByAppendingPathComponent:@"/downloadedPass.pkpass"];
    [receivedData writeToFile:passFile atomically:YES];
    
    if ([PKPassLibrary isPassLibraryAvailable]) {
        NSLog(@"PURCHASE_TICKETS_VIEW_CONTROLLER: Pass library is available.");
        
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
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
