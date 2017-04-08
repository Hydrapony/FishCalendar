//
//  ClassName+CoreDataProperties.h
//  
//
//  Created by Hydra on 17/3/16.
//
//

#import "ClassName+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClassName (CoreDataProperties)

+ (NSFetchRequest<ClassName *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *homeworkname;
@property (nullable, nonatomic, copy) NSString *img;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *attribute1;
@property (nullable, nonatomic, retain) NSSet<HomeworkType *> *havehomework;

@end

@interface ClassName (CoreDataGeneratedAccessors)

- (void)addHavehomeworkObject:(HomeworkType *)value;
- (void)removeHavehomeworkObject:(HomeworkType *)value;
- (void)addHavehomework:(NSSet<HomeworkType *> *)values;
- (void)removeHavehomework:(NSSet<HomeworkType *> *)values;

@end

NS_ASSUME_NONNULL_END
