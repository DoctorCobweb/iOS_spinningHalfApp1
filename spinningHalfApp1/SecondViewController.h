//
//  SecondViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 28/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (nonatomic, strong) NSMutableData *receivedData;
@property (weak, nonatomic) IBOutlet UITextView *webServiceContent;

@end
