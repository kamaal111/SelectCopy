//
//  AXUIElementSplunker.h
//  SelectCopy
//
//  Created by Kamaal M Farah on 13/08/2023.
//

#ifndef AXUIElementSplunker_h
#define AXUIElementSplunker_h

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

@interface AXUIElementSplunker : NSObject

@property AXUIElementRef element;

- (id)init: (AXUIElementRef)element;

@end

#endif /* AXUIElementSplunker_h */
