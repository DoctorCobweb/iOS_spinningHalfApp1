//
//  SecondViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 28/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>
{
    //NSMutableString *currentString;
}

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSMutableString *currentString;

//@property (weak, nonatomic) IBOutlet UITextView *webServiceContent;
//@property (weak, nonatomic) IBOutlet UILabel *gigLabel;


@end
