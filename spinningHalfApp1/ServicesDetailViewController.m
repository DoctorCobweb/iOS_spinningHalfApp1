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
@synthesize theSelectedService;
@synthesize title;
@synthesize info_1;
@synthesize info_2;
@synthesize info_3;
@synthesize navBarTitle;

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
    //self.title = serviceImageName;
    serviceImageView.image = [UIImage imageNamed:serviceImageName];
    
    navBarTitle.text = theSelectedService.title;
    info_1.text = theSelectedService.info_1;
    info_2.text = theSelectedService.info_2;
    info_3.text = theSelectedService.info_3;
    
    
    
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
