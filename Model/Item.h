//
//  Item.h
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject {
@protected
    NSInteger _x;
    NSInteger _y;
}


@property (readonly, nonatomic) NSInteger x;
@property (readonly, nonatomic) NSInteger y;

-(void) placeAtX: (NSInteger) x  y: (NSInteger) y;



@end
