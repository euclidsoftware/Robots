//
//  Arena.m
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "Arena.h"

@implementation Arena

- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[Player alloc] init];
        _playerStartX = 10;
        _playerStartY = 10;
        _width = 20;
        _height = 20;
        [self restartGame];
    }
    return self;
}


-(void)restartGame {
    [self.player moveToX:self.playerStartX y:self.playerStartY];
}

@end
