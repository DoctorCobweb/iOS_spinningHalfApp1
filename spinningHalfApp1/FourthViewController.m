//
//  FourthViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 28/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "FourthViewController.h"
#import "ContactDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface FourthViewController ()

@end

@implementation FourthViewController 
{
    NSArray *online_urls;  
}

@synthesize onlineFacebookButton;
@synthesize onlineTwitterButton;
@synthesize onlineYoutubeButton;
@synthesize onlineSpinningHalfWebsite;

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
    self.title = @"Contact";
    online_urls = [NSArray arrayWithObjects:@"https://www.facebook.com/spinning.half", @"https://twitter.com/spinninghalf", @"http://www.youtube.com/user/SpinningHalfLive/videos?flow=grid&view=0", @"https://www.facebook.com/spinning.half" ,nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)callOfficeLine:(id)sender {
    NSLog(@"Pressed callOfficeLine");
    NSString *officeNumber = @"tel://0352221186";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:officeNumber]];
    
}

- (IBAction)emailInfoAccount:(id)sender {
    NSLog(@"Pressed emailInfoAccount");
    // Email Subject
    NSString *emailTitle = @"Info Inquiry";
    // Email Content
    NSString *messageBody = @"Please add email content here.";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@spinninghalf.com.au"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

//this is part of the MFMailComposerViewControllerDelegate protocol.
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)spinningHalfFacebook:(id)sender {
    NSLog(@"Pressed spinningHalfFacebook");
}

- (IBAction)spinningHalfTwitter:(id)sender {
    NSLog(@"Pressed spinningHalfTwitter");
}

- (IBAction)spinningHalfYoutube:(id)sender {
    NSLog(@"Pressed spinningHalfYoutube");
}

- (IBAction)spinningHalfWebsite:(id)sender {
    NSLog(@"Pressed spinningHalfWebsite");
}

- (IBAction)callAndreMobile:(id)sender {
    NSLog(@"Pressed callAndreMobile");
    NSString *andreMobileNumber = @"tel://0421866977";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:andreMobileNumber]];
}


- (IBAction)emailBookingsAccount:(id)sender {
    NSLog(@"Pressed emailBookingsAccount");
    NSLog(@"Pressed emailInfoAccount");
    // Email Subject
    NSString *emailTitle = @"Booking Inquiry";
    // Email Content
    NSString *messageBody = @"Please add email content here.";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"bookings@spinninghalf.com.au"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ContactDetailViewController *destViewController = segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"onlineFacebookButton"]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            NSLog(@"onlineFacebookButton segue");
            NSLog(@"tag is: %d", [sender tag]);
            destViewController.WEBVIEW_URL = online_urls[0];
        }
    } else if ([segue.identifier isEqualToString:@"onlineTwitterButton"]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            NSLog(@"onlineTwitterButton segue");
            NSLog(@"tag is: %d", [sender tag]);
            destViewController.WEBVIEW_URL = online_urls[1];
        }
    } else if ([segue.identifier isEqualToString:@"onlineYoutubeButton"]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            NSLog(@"onlineYoutubeButton segue");
            NSLog(@"tag is: %d", [sender tag]);
            destViewController.WEBVIEW_URL = online_urls[2];
        }
    } else if ([segue.identifier isEqualToString:@"onlineSpinningHalfWebsiteButton"]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            NSLog(@"onlineSpinningHalfWebsiteButton segue");
            NSLog(@"tag is: %d", [sender tag]);
            destViewController.WEBVIEW_URL = online_urls[3];
        }
    }
}
@end
