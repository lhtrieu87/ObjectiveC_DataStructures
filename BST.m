//
//  BST.m
//  TDPrototype
//
//  Created by Le Hong Trieu on 27/3/13.
//
//

#import "BST.h"

@implementation BST
-(id)initWithKeyComparator:(NSComparator)aKeyComparator
{
    self = [super init];
    if(self)
    {
        keyComparator = aKeyComparator;
        nodeCount = 0;
        root = NULL;
    }
    
    return self;
}

- (id)init
{
	@throw [NSException exceptionWithName:@"MethodNotAllowedException" reason:@"Initialize a BST with the 'initWithKeyComparator:' method." userInfo:nil];
}

-(int)count
{
    return nodeCount;
}

-(NSEnumerator*)objectEnumerator
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[self count]];
    if(root) [root addObjectToArray:objects];
    return [objects objectEnumerator];
}

-(id)objectForKey:(id)aKey
{
    BSTNode* currentNode = root;
    while(currentNode != NULL)
    {
        NSComparisonResult compareResult = keyComparator(aKey, currentNode.key);
        if(compareResult == NSOrderedSame)
            return currentNode.value;
        else if(compareResult == NSOrderedAscending)
            currentNode = currentNode.left;
        else
            currentNode = currentNode.right;
    }
    
    return NULL;
}

-(void)removeObjectForKey:(id)aKey
{
    [self _removeObjectForKey:aKey startAtNode:root parentNode:NULL];
}

-(void)insertObject:(id)anObject forKey:(id)aKey
{
    if(root == NULL)
    {
        root = [BSTNode alloc];
        root.key = aKey;
        root.value = anObject;
        nodeCount = 1;
    }
    else
        [self internalInsertStartFromNode:root withKey:aKey value:anObject];
}


// PRIVATE METHODS.
-(void)_removeObjectForKey:(id)aKey startAtNode:(BSTNode*)node parentNode:(BSTNode*)parent
{
    if(node == NULL)
        return; // Item is not in BST.
    
    NSComparisonResult compareResult = keyComparator(aKey, node.key);
    if(compareResult == NSOrderedAscending)         // aKey < node.key.
        [self _removeObjectForKey:aKey startAtNode:node.left parentNode:node];
    else if(compareResult == NSOrderedDescending)   // aKey > node.key.
        [self _removeObjectForKey:aKey startAtNode:node.right parentNode:node];
    // Found the node which should be removed.
    else
    {
        // The removed node has both left and right childs.
        if(node.left != NULL && node.right != NULL)
        {
            // Find the smallest key which is larger than the removed node.
            BSTNode* p = node;
            BSTNode* successor = node.right;
            while(successor.left != NULL)
            {
                p = successor;
                successor = successor.left;
            }
            
            node.key = successor.key;
            node.value = successor.value;
            [self _replaceNode:successor fromParent:p newNode:successor.right];
        }
        // Only left child.
        else if(node.left != NULL)
            [self _replaceNode:node fromParent:parent newNode:node.left];
        // Only right child.
        else if(node.right != NULL)
            [self _replaceNode:node fromParent:parent newNode:node.right];
        // No child.
        else
            [self _replaceNode:node fromParent:parent newNode:NULL];
        
        nodeCount--;
    }
}

-(void)_replaceNode:(BSTNode*)replacedNode fromParent:(BSTNode*)parent newNode:(BSTNode*)newNode
{
    // The replaced node is the root node.
    if(parent == NULL && replacedNode == root)
        root = newNode;
    else
    {
        if(replacedNode == parent.left)
            parent.left = newNode;
        else if(replacedNode == parent.right)
            parent.right = newNode;
    }
}

-(void)internalInsertStartFromNode:(BSTNode*)node withKey:(id)aKey value:(id)aValue
{
    NSComparisonResult compareResult = keyComparator(aKey, node.key);
    // Update the existing key with new value.
    if(compareResult == NSOrderedSame)
    {
        node.value = aValue;
    }
    else if(compareResult == NSOrderedAscending)
    {
        if(node.left)
            [self internalInsertStartFromNode:node.left withKey:aKey value:aValue];
        else
        {
            BSTNode* newNode = [BSTNode alloc];
            newNode.key = aKey;
            newNode.value = aValue;
            
            node.left = newNode;
            
            nodeCount++;
        }
    }
    else
    {
        if(node.right)
            [self internalInsertStartFromNode:node.right withKey:aKey value:aValue];
        else
        {
            BSTNode* newNode = [BSTNode alloc];
            newNode.key = aKey;
            newNode.value = aValue;
            
            node.right = newNode;
            nodeCount++;
        }
    }
}

@end
