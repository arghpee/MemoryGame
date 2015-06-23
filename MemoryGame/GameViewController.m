//
//  GameViewController.m
//  MemoryGame
//
//  Created by Rizza on 6/22/15.
//  Copyright (c) 2015 Rizza Corella Punsalan. All rights reserved.
//

#import "GameViewController.h"
#define IMG_CARD_BACK_INDEX 8
#define FLIP_DELAY 1.0
#define WIN_DELAY 0.5
#define INITIAL_TIMER_VALUE 100

@interface GameViewController ()

@end

@implementation GameViewController {
    NSInteger timer;
    BOOL timerRunning;
}

@synthesize board;
@synthesize cards;
@synthesize pairsFound;
@synthesize flippedCards;
@synthesize firstButtonIndex;
@synthesize currButtonIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self fillCardsArray]; // fill cards array with card images
    [self initBoard]; // initialize board
    [self startTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cardClicked:(id)sender {
    NSLog(@"Current Button Index: %lu", currButtonIndex);
    if (flippedCards < 2) { // card is initially facing down
        currButtonIndex = [self.buttons indexOfObject:sender];
        [self faceCardWithThisIndexUp:currButtonIndex];
        
        flippedCards++;
        
        if (flippedCards == 1) {
            firstButtonIndex = currButtonIndex;
        }
        else if (flippedCards == 2) {
            if ([self doesFirstButtonMatchCurrentButton]) {
                pairsFound++;
                [self disableFirstAndCurrentButtons];
                self.scoreLabel.text = [NSString stringWithFormat:@"%lu", self.pairsFound];
                if (pairsFound == 8) {
                    [NSTimer scheduledTimerWithTimeInterval:WIN_DELAY
                                                     target:self
                                                   selector:@selector(winGame)
                                                   userInfo:nil
                                                    repeats:NO];
                }
            }
            else {
                [self disableAllButtons];
                [NSTimer scheduledTimerWithTimeInterval:FLIP_DELAY
                                                 target:self
                                               selector:@selector(faceLastTwoCardsDown)
                                               userInfo:nil
                                                repeats:NO];
            }
            flippedCards = 0;
        }
    }
}

-(void)faceCardWithThisIndexUp:(NSInteger)cardIndex {
    NSUInteger imgIndex = (NSUInteger) [[self.board objectAtIndex:(NSUInteger) cardIndex] intValue];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[self.cards objectAtIndex:imgIndex] forState:UIControlStateNormal];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[self.cards objectAtIndex:imgIndex] forState:UIControlStateDisabled];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[self.cards objectAtIndex:imgIndex] forState:UIControlStateSelected];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setEnabled:NO];
}

-(void)faceCardWithThisIndexDown:(NSInteger)cardIndex {
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[self.cards objectAtIndex:IMG_CARD_BACK_INDEX] forState:UIControlStateNormal];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[self.cards objectAtIndex:IMG_CARD_BACK_INDEX] forState:UIControlStateDisabled];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setImage:[self.cards objectAtIndex:IMG_CARD_BACK_INDEX] forState:UIControlStateDisabled];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setEnabled:YES];
    [[self.buttons objectAtIndex:(NSUInteger) cardIndex] setSelected:NO];
}

-(void)faceLastTwoCardsDown {
    NSLog(@"Facing Down Card %lu", firstButtonIndex);
    [self faceCardWithThisIndexDown:firstButtonIndex];
    NSLog(@"Facing Down Card %lu", currButtonIndex);
    [self faceCardWithThisIndexDown:currButtonIndex];
    [self reenableUnmatchedButtons];
}

