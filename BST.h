//
//  BST.h
//  TDPrototype
//
//  Created by Le Hong Trieu on 27/3/13.
//
//  Note: No thread-safe.
//  Store unique keys.

#import "BSTNode.h"

@interface BST : NSObject
{
@protected
    BSTNode* root;
    int nodeCount;
    NSComparator keyComparator;
}

-(id)initWithKeyComparator:(NSComparator)aKeyComparator;
-(int)count;
-(NSEnumerator*)objectEnumerator;
-(id)objectForKey:(id)aKey;
-(void)removeObjectForKey:(id)aKey;
-(void)insertObject:(id)anObject forKey:(id)aKey;
@end
