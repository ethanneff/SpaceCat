//
//  MachineNode.m
//  SpaceCat
//
//  Created by Ethan Neff on 9/2/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "MachineNode.h"

@implementation MachineNode

// create machine object (convenience contructor)
+ (instancetype) machineAtPosition:(CGPoint)position {
    MachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"]; // create instance of machine (variable of the class to return later)
    
    // characteristics
    machine.position = position;
    machine.zPosition = 8;
    machine.anchorPoint = CGPointMake(0.5,0);
    machine.name = @"Machine";
    
    // want animation repeated forever (constantly animating)
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"],
                          [SKTexture textureWithImageNamed:@"machine_2"]];
    
    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    [machine runAction:machineRepeat];
    
    return machine; // return the instance
}

@end
