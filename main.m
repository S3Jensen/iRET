//
//  main.m
//  iRE
//
//  Created by veracode on 11/8/13.
//  Copyright (c) 2013 veracode. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    setuid(0);
    setgid(0);
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    
}
