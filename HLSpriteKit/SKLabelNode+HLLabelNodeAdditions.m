//
//  SKLabelNode+HLLabelNodeAdditions.m
//  HLSpriteKit
//
//  Created by Karl Voskuil on 6/3/14.
//  Copyright (c) 2014 Hilo Games. All rights reserved.
//

#import "SKLabelNode+HLLabelNodeAdditions.h"

@implementation SKLabelNode (HLLabelNodeAdditions)

- (void)getAlignmentForHLVerticalAlignmentMode:(HLLabelNodeVerticalAlignmentMode)hlVerticalAlignmentMode
                       skVerticalAlignmentMode:(SKLabelVerticalAlignmentMode *)skVerticalAlignmentMode
                                   labelHeight:(CGFloat *)labelHeight
                                       yOffset:(CGFloat *)yOffset
{
  // note: For the record: I have no idea about the performance of this, especially
  // if dealing with lots of labels that may or may not share the same font name
  // and font size.

  switch (hlVerticalAlignmentMode) {

    case HLLabelNodeVerticalAlignText:
      if (skVerticalAlignmentMode) {
        *skVerticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
      }
      if (labelHeight) {
        *labelHeight = self.frame.size.height;
      }
      if (yOffset) {
        *yOffset = 0.0f;
      }
      break;

    case HLLabelNodeVerticalAlignFont: {
#if TARGET_OS_IPHONE
      UIFont *font = [UIFont fontWithName:self.fontName size:self.fontSize];
#else
      NSFont *font = [NSFont fontWithName:self.fontName size:self.fontSize];
#endif
      if (!font) {
        [NSException raise:@"HLLabelNodeUnknownFont" format:@"Could not find font \"%@\".", self.fontName];
      }
      if (skVerticalAlignmentMode) {
        *skVerticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
      }
#if TARGET_OS_IPHONE
      CGFloat lineHeight = font.lineHeight;
#else
      // TODO: Check this; should this be ascender + (-)descender + leading?
      CGFloat lineHeight = font.leading;
#endif
      if (labelHeight) {
        *labelHeight = lineHeight;
      }
      if (yOffset) {
        *yOffset = -lineHeight / 2.0f - font.descender;
      }
      break;
    }
      
    case HLLabelNodeVerticalAlignFontAscender: {
#if TARGET_OS_IPHONE
      UIFont *font = [UIFont fontWithName:self.fontName size:self.fontSize];
#else
      NSFont *font = [NSFont fontWithName:self.fontName size:self.fontSize];
#endif
      if (!font) {
        [NSException raise:@"HLLabelNodeUnknownFont" format:@"Could not find font \"%@\".", self.fontName];
      }
      if (skVerticalAlignmentMode) {
        *skVerticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
      }
      if (labelHeight) {
        *labelHeight = font.ascender;
      }
      if (yOffset) {
        *yOffset = -font.ascender / 2.0f;
      }
      break;
    }

    case HLLabelNodeVerticalAlignFontAscenderBias: {
#if TARGET_OS_IPHONE
      UIFont *font = [UIFont fontWithName:self.fontName size:self.fontSize];
#else
      NSFont *font = [NSFont fontWithName:self.fontName size:self.fontSize];
#endif
      if (!font) {
        [NSException raise:@"HLLabelNodeUnknownFont" format:@"Could not find font \"%@\".", self.fontName];
      }
      if (skVerticalAlignmentMode) {
        *skVerticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
      }
      if (labelHeight) {
        *labelHeight = font.ascender + font.descender / 2.0f;
      }
      if (yOffset) {
        *yOffset = -font.ascender / 2.0f - font.descender / 4.0f;
      }
      break;
    }

    default:
      [NSException raise:@"HLLabelNodeUnknownVerticalAlignmentMode" format:@"Unknown vertical alignment mode %ld.", (long)hlVerticalAlignmentMode];
  }
}

- (void)alignForHLVerticalAlignmentMode:(HLLabelNodeVerticalAlignmentMode)hlVerticalAlignmentMode
{
  CGFloat yOffset;
  SKLabelVerticalAlignmentMode skVerticalAlignmentMode;
  [self getAlignmentForHLVerticalAlignmentMode:hlVerticalAlignmentMode
                       skVerticalAlignmentMode:&skVerticalAlignmentMode
                                   labelHeight:nil
                                     yOffset:&yOffset];
  self.verticalAlignmentMode = skVerticalAlignmentMode;
  CGPoint position = self.position;
  position.y += yOffset;
  self.position = position;
}

@end
