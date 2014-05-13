//
//  ViewController.m
//  iRE
//
//  Created by veracode on 11/8/13.
//  Copyright (c) 2013 veracode. All rights reserved.
//

#import "ViewController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>



@interface ViewController ()



@end

@implementation ViewController

    UIButton*btnStart;
    int intButtonState;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    float rd = 3.0/255.0;
    float gr = 119.0/255.0;
    float bl = 204.0/255.0;
    
    self.view.backgroundColor = [UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
    
    //ADD THE HEADER LABEL
    lblHeader = [[UILabel alloc]
                  initWithFrame:CGRectMake(0,10,320,100)];
    lblHeader.text = @"Welcome to iRET";
    lblHeader.backgroundColor = [UIColor clearColor];
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.font = [UIFont fontWithName:@"Arial-BoldMT" size:25.0];
    lblHeader.textAlignment = NSTextAlignmentCenter;
    
    //ADD THE HEADER LABEL
    lbliRET = [[UILabel alloc]
                 initWithFrame:CGRectMake(0,60,320,100)];
    lbliRET.text = @"The iOS Reverse Engineering Toolkit";
    lbliRET.backgroundColor = [UIColor clearColor];
    lbliRET.textColor = [UIColor whiteColor];
    lbliRET.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    lbliRET.textAlignment = NSTextAlignmentCenter;
    
    //ADD THE MESSAGE LABEL
    lblMessage = [[UILabel alloc]
                 initWithFrame:CGRectMake(0,100,320,100)];
    lblMessage.numberOfLines = 0;
    lblMessage.lineBreakMode = true;
    lblMessage.text = @"For on device analysis and reversing.";
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.font = [UIFont fontWithName:@"Arial-BoldMT" size:10.0];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    
    //ADD THE BUTTON
    UIButton*btnStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnStart.frame  = CGRectMake(105,175,100,35);
    btnStart.backgroundColor = [UIColor whiteColor];
    [btnStart.titleLabel setTextColor:[UIColor blackColor]];
    [btnStart.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [btnStart setTitle:@"Start" forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(btnStartPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //ADD THE IP Text LABEL
    lblIPText = [[UILabel alloc]
             initWithFrame:CGRectMake(0,225,320,100)];
    lblIPText.backgroundColor = [UIColor clearColor];
    lblIPText.textColor = [UIColor whiteColor];
    lblIPText.font = [UIFont fontWithName:@"Arial-BoldMT" size:20.0];
    lblIPText.textAlignment = NSTextAlignmentCenter;
    
    //ADD THE IP Address LABEL
    lblIPAddress = [[UILabel alloc]
                 initWithFrame:CGRectMake(0,275,320,200)];
    lblIPAddress.backgroundColor = [UIColor clearColor];
    lblIPAddress.textColor = [UIColor blackColor];
    lblIPAddress.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    lblIPAddress.textAlignment = NSTextAlignmentCenter;
    
   
    
    [self.view addSubview:lblHeader];
    [self.view addSubview:lblMessage];
    [self.view addSubview:btnStart];
    [self.view addSubview:lblIPText];
    [self.view addSubview:lblIPAddress];
    [self.view addSubview: lbliRET];
    
    
    
}

-(void) btnStartPressed:(UIButton *) sender
{
    
    //START THE LISTENER
    NSString *strIP;
    
    if (intButtonState == 0)
    {
        intButtonState = 1;
        
        @try
        {
            //change the button text to show 'Stop'
            [sender setTitle: @"Stop" forState: UIControlStateNormal];
            
            int loadResult = system("launchctl load /System/Library/LaunchDaemons/com.jensen.iRE.Startup.plist");
            NSLog(@" Load Startup Result: %i", loadResult);
            
            if(loadResult == 0)
                strIP = [self getIPAddress];
                strIP = [strIP stringByAppendingString:@":5555"];
                lblIPText.text = @"Navigate your browser to:";
                lblIPAddress.text = strIP;

        }
        @catch (NSException *exception)
        {
            NSLog( @"NSException caught ");
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason);
        }
        @finally
        {
            NSLog( @"In finally block.");
        }
    
        
    }
    else if (intButtonState == 1)
    {
        //STOP THE LISTENER
        
        intButtonState = 0;
        
        @try {
            //change the button text to show 'Start'
            [sender setTitle: @"Start" forState: UIControlStateNormal];
            int unloadStart = system("launchctl unload /System/Library/LaunchDaemons/com.jensen.iRE.Startup.plist");
            NSLog(@"Unload Start Result: %i", unloadStart);
            
            lblIPText.text = @"";
            lblIPAddress.text = @"";
            
        }
        @catch (NSException *exception) {
            NSLog( @"NSException caught ");
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason);
        }
        @finally {
            NSLog( @"In finally block.");
        }
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}


@end
