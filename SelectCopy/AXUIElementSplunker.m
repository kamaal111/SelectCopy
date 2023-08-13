//
//  AXUIElementSplunker.m
//  SelectCopy
//
//  Created by Kamaal M Farah on 13/08/2023.
//

#import "AXUIElementSplunker.h"

@implementation AXUIElementSplunker

- (id)init:(AXUIElementRef)element {
    self = [super init];
    self.element = element;
    return self;
}

@end
