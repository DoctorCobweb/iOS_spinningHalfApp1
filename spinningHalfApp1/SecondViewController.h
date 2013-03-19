//
//  SecondViewController.h
//  spinningHalfApp1
//
//  Created by andre trosky on 28/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"


@interface SecondViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>
{
    
}


@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSMutableString *currentString;
//@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

-(void)makeWebServiceConnection;
-(void) refreshMyTableView;
- (IBAction)refreshButton:(id)sender;



@end