-(BOOL)doesFirstButtonMatchCurrentButton {
    if ([[self.board objectAtIndex:firstButtonIndex] intValue] == [[self.board objectAtIndex:currButtonIndex] intValue]) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)fillCardsArray {
    self.cards = [NSArray arrayWithObjects:[UIImage imageNamed:@"Card0.png"],
             [UIImage imageNamed:@"Card1.png"],
             [UIImage imageNamed:@"Card2.png"],
             [UIImage imageNamed:@"Card3.png"],
             [UIImage imageNamed:@"Card4.png"],
             [UIImage imageNamed:@"Card5.png"],
             [UIImage imageNamed:@"Card6.png"],
             [UIImage imageNamed:@"Card7.png"],
             [UIImage imageNamed:@"CardBack.png"],
             nil];
}

-(void)initBoard {
    self.board = [[NSMutableArray alloc]initWithCapacity:16];
    
    for(int i = 0; i < 16; i++){
        [self.board addObject:[[NSNumber alloc] initWithInt:-1 ]];
    }
    
    [self fillBoard];
    [self faceDownAllCards];
}

-(void)fillBoard {
    for(int i = 0; i < 8; i++){
        
        for(int j = 0; j <2; j++){
            
            int randomSlot = arc4random() % 16;
            while([[board objectAtIndex:randomSlot] intValue] != -1){
                randomSlot = arc4random() % 16;
            }
            NSLog(@"Assigning %d to slot %d\n", i, randomSlot);
            [self.board replaceObjectAtIndex:randomSlot withObject:[[NSNumber alloc] initWithInteger: i]];
            NSLog(@"Slot %d now contains %d\n", randomSlot, [[self.board objectAtIndex:randomSlot] intValue]);
        }
        
    }
    
    NSLog(@"The BOARD: @%@", board);
    flippedCards = 0;
    pairsFound = 0;
    self.scoreLabel.text = @"0";
}

-(void)reinitBoard {
    for (int i = 0; i < 16; i++) {
        [self.board replaceObjectAtIndex:i withObject:[[NSNumber alloc] initWithInt:-1]];
    }
    [self fillBoard];
    [self faceDownAllCards];
    [self startTimer];
}

-(void)faceDownAllCards {
    for (int i = 0; i < 16; i++) {
        [self faceCardWithThisIndexDown:i];
    }
}

-(void)disableFirstAndCurrentButtons {
    NSLog(@"Disabling button with tag %lu", firstButtonIndex);
    [[self.buttons objectAtIndex:firstButtonIndex] setEnabled:NO];
    [[self.buttons objectAtIndex:firstButtonIndex] setSelected:YES];
    NSLog(@"Disabling button with tag %lu", currButtonIndex);
    [[self.buttons objectAtIndex:currButtonIndex] setEnabled:NO];
    [[self.buttons objectAtIndex:currButtonIndex] setSelected:YES];
}

-(void)disableAllButtons {
    for (int i = 0; i < 16; i++) {
        [[self.buttons objectAtIndex:i] setEnabled:NO];
    }
}

-(void)reenableUnmatchedButtons {
    UIButton* button;
    for (int i = 0; i < 16; i++) {
        button = (UIButton *) [self.buttons objectAtIndex:i];
        if (!button.selected) {
            [button setEnabled:YES];
        }
    }

}

-(void)winGame {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hooray!" message:@"You won the game!" delegate:self cancelButtonTitle:@"Play again" otherButtonTitles:nil];
    alertView.tag = 200;
    timerRunning = NO;
    [alertView show];
}

-(void)loseGame {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Time is up!" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil];
    alertView.tag = 100;
    [alertView show];
}

-(void)startTimer {
    timer = INITIAL_TIMER_VALUE;
    self.timeRemaining.text = [NSString stringWithFormat:@"%lu", timer];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(decrementTimer)
                                   userInfo:nil
                                    repeats:NO];
    timerRunning = YES;
}

-(void)decrementTimer {
    if (timerRunning) {
        timer--;
        self.timeRemaining.text = [NSString stringWithFormat:@"%lu", timer];
        if (timer == 0) {
            [self loseGame];
        }
        else {
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(decrementTimer)
                                           userInfo:nil
                                            repeats:NO];
        }

    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ((alertView.tag == 100 || alertView.tag == 200) && buttonIndex == 0) {
        [self reinitBoard];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
