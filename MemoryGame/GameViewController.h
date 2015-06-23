//
//  GameViewController.h
//  MemoryGame
//
//  Created by Rizza on 6/22/15.
//  Copyright (c) 2015 Rizza Corella Punsalan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UIAlertViewDelegate>

@property (retain) NSMutableArray *board;
@property (retain) NSArray *cards;

@property (assign) NSInteger pairsFound;
@property (assign) NSInteger flippedCards;
@property (assign) NSInteger firstButtonIndex;
@property (assign) NSInteger currButtonIndex;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
-(IBAction)cardClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRemaining;


@end
