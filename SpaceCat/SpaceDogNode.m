//
//  SpaceDogNode.m
//  SpaceCat
//
//  Created by Ethan Neff on 9/3/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "SpaceDogNode.h"
#import "Util.h"

@implementation SpaceDogNode

// create scene (convenience contructor)
+ (instancetype) spaceDogOfType:(spaceDogType)type {
    SpaceDogNode *spaceDog; // local variable
    spaceDog.damaged = NO;

    NSArray *textures;
    if (type == spaceDogTypeA) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_a_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_a_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_a_2"]];
        spaceDog.type = spaceDogTypeA;
    } else {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_b_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_b_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_b_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_b_3"]];
        spaceDog.type = spaceDogTypeB;
    }
    // random the size
    float scale = [Util randomWithMin:85 max:100] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [spaceDog runAction:[SKAction repeatActionForever:animation]];
    
    [spaceDog setupPhysicsBody];
    
    return spaceDog;
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO; // no freefall
    self.physicsBody.categoryBitMask = collisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0; // doest not collide with anything
    self.physicsBody.contactTestBitMask = collisionCategoryProjectile | collisionCategoryGround; // projectile or ground   == 0010 | 1000 = 1010
}

- (BOOL) isDamaged {
    NSArray *textures;
    
    if (!_damaged) { // the node instance is not damaged, then make it damanged
        [self removeActionForKey:@"animation"]; // remove the texture change animation
        if (self.type == spaceDogTypeA) {
            textures = @[[SKTexture textureWithImageNamed:@"spacedog_a_3"]];
        } else {
            textures = @[[SKTexture textureWithImageNamed:@"spacedog_b_4"]];
        }
        
        SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
        [self runAction:[SKAction repeatActionForever:animation] withKey:@"damange_animation"];
        
        _damaged = YES;
        return NO;
    }
    return _damaged;
}

@end
