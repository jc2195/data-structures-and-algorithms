# Data Structures and Algorithms
This project contains my solutions for the data structures and algorithms Ruby section of The Odin Project.

## Binary Search Trees
balanced-BST.rb is my implementation of a balanced binary search tree.

### Classes:
1. Node class with attributes for the data it stores as well as its left and right children. Includes the Comparable module and makes nodes compare using their data attribute.
2. Tree class which accepts an array when initialized, and has a root attribute which uses the return value of #build_tree.

### Methods:
1. #build_tree takes an array of data (e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) and turns it into a balanced binary tree full of Node objects appropriately placed.
2. #insert which accepts a value and inserts it appropriately into the tree.
3. #delete which accepts a value and deletes it appropriately from the tree.
4. #find which accepts a value and returns the node with the given value.
5. #level_order returns an array of values, traversing the tree in breadth-first level order.
6. #inorder, #preorder, and #postorder return an array of values. Each method traverses the tree in their respective depth-first order.
7. #height accepts a node and returns its height.
8. #depth accepts a node and returns the depth(number of levels) beneath the root.
9. #balanced? checks if the tree is balanced.
10. #rebalance rebalances an unbalanced tree. 


## Knight's Travails
knight_moves.rb is a program that returns the shortest possible path that a knight in chess can take to reach a grid square from a given starting position.

### Classes:
1. Tree class which represents the board, the knight, and the tree of possible paths. It accepts a starting coordinate and a target coordinate.
2. Node class which holds information about the coordinate position, its children and its parent node. The comparable module is used so that nodes are compared by their position.

### Methods:
1. #build_tree progressively builds the path tree level by level. In order to eliminate the possibility of going into an infinite loop, I decided to use breadth-first traversal. Once a new level is created, all nodes on that level are checked to see whether their position matches that of the target. once they do, tree creation is terminated at that level. The depth of the tree gives the minimum number of moves.
2. #populate_children takes a node, and adds all of the possible children to the node in the form of an array.
3. #path takes the leaf which corresponds to the target coordinates and traces the path back to the root, adding the coordinates of each node along the way to an array, so that not only the number of moves, but also the actual coordinates of the path can be returned.