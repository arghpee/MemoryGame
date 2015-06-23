//
//  AppDelegate.h
//  MemoryGame
//
//  Created by Rizza on 6/22/15.
//  Copyright (c) 2015 Rizza Corella Punsalan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    GameViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

