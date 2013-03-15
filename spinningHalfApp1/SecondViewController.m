//
//  SecondViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 28/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "SecondViewController.h"
#import "Gig.h"
#import "GigDetailViewController.h"
#import "DAO.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    //NSMutableArray *gigsFromXml;
    NSMutableArray *gigs;
    Gig *gig;
    int gigCount;
    DAO *dao;
}

@synthesize receivedData;
@synthesize currentString;
@synthesize tableView;
//@synthesize refreshControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title =@"Gig Guide";
    
    //gigsFromXml = [[NSMutableArray alloc] init];
    gigs = [[NSMutableArray alloc] init];
    gig = [Gig new];
    gigCount = 0;
    dao = [[DAO alloc] init];
    
    
    //initialise the refresh controller
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];

    
    [refreshControl addTarget:self action:@selector(refreshMyTableView) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
    
    /*
    //set the title for pull request
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to Refresh"];
    
    //call the refresh function
    [refreshControl addTarget:self action:@selector(refreshMyTableView)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
     */
    
    
    /*
    [self.refreshControl
     addTarget:self
     action:@selector(refreshMyTableView)
     forControlEvents:UIControlEventValueChanged
     ];
     */

    //create the database "gigsDB.db" and table "gigsTABLE" in the Documents/ dir of app.
    [dao createDatabaseAndTable];
    //[dao saveData];
    //[dao getData];
    BOOL var = [dao isDatabaseEmpty];
    NSLog(@"DATABASE_STATUS: isEmpty = %@", (var ? @"YES": @"NO"));
    
    if (var == YES) {
        //there's nothing in the database to display. go make a connection
        //download content, parse and insert it into database.
        //then display it.
        [self makeWebServiceConnection];
    } else {
        //there's stuff in the database already. use that to display data.
        //populate the gigs array which table view needs in order to
        //calculate how many rows it should display, contents for each row
        //yadda yadda.
        gigs = [dao getAllGigs];
    }
}


-(void)makeWebServiceConnection {
    //create a connection to the gig guide web service, download text
    //and display it to a text view.
    //
    //the NSURLConnection delegate will be this view controller.
    //
    //must at minimum provide the following implementations to be a valid
    //delegate:
    //
    //connection:didReceivedResponse:
    //connection:didReceiveData:
    //connection:didFailWithError:
    //connectionDidFinishLoading:
    
    //create the request.
    NSString *address =
    @"http://www.spinning-half-jersey-jaxrs.appspot.com/rest/gigs";
    NSURL *url = [NSURL URLWithString:address];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:60.0];
    
    //create the connection using the request and start loading the data.
    //the downloading start immediately up receiving
    //the initWithRequest:delegate: message.
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        //create the NSMutatableData to hold the received data.
        receivedData = [NSMutableData data];
    } else {
        //inform the user that the connection failed.
        NSLog(@"The connection failed, dude.");
    }
}


//-------START: table view delegate methods--------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gigs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"gigCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:simpleTableIdentifier];
    }
    
    //textLabel is a default identifier for a label in prototype cell.
    //but now we are using a a custom cell protoype.
    //cell.textLabel.text = _tmp;
    
    //PUT A DATABASE QUERY TO GET ALL THE GIGS
    //TO DISPLAY.
    NSMutableArray *tmp_gigs_array = [dao getAllGigs];
    
    
    //get the gig associated with the row.
    Gig *tmp_gig = [tmp_gigs_array objectAtIndex:indexPath.row];
    //set a placeholder image for now as the row images.
    tmp_gig.imageFile = @"green_tea.jpg";

    UILabel *gigShow = (UILabel *)[cell viewWithTag:101];
    gigShow.text = tmp_gig.show;
    
    UILabel *gigDate = (UILabel *)[cell viewWithTag:102];
    gigDate.text = tmp_gig.date;
    
    UIImageView *gigImageView = (UIImageView *) [cell viewWithTag:100];
    gigImageView.image = [UIImage imageNamed:tmp_gig.imageFile];
    return cell;
}

//-----END: table view delegate methods------------------------





//-----START: NSURLConnection delegate methods-----------------

//NSURLConnection delegate method.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  
    //this method is called when the server has determined that it
    //has enough info to create the NSURLResponse object.
    
    
    //it can be called multiple times, for example in the case of a
    //redirect, so each time we need to reset the data.
    
    //setLength extends or truncates the data to the specified Integer length
    [receivedData setLength:0];
}

//NSURLConnection delegate method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //log that we receiced another bundle of data.
    NSLog(@"connection:didReceiveData: Received a bundle of data.");
    //append the new data to receivedData
    [receivedData appendData:data];
}

//NSURLConnection delegate method.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //release the connection, and the data object
    //[connection release];

    //inform the user.
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

//NSURLConnection delegate method.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //do something with the data
    NSLog(@"Succussful Download! Received %d bytes of data",
          [receivedData length]);
    
    //release the connection and the data object
    //[connection release];
    //[receivedData release];
    
    //set the webServiceContent text view to be
    //content of receivedData.
    
    /*
    //first define a string variable which has its contents set to
    //be the contents of receivedData variable. also must specify the
    //encoding to be used for the string.
    NSString *theData = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //now we can finally set the contents for the text view.
    self.webServiceContent.text = theData;
    */
     
    //alloc and init the parser object, fill it with the
    //downloaded data then start parsing xml.
    //also we are setting this view controller to be the
    //delegate of the parser, which means that the parser
    //will call its delegate methods when 'events' occur
    //and expect to find the implementations of the methods
    //in this file.
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:receivedData];
    
    self.currentString = [NSMutableString string];
    parser.delegate = self;
    //???if we initialize self.currentString = nil,
    //the [currentString appendString:string] method in parser:foundCharacters
    //is always nil! must be forever setting it...
    //the parser works however if we user the following way to initialize it:
    [self.currentString setString:@""];
    //if we comment the above line out, it still works. i dont get it yet fully.
    
    NSLog(@"connection:didFinishLoading should only be called ONCE.");
    
    //reset the gigs array because the parser will append each gig
    //=> when calling pull-to-refresh we dont duplicate Gigs.
    [gigs removeAllObjects];
    
    //start parsing, dude.
    [parser parse];
    

}

//-------END: NSURLConnection delegate methods-----------------

//-------START: NSXMLParser delegate methods-------------------

static NSString * kName_allGigs = @"allGigs";
static NSString * kName_gig = @"gig";
static NSString * kName_author = @"author";
static NSString * kName_show = @"show";
static NSString * kName_date = @"date";
static NSString * kName_venue = @"venue";
static NSString * kName_description = @"description";
static NSString * kName_tixUrl = @"tixUrl";
static NSString * kName_price = @"price";

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kName_allGigs]) {
        //NSLog(@"start tag for ALL_GIGS\n");
    } else if([elementName isEqualToString:kName_gig]) {
        //NSLog(@"start tag for GIG\n");
    }else if ([elementName isEqualToString:kName_author]) {
        //NSLog(@"start tag for AUTHOR\n");
    } else if ([elementName isEqualToString:kName_show]) {
        //NSLog(@"start tag for SHOW\n");
    } else if ([elementName isEqualToString:kName_date]) {
        //NSLog(@"start tag for DATE\n");
    } else if ([elementName isEqualToString:kName_venue]) {
        //NSLog(@"start tag for VENUE\n");
    } else if ([elementName isEqualToString:kName_description]) {
        //NSLog(@"start tag for DESCRIPTION\n");
    } else if ([elementName isEqualToString:kName_tixUrl]) {
        //NSLog(@"start tag for TIXURL\n");
    } else if ([elementName isEqualToString:kName_price]) {
        //NSLog(@"start tag for PRICE\n");
    }
    //call this to reset the string to be empty before cycling thru again
    //and appending more content to currentString.if u dont then u get
    //one gigantice concatenation of all the content between the element tags.
    [currentString setString:@""];
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:kName_gig]) {
        //NSLog(@"didEndElement tag for GIG\n");
        //NSLog(@"content: %@\n", currentString);
        
        //add the gig object to gigs array.
        Gig *_tmpGig = [Gig new];
        _tmpGig.author = gig.author;
        _tmpGig.show = gig.show;
        _tmpGig.date = gig.date;
        _tmpGig.venue = gig.venue;
        _tmpGig.description = gig.description;
        _tmpGig.tixUrl = gig.tixUrl;
        _tmpGig.price = gig.price;
        
        /*
        NSLog(@"TEMP GIG: %@, %@, %@, %@, %@, %@, %@",
              _tmpGig.author,
              _tmpGig.show,
              _tmpGig.date,
              _tmpGig.venue,
              _tmpGig.description,
              _tmpGig.tixUrl,
              _tmpGig.price);
         */
        
        //add the newly parsed and filled Gig object to the gigs array.
        [gigs addObject:_tmpGig];
        
        //NSLog(@"gigs array COUNT: %d",[gigs count]);
        
        
        //NSLog(@"**********************************\n");
        
        /*
        //variable used in for-loop below.
        int i = 0;
        NSLog(@"----------------------------------\n");
        
        for (Gig *_dummyGig in gigs){
            NSLog(@"gigs array CONTENT: Gig(%d): %@\n, %@\n, %@\n, %@\n, %@\n, %@\n, %@\n",
                  i,
                  _dummyGig.author,
                  _dummyGig.show,
                  _dummyGig.date,
                  _dummyGig.venue,
                  _dummyGig.description,
                  _dummyGig.tixUrl,
                  _dummyGig.price);
            i++;
            NSLog(@"----------------------------------\n");
        }
         */
        
        //NSLog(@"**********************************\n");
        
        
    } else if ([elementName isEqualToString:kName_author]) {
        //NSLog(@"didEndElement tag for AUTHOR\n");
        //NSLog(@"content: %@\n", currentString);
        
        NSString *_currentString = [currentString copy];
        gig.author = _currentString;
        
    } else if ([elementName isEqualToString:kName_show]) {
        //NSLog(@"didEndElement tag for SHOW\n");
        //NSLog(@"content: %@\n", currentString);
        
        NSString *_currentString = [currentString copy];
        gig.show = _currentString;
        
        if (currentString) {
            //you HAVE to alloc and init another NSString * variable before
            //putting it into the gigsFromXml array.
            //if you just pass in currentString reference, then you end up with
            //an array of pointers pointing to the same location, which
            //will have as its contents, each element the same as the last thing
            //currentString pointed to.
            //NSString * _currentString = [[NSString alloc] initWithString:currentString];
            //NSString *_currentString = [currentString copy];
            //[gigsFromXml addObject:_currentString];
        }
        gigCount++;
        
        /*
        for (NSString *_gig in gigsFromXml) {
            NSLog(@"_GIG_: %@\n", _gig);
        }
         */
        
    } else if ([elementName isEqualToString:kName_date]) {
        //NSLog(@"didEndElement tag for DATE\n");
        //NSLog(@"content: %@\n", currentString);
        
        NSString *_currentString = [currentString copy];
        gig.date = _currentString;
        
    } else if ([elementName isEqualToString:kName_venue]) {
        //NSLog(@"didEndElement tag for VENUE\n");
        //NSLog(@"content: %@\n", currentString);
        
        NSString *_currentString = [currentString copy];
        gig.venue = _currentString;
        
    } else if ([elementName isEqualToString:kName_description]) {
        //NSLog(@"didEndElement tag for DESCRIPTION\n");
        //NSLog(@"content: %@\n", currentString);
        
        NSString *_currentString = [currentString copy];
        gig.description = _currentString;
        
    } else if ([elementName isEqualToString:kName_tixUrl]) {
        //NSLog(@"didEndElement tag for TIXURL\n");
        //NSLog(@"content: %@\n", currentString);
        
        NSString *_currentString = [currentString copy];
        gig.tixUrl = _currentString;
        
    } else if ([elementName isEqualToString:kName_price]) {
        //NSLog(@"didEndElement tag for PRICE\n");
        //NSLog(@"content: %@\n", currentString);
        
        NSString *_currentString = [currentString copy];
        gig.price = _currentString;
        
    } else if ([elementName isEqualToString:kName_allGigs]) {
        
        //gigs array should be filled with all the downloaded
        // and parsed gigs.
        
        //NSLog(@"didEndElement tag for ALLGIGS\n");
        //NSLog(@"TOTAL NUMBER OF GIGS: %d\n", gigCount);
        //NSLog(@"TOTOAL NUMBER OF OBJECTS in gigsFromXml array: %d", [gigsFromXml count]);
        /*
        for (NSString *_gig in gigsFromXml) {
            NSLog(@"gigsFromXml:_GIG_: %@\n", _gig);
        }
         */
        
        NSLog(@"Total number of gigs in gigs Array = %d", [gigs count]);
        
        
        if ([dao clearGigsTable]) {
        //save gigs array data to the database
            NSLog(@"clearing gigsTABLE");
        [dao saveData:gigs];
        } else {
            NSLog(@"FAILED: To clear the gigsTABLE table.");
          
        }
        
        //make sure that the database has finished saving
        //before attempting to read from it.
        
        //wait for the database to finish saving
        while (!dao.finishedSavingToDatabase) {
            NSLog(@"In Parser: SAVING DATA: Please wait.");
            continue;
        }
        
        
        if (dao.finishedSavingToDatabase) {
            gigs = [dao getAllGigs];
        }
         
        
        
        
        
        //call reload data to display the dowloaded content.
        // here we are using the gigs array data instead of
        //reading from the database as i think it's quicker
        //to do it this way.
        [self.tableView reloadData];
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"in foundCharacters: method of parser.\n");
    //NSLog(@"input string for parser:foundCharacters: method is: %@", string);
    [currentString appendString:string];
    
    //NSLog(@"currentString is now: %@", currentString);
}


//-------END:NSXMLParser delegate methods---------------------

//-------START: Segue to Gig detail view delaga methods-------


//this method is called when user selects a row in the table view.
//here we can pass over the Gig object selected to the GigDetailViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGigDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GigDetailViewController *destViewController = segue.destinationViewController;
        
        //get the gigs from the database
        NSMutableArray *tmp_all_gigs_array = [dao getAllGigs];
        
        destViewController.theSelectedGig = [tmp_all_gigs_array objectAtIndex:indexPath.row];
    }
}

-(void) refreshMyTableView {
    NSLog(@"REFRESH_MY_TABLE_VIEW: has been called.");
    [self makeWebServiceConnection];
    //[self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
