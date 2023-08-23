//
//  AXTextMarkerRangeSplunker.h
//  SelectCopy
//
//  Created by Kamaal M Farah on 23/08/2023.
//

#ifndef AXTextMarkerRangeSplunker_h
#define AXTextMarkerRangeSplunker_h

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

@interface AXTextMarkerRangeSplunker : NSObject

@property AXTextMarkerRangeRef markerRange;

- (id)init: (AXTextMarkerRangeRef)markerRange;

@end

#endif /* AXTextMarkerRangeSplunker_h */
