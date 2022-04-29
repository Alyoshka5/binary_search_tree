require_relative '../binary_search_tree.rb'

array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)
puts tree.balanced?

p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder

array = Array.new(rand(3..6)) { rand(101..999) }
array.each {|x| tree.insert(x) }
puts tree.balanced?
tree.rebalance
puts tree.balanced?

p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder