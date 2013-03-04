//
//  SecondViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 28/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    NSArray *gigs;
    NSMutableArray *gigsFromXml;
    int gigCount;
}

@synthesize receivedData;
//@synthesize webServiceContent;
//@synthesize gigLabel;
@synthesize currentString;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title =@"Gig Guide";
    
    gigs = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    gigsFromXml = [[NSMutableArray alloc] init];
    
    gigCount = 0;


    
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
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    /*
    //ASIDE: or you could chain this all together in the following manner:
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.spinninghalf.com.au"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
     */
    
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
        NSLog(@"start tag for ALL_GIGS\n");
    } else if([elementName isEqualToString:kName_gig]) {
        NSLog(@"start tag for GIG\n");
    }else if ([elementName isEqualToString:kName_author]) {
        NSLog(@"start tag for AUTHOR\n");
    } else if ([elementName isEqualToString:kName_show]) {
        NSLog(@"start tag for SHOW\n");
    } else if ([elementName isEqualToString:kName_date]) {
        NSLog(@"start tag for DATE\n");
    } else if ([elementName isEqualToString:kName_venue]) {
        NSLog(@"start tag for VENUE\n");
    } else if ([elementName isEqualToString:kName_description]) {
        NSLog(@"start tag for DESCRIPTION\n");
    } else if ([elementName isEqualToString:kName_tixUrl]) {
        NSLog(@"start tag for TIXURL\n");
    } else if ([elementName isEqualToString:kName_price]) {
        NSLog(@"start tag for PRICE\n");
    }
    //call this to reset the string to be empty before cycling thru again
    //and appending more content to currentString.
    [currentString setString:@""];
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kName_gig]) {
        NSLog(@"didEndElement tag for GIG\n");
        NSLog(@"content: %@\n", currentString);
        [gigsFromXml addObject:currentString];
        gigCount++;
    } else if ([elementName isEqualToString:kName_author]) {
        NSLog(@"didEndElement tag for AUTHOR\n");
        NSLog(@"content: %@\n", currentString);
    } else if ([elementName isEqualToString:kName_show]) {
        NSLog(@"didEndElement tag for SHOW\n");
        NSLog(@"content: %@\n", currentString);
    } else if ([elementName isEqualToString:kName_date]) {
        NSLog(@"didEndElement tag for DATE\n");
        NSLog(@"content: %@\n", currentString);
    } else if ([elementName isEqualToString:kName_venue]) {
        NSLog(@"didEndElement tag for VENUE\n");
        NSLog(@"content: %@\n", currentString);
    } else if ([elementName isEqualToString:kName_description]) {
        NSLog(@"didEndElement tag for DESCRIPTION\n");
        NSLog(@"content: %@\n", currentString);
    } else if ([elementName isEqualToString:kName_tixUrl]) {
        NSLog(@"didEndElement tag for TIXURL\n");
        NSLog(@"content: %@\n", currentString);
    } else if ([elementName isEqualToString:kName_price]) {
        NSLog(@"didEndElement tag for PRICE\n");
        NSLog(@"content: %@\n", currentString);
    } else if ([elementName isEqualToString:kName_allGigs]) {
        NSLog(@"didEndElement tag for ALLGIGS\n");
        NSLog(@"TOTAL NUMBER OF GIGS: %d\n", gigCount);
        NSLog(@"TOTOAL NUMBER OF OBJECTS in gigsFromXml array: %d", [gigsFromXml count]);
    }

    //currentString = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"in foundCharacters: method of parser.\n");
    NSLog(@"input string for parser:foundCharacters: method is: %@", string);
    //NSMutableString *temp = currentString;
    [currentString appendString:string];
    
    NSLog(@"currentString is now: %@", currentString);
}









//-------END:NSXMLParser delegate methods----------------------


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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [gigs objectAtIndex:indexPath.row];
    return cell;
}

//-----END: table view delegate methods------------------------


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
