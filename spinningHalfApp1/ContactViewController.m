//
//  ContactViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 23/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface ContactViewController ()

@end

@implementation ContactViewController {
    NSArray *online_urls;  
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    online_urls = [NSArray arrayWithObjects:@"https://www.facebook.com/spinning.half", @"https://twitter.com/spinninghalf", @"http://www.youtube.com/user/SpinningHalfLive/videos?flow=grid&view=0", @"http://www.spinninghalf.com.au", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"CONTACT_TABLE_VIEW: row selected = %d, section selected = %d", indexPath.row, indexPath.section);
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    
    //check to see if user pressed an email row
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self emailInfoAccount];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        [self emailBookingsAccount];
    }
    
    
    //check to see if user pressed a phone call row
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self callOfficeLine];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self callOfficeLine];
    
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        [self callAndreMobile];
    }
    
}


- (void)emailInfoAccount {
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


- (void)emailBookingsAccount{
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


- (void)callOfficeLine{
    //NSLog(@"Pressed callOfficeLine");
    NSString *officeNumber = @"tel://0352221186";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:officeNumber]];
    
}


- (void)callAndreMobile{
    //NSLog(@"Pressed callAndreMobile");
    NSString *andreMobileNumber = @"tel://0421866977";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:andreMobileNumber]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //NSLog(@"CONTACT_TABLE_VIEW: row selected = %d, section selected = %d", indexPath.row, indexPath.section);
    
    if ([segue.identifier isEqualToString:@"contactOfficeLocationSegue"]) {
        ContactDetailViewController *destViewController = segue.destinationViewController;
        destViewController.WEBVIEW_URL = @"https://maps.google.com.au/maps?q=suite+3%2F2+fenwick+st+south+geelong&hl=en&sll=-36.605471,145.469483&sspn=5.308336,9.876709&hnear=3%2F2+Fenwick+St+S,+Geelong+Victoria+3220&t=m&z=16";
    } else if ([segue.identifier isEqualToString:@"contactRehearsalsLocationSegue"]) {
        ContactDetailViewController *destViewController = segue.destinationViewController;
        destViewController.WEBVIEW_URL = @"https://maps.google.com.au/maps?q=313+bellarine+st+geelong&hl=en&sll=-38.152627,144.353078&sspn=0.010158,0.01929&hnear=313+Bellerine+St,+South+Geelong+Victoria+3220&t=m&z=16";
    } else if ([segue.identifier isEqualToString:@"contactSpinningHalfFacebookSegue"]) {
        ContactDetailViewController *destViewController = segue.destinationViewController;
        destViewController.WEBVIEW_URL = online_urls[0];
    } else if ([segue.identifier isEqualToString:@"contactSpinningHalfTwitterSegue"]) {
        ContactDetailViewController *destViewController = segue.destinationViewController;
        destViewController.WEBVIEW_URL = online_urls[1];
    } else if ([segue.identifier isEqualToString:@"contactSpinningHalfYoutubeSegue"]) {
        ContactDetailViewController *destViewController = segue.destinationViewController;
        destViewController.WEBVIEW_URL = online_urls[2];
    } else if ([segue.identifier isEqualToString:@"contactSpinningHalfWebsiteSegue"]) {
        ContactDetailViewController *destViewController = segue.destinationViewController;
        destViewController.WEBVIEW_URL = online_urls[3];
    }
}


@end
