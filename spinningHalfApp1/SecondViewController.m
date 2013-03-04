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

@implementation SecondViewController

@synthesize receivedData;
@synthesize webServiceContent;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title =@"Gig Guide";
    
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
    
    //first define a string variable which has its contents set to
    //be the contents of receivedData variable. also must specify the
    //encoding to be used for the string.
    NSString *theData = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    
    //now we can finally set the contents for the text view.
    self.webServiceContent.text = theData;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
