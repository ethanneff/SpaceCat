//
//  SpaceCatNode.m
//  SpaceCat
//
//  Created by Ethan Neff on 9/2/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "SpaceCatNode.h"

// class extension (private variables to the class)
@interface SpaceCatNode () // empty parentheses to symbolize private varibles of the class

@property (nonatomic) SKAction *tapAction;

@end

@implementation SpaceCatNode

// convience constructor
+ (instancetype) spaceCatAtPosition:(CGPoint)position {
    SpaceCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"]; // create instance of machine
    spaceCat.position = position;
    spaceCat.zPosition = 9;
    spaceCat.anchorPoint = CGPointMake(0.5,0);
    spaceCat.name = @"SpaceCat"; // each node can have a unique name
    
    return spaceCat; // return the instance
}

// override getter of the property
- (SKAction *) tapAction {
    if( _tapAction != nil ) { // the private instance variable
        return _tapAction;
    }
    // if not already initalized, then initalize it
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"spacecat_2"],
                          [SKTexture textureWithImageNamed:@"spacecat_1"]];
    
    
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
    return _tapAction;
}

- (void) performTap {
    [self runAction:self.tapAction]; // run the property
}

@end
