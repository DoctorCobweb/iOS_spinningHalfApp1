//
//  ContactDetailViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 19/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "ContactDetailViewController.h"

@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController

@synthesize contactDetailWebView;
@synthesize WEBVIEW_URL;

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
    NSURL *url = [NSURL URLWithString:self.WEBVIEW_URL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [contactDetailWebView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
        [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
