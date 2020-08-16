require 'pry'

class Node
  include Comparable

  attr_accessor :value, :left_child, :right_child

  def <=>(other)
    value <=> other.value
  end

  def initialize(value = nil, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end
end

class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array
    @root = build_tree(array)
  end

  def build_tree(array)
    sorted_array = array.uniq.sort
    how_long = sorted_array.length
    if how_long == 1
      value = sorted_array[0]
      left = nil
      right = nil
    elsif how_long == 2
      root_position = how_long / 2 - 1
      value = sorted_array[root_position]
      left = nil
      right = build_tree(sorted_array.slice(root_position + 1, root_position + 1))
    elsif how_long.even?
      root_position = how_long / 2 - 1
      value = sorted_array[root_position]
      left = build_tree(sorted_array.slice(0, root_position))
      right = build_tree(sorted_array.slice(root_position + 1, root_position + 1))
    else
      root_position = (how_long + 1) / 2 - 1
      value = sorted_array[root_position]
      left = build_tree(sorted_array.slice(0, root_position))
      right = build_tree(sorted_array.slice(root_position + 1, root_position))
    end
    Node.new(value, left, right)
  end

  def insert(value)
    value = Node.new(value)
    node = @root
    duplicate_flag = false
    until node.left_child.nil? && node.right_child.nil? || duplicate_flag
      if value == node
        duplicate_flag = true
      else
        node = value < node ? node.left_child : node.right_child
      end
    end
    unless duplicate_flag
      value < node ? node.left_child = value : node.right_child = value
    end
  end

  def delete(value)
    target_node = find(value)
    node = @root
    found_flag = false
    if target_node.left_child.nil? && target_node.right_child.nil?
      until found_flag
        if node.left_child == target_node
          node.left_child = nil
          found_flag = true
        elsif node.right_child == target_node
          node.right_child = nil
          found_flag = true
        else
          node = target_node < node ? node.left_child : node.right_child
        end
      end
    elsif target_node.left_child.nil? || target_node.right_child.nil?
      until found_flag
        if node.left_child == target_node
          if node.left_child.left_child.nil?
            node.left_child = node.left_child.right_child
          else 
            node.left_child = node.left_child.left_child
          end
          found_flag = true
        elsif node.right_child == target_node
          if node.right_child.left_child.nil?
            node.right_child = node.right_child.right_child
          else 
            node.right_child = node.right_child.left_child
          end
          found_flag = true
        else
          node = target_node < node ? node.left_child : node.right_child
        end
      end
    else 
      delete_dual_child(value)
    end
  end

  def delete_dual_child(value)
    target_node = find(value)
    swap_node = nil
    node = target_node.right_child
    found_flag = false
    until found_flag
      if node.left_child.nil?
        swap_node = node
        found_flag = true
      else
        node = node.left_child
      end
    end
    delete(swap_node.value)
    node = @root
    found_flag = false
    until found_flag
      if node == target_node
        @root = Node.new(swap_node.value, target_node.left_child, target_node.right_child)
        found_flag = true
      elsif node.left_child == target_node
        node.left_child = Node.new(swap_node.value, target_node.left_child, target_node.right_child)
        found_flag = true
      elsif node.right_child == target_node
        node.right_child = Node.new(swap_node.value, target_node.left_child, target_node.right_child)
        found_flag = true
      else
        node = target_node < node ? node.left_child : node.right_child
      end
    end
  end

  def find(value)
    value = Node.new(value)
    node = @root
    found_flag = false
    until node.nil? || found_flag
      if value == node
        found_flag = true
      else
        node = value < node ? node.left_child : node.right_child
      end
    end
    found_flag ? node : nil
  end

  def level_order
    result = []
    node = @root
    queue = [node]
    until queue.empty?
      result.push(queue.first.value)
      unless queue.first.left_child.nil?
        queue.push(queue.first.left_child)
      end
      unless queue.first.right_child.nil?
        queue.push(queue.first.right_child)
      end
      queue.shift
    end
    result
  end

  def preorder
    result = []
    start_node = @root
    preorder_loop = lambda do |node|
      unless node.nil?
        result.push(node.value)
        preorder_loop.call(node.left_child)
        preorder_loop.call(node.right_child)
      end
    end
    preorder_loop.call(start_node)
    result
  end

  def inorder
    result = []
    start_node = @root
    inorder_loop = lambda do |node|
      unless node.nil?
        inorder_loop.call(node.left_child)
        result.push(node.value)
        inorder_loop.call(node.right_child)
      end
    end
    inorder_loop.call(start_node)
    result
  end

  def postorder
    result = []
    start_node = @root
    postorder_loop = lambda do |node|
      unless node.nil?
        postorder_loop.call(node.left_child)
        postorder_loop.call(node.right_child)
        result.push(node.value)
      end
    end
    postorder_loop.call(start_node)
    result
  end

  def height(current_node)
    how_tall = 0
    start_node = current_node
    height_loop = lambda do |node|
      if node.nil?
        -1
      else
        if height_loop.call(node.left_child) > height_loop.call(node.right_child)
          how_tall = height_loop.call(node.left_child) + 1
        else
          how_tall = height_loop.call(node.right_child) + 1
        end
      end
    end
    height_loop.call(start_node)
    how_tall
  end

  def depth(node)
    target_node = node
    current_node = @root
    found_flag = false
    how_deep = 1
    until current_node.nil? || found_flag
      if target_node == current_node
        found_flag = true
      else
        how_deep += 1
        current_node = (target_node < current_node ? current_node.left_child : current_node.right_child)
      end
    end
    found_flag ? how_deep : nil
  end

  def balanced?
    flag = true
    current_node = @root
    balanced_loop = lambda do |node|
      unless node.nil?
        if (height(node.left_child) - height(node.right_child)).magnitude > 2
          flag = false
        end
        balanced_loop.call(node.left_child)
        balanced_loop.call(node.right_child)
      end
    end
    balanced_loop.call(current_node)
    flag
  end

  def rebalance
    initialize(level_order)
  end

  def pretty_print(node = @root, prefix="", is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? "│ " : " "}", false) if node.right_child
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value.to_s}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? " " : "│ "}", true) if node.left_child
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
puts tree.balanced?
print "Level order: #{tree.level_order} \n"
print "Preorder: #{tree.preorder} \n"
print "Inorder: #{tree.inorder} \n"
print "Postorder: #{tree.postorder} \n"
tree.insert(200)
tree.insert(300)
tree.insert(900)
tree.insert(500)
tree.insert(800)
tree.pretty_print
puts tree.balanced?
tree.rebalance
tree.pretty_print
puts tree.balanced?
print "Level order: #{tree.level_order} \n"
print "Preorder: #{tree.preorder} \n"
print "Inorder: #{tree.inorder} \n"
print "Postorder: #{tree.postorder} \n"
