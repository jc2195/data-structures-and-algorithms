require 'pry'

class Tree
  attr_accessor :grid, :knight
  def initialize(position, target)
    @grid = ((0..7).to_a + (0..7).to_a).permutation(2).to_a.uniq
    @target = Node.new(target)
    @knight = build_tree(position, @target)
  end

  def build_tree(position, target)
    start = Node.new(position)
    child_array = [start]
    queue = [start]
    found_flag = false
    found_node = nil
    counter = 0
    until found_flag
      child_array.each do |node|
        if node.position == target.position
          found_node = node
          found_flag = true
        end
      end
      unless found_flag
        child_array = []
        queue.each do |node|
          node.children = populate_children(node)
          child_array += node.children
        end
        queue = child_array.dup
        counter += 1
      end
    end
    puts "You made it in #{counter} moves!  Here's your path:"
    path = path(found_node)
    print "#{start.position}\n"
    path.each { |location| print "#{location}\n" }
    start
  end

  def populate_children(node)
    position = node.position
    child_array = []
    unless position[1] + 2 > 7 || position[0] - 1 < 0
      child_array.push(Node.new([position[0] - 1, position[1] + 2], node))
    end
    unless position[1] + 2 > 7 || position[0] + 1 > 7
      child_array.push(Node.new([position[0] + 1, position[1] + 2], node))
    end
    unless position[0] + 2 > 7 || position[1] + 1 > 7
      child_array.push(Node.new([position[0] + 2, position[1] + 1], node))
    end
    unless position[0] + 2 > 7 || position[1] - 1 < 0
      child_array.push(Node.new([position[0] + 2, position[1] - 1], node))
    end
    unless position[1] - 2 < 0 || position[0] + 1 > 7
      child_array.push(Node.new([position[0] + 1, position[1] - 2], node))
    end
    unless position[1] - 2 < 0 || position[0] - 1 < 0
      child_array.push(Node.new([position[0] - 1, position[1] - 2], node))
    end
    unless position[0] - 2 < 0 || position[1] - 1 < 0
      child_array.push(Node.new([position[0] - 2, position[1] - 1], node))
    end
    unless position[0] - 2 < 0 || position[1] + 1 > 7
      child_array.push(Node.new([position[0] - 2, position[1] + 1], node))
    end
    child_array
  end

  def path(node)
    current_node = node
    path = []
    until current_node.parent.nil?
      path.push(current_node.position)
      current_node = current_node.parent
    end
    path.reverse!
    path
  end
end

class Node
  include Comparable

  attr_accessor :children, :position, :parent
  def initialize(position = nil, parent = nil, children = [])
    @position = position
    @children = []
    @parent = parent
  end

  def <=>(other)
    position <=> other.position
  end
end

def knight_moves(position, target)
  Tree.new(position, target)
end

knight_moves([3, 3], [4, 3])
