//
//  ServicesDetailViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 13/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "ServicesDetailViewController.h"

@interface ServicesDetailViewController ()

@end

@implementation ServicesDetailViewController

@synthesize serviceImageName;
@synthesize serviceImageView;

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
    self.title = serviceImageName;
    serviceImageView.image = [UIImage imageNamed:serviceImageName];
    
    
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
