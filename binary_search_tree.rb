class Tree
    def initialize(array)
        @root = build_tree(array.sort.uniq)
    end

    def build_tree(array, start=0, ending=array.length-1)
        return nil if start > ending
        mid = (start + ending) / 2
        root_node = Node.new(array[mid])
        root_node.left_node = build_tree(array, start, mid-1)
        root_node.right_node = build_tree(array, mid+1, ending)
        root_node
    end

    def insert(value, current_node = @root)
        if find(value) != nil
            return
        elsif current_node.data > value
            if current_node.left_node == nil
                current_node.left_node = Node.new(value)
            else
                insert(value, current_node.left_node)
            end
        else
            if current_node.right_node == nil
                current_node.right_node = Node.new(value)
            else
                insert(value, current_node.right_node)
            end
        end
    end

    def delete(value, current_node = @root, parent_node = nil, parent_node_direction = nil)
        if current_node.data == value
            if current_node.left_node == nil
                if current_node.data == @root.data
                    @root = current_node.right_node
                elsif parent_node_direction == 'left'
                    parent_node.left_node = current_node.right_node
                else
                    parent_node.right_node = current_node.right_node
                end
            elsif current_node.right_node == nil
                if current_node.data == @root
                    @root = current_node.left_node
                elsif parent_node_direction == 'left'
                    parent_node.left_node = current_node.left_node
                else
                    parent_node.right_node = current_node.left_node
                end
            else
                replacement_node = current_node.right_node
                replacement_parent = current_node
                until replacement_node.left_node == nil
                    replacement_parent = replacement_node
                    replacement_node = replacement_node.left_node
                end
                if replacement_parent == current_node
                    current_node.data = replacement_node.data
                    replacement_parent.right_node = replacement_node.right_node
                else
                    current_node.data = replacement_node.data
                    replacement_parent.left_node = replacement_node.right_node
                end
            end
        elsif current_node.data > value && current_node.left_node != nil
            delete(value, current_node.left_node, current_node, 'left')
        elsif current_node.data < value && current_node.right_node != nil
            delete(value, current_node.right_node, current_node, 'right')
        end
    end

    def find(value, current_node = @root)
        if current_node.data == value
            current_node
        elsif current_node.data > value
            if current_node.left_node == nil
                nil  # value not in tree
            else
                find(value, current_node.left_node)
            end
        else
            if current_node.right_node == nil
                nil  # value not in tree
            else
                find(value, current_node.right_node)
            end
        end
    end

    def level_order  # loop
        nodes = []
        queue = [@root]
        until queue.length == 0 do
            current_node = queue.shift
            queue << current_node.left_node unless current_node.left_node == nil
            queue << current_node.right_node unless current_node.right_node == nil
            if block_given?
                yield current_node
            else
                nodes << current_node.data
            end
        end
        nodes
    end

    def level_order_rec(queue = [@root], nodes = [])  # recursion
        return nodes if queue.length == 0 && !block_given?
        return if queue.length == 0
        current_node = queue.shift
        queue << current_node.left_node unless current_node.left_node == nil
        queue << current_node.right_node unless current_node.right_node == nil
        if block_given?
            yield current_node
            level_order_rec(queue) {|node| yield(node)}
        else
            nodes << current_node.data
            level_order_rec(queue, nodes)
        end
    end

    def preorder(current_node = @root, nodes = [])
        return nodes if current_node == nil && !block_given?
        return if current_node == nil
        if block_given?
            yield current_node
            preorder(current_node.left_node) {|node| yield(node)}
            preorder(current_node.right_node) {|node| yield(node)}
        else
            nodes << current_node.data
            preorder(current_node.left_node, nodes)
            preorder(current_node.right_node, nodes)
        end
    end

    def inorder(current_node = @root, nodes = [])
        return nodes if current_node == nil && !block_given?
        return if current_node == nil
        if block_given?
            inorder(current_node.left_node) {|node| yield(node)}
            yield current_node
            inorder(current_node.right_node) {|node| yield(node)}
        else
            inorder(current_node.left_node, nodes)
            nodes << current_node.data
            inorder(current_node.right_node, nodes)
        end
    end

    def postorder(current_node = @root, nodes = [])
        return nodes if current_node == nil && !block_given?
        return if current_node == nil
        if block_given?
            postorder(current_node.left_node) {|node| yield(node)}
            postorder(current_node.right_node) {|node| yield(node)}
            yield current_node
        else
            postorder(current_node.left_node, nodes)
            postorder(current_node.right_node, nodes)
            nodes << current_node.data
        end
    end

    def height(current_node, root_node = current_node)
        return 0 if current_node == nil
        left_child_height = height(current_node.left_node, root_node)
        right_child_height = height(current_node.right_node, root_node)
        if left_child_height >= right_child_height
            return current_node == root_node ? left_child_height : left_child_height + 1  # don't add 1 if final return
        else
            return current_node == root_node ? right_child_height : right_child_height + 1
        end
    end

    def depth(depth_node, current_node = @root)
        return nil if current_node == nil
        return 0 if current_node == depth_node
        left_child_depth = depth(depth_node, current_node.left_node)
        right_child_depth = depth(depth_node, current_node.right_node)
        if left_child_depth != nil
            left_child_depth + 1
        elsif right_child_depth != nil
            right_child_depth + 1
        else
            nil
        end
    end

    def balanced?(current_node = @root)
        return true if current_node == nil
        left_child_height = height(current_node.left_node)
        right_child_height = height(current_node.right_node)
        (left_child_height - right_child_height).abs <= 1 && balanced?(current_node.left_node) && balanced?(current_node.right_node)
    end

    def rebalance
        array = inorder()
        @root = build_tree(array)
    end
end

class Node
    attr_accessor :data, :left_node, :right_node
    def initialize(data)
        @data = data
        @left_node = nil
        @right_node = nil
    end
end