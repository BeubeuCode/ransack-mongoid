module Ransack
  class Visitor
    def visit_and(object)
      nodes = object.values.map { |o| accept(o) }.compact
      nodes.inject(&:and)
    end

    def visit_Ransack_Nodes_Sort(object)
      object.attr.send(object.dir) if object.valid?
    end

    def quoted?(object)
      case object
      when Integer
        false
      else
        true
      end
    end

  end
end
