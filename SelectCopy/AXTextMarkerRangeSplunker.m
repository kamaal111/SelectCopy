//
//  AXTextMarkerRangeSplunker.m
//  SelectCopy
//
//  Created by Kamaal M Farah on 23/08/2023.
//

#import "AXTextMarkerRangeSplunker.h"

@implementation AXTextMarkerRangeSplunker

- (id)init:(AXTextMarkerRangeRef)markerRange {
    self = [super init];
    self.markerRange = markerRange;
    return self;
}

@end
