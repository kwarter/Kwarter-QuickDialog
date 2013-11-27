//
// Copyright 2012 Ludovic Landry - http://about.me/ludoviclandry
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "QImageTableViewCell.h"
#import "QImageElement.h"

static NSString *kDetailImageValueObservanceContext = @"imageValue";

@interface QImageTableViewCell ()
@property (nonatomic, retain) QImageElement *imageElement;
@end

@implementation QImageTableViewCell

@synthesize imageElement = _imageElement;
@synthesize imageValueView = _imageValueView;
@synthesize imageValueViewMargin = _imageValueViewMargin;

- (QImageTableViewCell *)init {
    self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformImageElement"];
    if (self){
        [self createSubviews];
        self.imageValueViewMargin = 2.f;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        [self addObserver:self forKeyPath:@"imageElement.imageValue" options:0 context:(__bridge void *)(kDetailImageValueObservanceContext)];
    }
    return self;
}

- (void)createSubviews {
    _imageValueView = [[UIImageView alloc] init];
    _imageValueView.contentMode = UIViewContentModeScaleAspectFill;
    _imageValueView.layer.cornerRadius = 7.0f;
    _imageValueView.layer.masksToBounds = YES;
    _imageValueView.layer.borderWidth = 1.0f;
    _imageValueView.layer.borderColor = [UIColor colorWithWhite:0.2f alpha:0.4f].CGColor;
    _imageValueView.contentMode = UIViewContentModeScaleAspectFill;
    _imageValueView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    _imageValueView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [self.contentView addSubview:_imageValueView];
    [self setNeedsLayout];
}

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)tableView {
    [super prepareForElement:element inTableView:tableView];
    
    self.imageElement = (QImageElement *)element;
    
    self.imageView.image = self.imageElement.image;
    self.imageValueView.image = self.imageElement.imageValue;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self recalculateDetailImageViewPosition];
}

- (void)recalculateDetailImageViewPosition {
    
    CGFloat imageSize = self.contentView.frame.size.height - 2 * self.imageValueViewMargin;
    
    _imageValueView.frame = CGRectMake(self.contentView.frame.size.width - self.imageValueViewMargin - imageSize,
                                       self.imageValueViewMargin, imageSize, imageSize);
    _imageElement.parentSection.entryPosition = _imageValueView.frame;
    
    CGRect labelFrame = self.textLabel.frame;
    CGFloat extra = (_entryElement.image == NULL) ? 10.0f : _entryElement.image.size.width + 20.0f;
    self.textLabel.frame = CGRectMake(labelFrame.origin.x, labelFrame.origin.y,
                                      _imageElement.parentSection.entryPosition.origin.x - extra - self.imageValueViewMargin, labelFrame.size.height);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == (__bridge void *)(kDetailImageValueObservanceContext)) {
        self.imageValueView.image = self.imageElement.imageValue;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"imageElement.imageValue" context:(__bridge void *)(kDetailImageValueObservanceContext)];
}

@end
