//
//  HomeworkType+CoreDataProperties.h
//  FishCalendar
//
//  Created by Hydra on 17/2/28.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "HomeworkType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HomeworkType (CoreDataProperties)

+ (NSFetchRequest<HomeworkType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *typename; 
@property (nullable, nonatomic, retain) ClassName *toclassname;

@end

NS_ASSUME_NONNULL_END
