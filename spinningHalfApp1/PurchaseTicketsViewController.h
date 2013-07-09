//
//  PurchaseTicketsViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 25/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@interface PurchaseTicketsViewController : UIViewController <PKAddPassesViewControllerDelegate>

@property (nonatomic, strong) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *URL_STRING;

@end
