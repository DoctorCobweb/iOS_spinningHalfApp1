//
//  PurchaseTicketsViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 25/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "PurchaseTicketsViewController.h"

@interface PurchaseTicketsViewController ()

@end

@implementation PurchaseTicketsViewController

@synthesize webView;
@synthesize URL_STRING;

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
    NSString *localhost = @"http://localhost:8080/~andre/";
    NSURL *url = [NSURL URLWithString:localhost];
    //NSURL *url = [NSURL URLWithString:self.URL_STRING];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    NSLog(@"%@", URL_STRING);
    NSLog(@"%@", localhost);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
