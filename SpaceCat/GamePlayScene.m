//
//  GamePlayScene.m
//  SpaceCat
//
//  Created by Ethan Neff on 9/2/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "GamePlayScene.h"
#import "MachineNode.h"
#import "SpaceCatNode.h"
#import "ProjectileNode.h"
#import "SpaceDogNode.h"
#import "GroundNode.h"
#import "Util.h"
#import "HudNode.h"
#import "GameOverNode.h"
#import <AVFoundation/AVFoundation.h>

// private class instance variables
@interface GamePlayScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) AVAudioPlayer *backgoundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL restart;
@property (nonatomic) BOOL gameOverDisplay;

@end

@implementation GamePlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 1.5;
        self.totalGameTime = 0;
        self.minSpeed = SPACEDOGMINSPEED;
        self.gameOver = NO;
        self.restart = NO;
        self.gameOverDisplay = NO;

        
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        //creates an instance of machine (calls the the MachineNode conviecnce constructor)
        MachineNode *machine = [MachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        // create an instance of spacecat infront of the machine
        SpaceCatNode *spaceCat = [SpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y-2)];
        [self addChild:spaceCat];
        
        [self addSpaceDog];
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8); // world gravity
        self.physicsWorld.contactDelegate = self; // impliment the delegate, the scene is the delegate for the contact delegate
        
        GroundNode *ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
        [self setupSounds];
        
        HudNode *hud = [HudNode hudAtPosition:CGPointMake(0, self.frame.size.height-20) inFrame:self.frame]; // top of screen
        [self addChild:hud];
        
    }
    return self;
}

- (void) setupSounds {
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
    
    NSURL *backgroundURL = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@".mp3"];  // file url within app package
    self.backgoundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundURL error:nil];
    self.backgoundMusic.numberOfLoops = -1; // infinite
    [self.backgoundMusic prepareToPlay]; // get ready
    
    NSURL *gameOverURL = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@".mp3"];  // file url within app package
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverURL error:nil];
    self.gameOverMusic.numberOfLoops = 1; // infinite
    [self.gameOverMusic prepareToPlay]; // get ready
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.gameOver) { // first run
        for (UITouch *touch in touches) { // handles multiple touches
            CGPoint position = [touch locationInNode:self]; // pass the x,y of scene
            [self shootProjectileTowardsPosition:position];
        }
    } else if (self.restart) { // restart mode
        // destory all the old nodes and scene
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        // run a new scene
        GamePlayScene *scene = [GamePlayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

- (void) didMoveToView:(SKView *)view {
    [self.backgoundMusic play];
}

- (void) shootProjectileTowardsPosition:(CGPoint)position {
    SpaceCatNode *spaceCat = (SpaceCatNode *)[self childNodeWithName:@"SpaceCat"]; // grab the right node
    [spaceCat performTap]; // run the function within that correct node
    
    MachineNode *machine = (MachineNode *)[self childNodeWithName:@"Machine"];
    
    // create projectile at the machine
    ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y+machine.frame.size.height-15)];
    // animate the projectile with the touch position
    [self addChild:projectile];
    [projectile moveTowardsPosition:position];
    
    [self runAction:self.laserSFX]; // play sound
}

- (void) addSpaceDog {
    NSUInteger randomSpaceDog = [Util randomWithMin:0 max:2]; // max is not inclusive (picks the image)
    
    SpaceDogNode *spaceDog = [SpaceDogNode spaceDogOfType:randomSpaceDog];
    // speed down
    float dy = [Util randomWithMin:SPACEDOGMINSPEED max:SPACEDOGMAXSPEED];
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy);
    
    float y = self.frame.size.height + spaceDog.size.height; // above the frame
    float x = [Util randomWithMin:0 max:self.frame.size.width-spaceDog.size.width]; // 10 point margin
    spaceDog.anchorPoint = CGPointMake(0,0);
    spaceDog.position = CGPointMake(x,y);

    [self addChild:spaceDog];
    
}

// game loop. progresses the game by changing variables with time
- (void) update:(NSTimeInterval)currentTime {
    if (self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) { // cannot add a dog more than 1 second
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    if (self.totalGameTime > 40) { // 8mins
        self.addEnemyTimeInterval = 0.50;
        self.minSpeed = -160;
        
    } else if (self.totalGameTime > 30) { // 4mins
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    } else if (self.totalGameTime > 20) { // 2mins
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    } else if (self.totalGameTime > 10) {  // 0.5mins
        self.addEnemyTimeInterval = 1.00;
        self.minSpeed = -100;
    }
    
    if (self.gameOver && !self.gameOverDisplay) {
        [self performGameOver];
    }
}

- (void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    // indistinguish between a = projectile or b = projectile
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // projectile hit
    if (firstBody.categoryBitMask == collisionCategoryEnemy &&
        secondBody.categoryBitMask == collisionCategoryProjectile) {
        
        SpaceDogNode *spaceDog = (SpaceDogNode *)firstBody.node;
        ProjectileNode *projectile = (ProjectileNode *)secondBody.node;
        
        [projectile removeFromParent];
//        if ([spaceDog isDamaged]) {
            [spaceDog removeFromParent];
            
            [self createDebrisAtPosition:contact.contactPoint];
            [self runAction:self.explodeSFX]; // play sound
            [self addPoints:POINTSPERHIT];
//        }
    // ground hit
    } else if (firstBody.categoryBitMask == collisionCategoryEnemy &&
               secondBody.categoryBitMask == collisionCategoryGround) {

        SpaceDogNode *spaceDog = (SpaceDogNode *)firstBody.node;
        [spaceDog removeFromParent];
        [self createDebrisAtPosition:contact.contactPoint];
        [self runAction:self.damageSFX]; // play sound
        
        [self loseLife];
    }
}

- (void) addPoints:(NSInteger)points {
    HudNode *hud = (HudNode *)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}

- (void) loseLife {
    HudNode *hud = (HudNode *)[self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}

- (void) performGameOver {
    GameOverNode *gameOver = [GameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild:gameOver];
    self.restart = YES;
    self.gameOverDisplay = YES;
    [gameOver performAnimation];
    [self.backgoundMusic stop];
    [self.gameOverMusic play];
}

- (void) createDebrisAtPosition:(CGPoint)position {
    // random the number of images
    NSInteger numberOfPieces = [Util randomWithMin:5 max:25];
    
    // random the image
    for (int i=0; i < numberOfPieces; i++) {
        NSInteger randomPieces = [Util randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%li", (long)randomPieces];
        
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        debris.name = @"debris";
        [self addChild:debris];
        
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = collisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = collisionCategoryGround | collisionCategoryDebris;
        debris.physicsBody.velocity = CGVectorMake([Util randomWithMin:-150 max:150],
                                                   [Util randomWithMin:150 max:350]);
        
        // after 2 seconds, run the block to remove the debris
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{[debris removeFromParent];}];
    }
    
    // emitter node for the sks file
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [self addChild:explosion];
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{[explosion removeFromParent];}];
}
@end
