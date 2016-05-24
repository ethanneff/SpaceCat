//
//  TitleScene.m
//  SpaceCat
//
//  Created by Ethan Neff on 9/2/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "TitleScene.h"
#import "GamePlayScene.h"
#import <AVFoundation/AVFoundation.h>


// class extension
@interface TitleScene ()

@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgoundMusic;

@end

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@".mp3"];  // file url within app package

        self.backgoundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgoundMusic.numberOfLoops = -1; // infinite
        [self.backgoundMusic prepareToPlay]; // get ready
    }
    return self;
}


- (void) didMoveToView:(SKView *)view {
    [self.backgoundMusic play];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.backgoundMusic stop];
    [self runAction:self.pressStartSFX]; // play sound
    
    GamePlayScene *gamePlayScene = [GamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    
    [self.view presentScene:gamePlayScene transition:transition];
}

@end