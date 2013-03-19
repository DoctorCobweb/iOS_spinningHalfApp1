//
//  FourthViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 28/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FourthViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *onlineFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *onlineTwitterButton;
@property (weak, nonatomic) IBOutlet UIButton *onlineYoutubeButton;
@property (weak, nonatomic) IBOutlet UIButton *onlineSpinningHalfWebsite;




- (IBAction)callOfficeLine:(id)sender;
- (IBAction)emailInfoAccount:(id)sender;
- (IBAction)spinningHalfFacebook:(id)sender;
- (IBAction)spinningHalfTwitter:(id)sender;
- (IBAction)spinningHalfYoutube:(id)sender;
- (IBAction)spinningHalfWebsite:(id)sender;
- (IBAction)callAndreMobile:(id)sender;
- (IBAction)emailBookingsAccount:(id)sender;

@end
