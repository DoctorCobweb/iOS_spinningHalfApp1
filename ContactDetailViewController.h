//
//  ContactDetailViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 19/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDetailViewController : UIViewController

@property (strong, nonatomic) NSString *WEBVIEW_URL;
@property (weak, nonatomic) IBOutlet UIWebView *contactDetailWebView;

- (IBAction)close:(id)sender;

@end
