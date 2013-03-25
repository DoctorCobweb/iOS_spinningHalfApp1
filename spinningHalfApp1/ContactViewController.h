//
//  ContactViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 23/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>


- (void)emailInfoAccount;
- (void)emailBookingsAccount;
- (void)callOfficeline;
- (void)callAndreMobile;

@end
