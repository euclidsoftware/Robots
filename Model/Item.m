//
//  Item.m
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "Item.h"

@interface Item ()

@property (assign, nonatomic) BOOL placed;

@end

@implementation Item

-(void)placeAtX:(NSInteger)x y:(NSInteger)y {
    if (self.placed == NO) {
        _x = x;
        _y = y;
        self.placed = YES;
    }
}

@end
