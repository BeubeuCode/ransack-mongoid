module Ransack
  module Nodes
    class Condition

      def arel_predicate
        predicates = attributes.map do |attr|
          attr.attr.send(
            arel_predicate_for_attribute(attr),
            formatted_values_for_attribute(attr)
          )
        end

        if predicates.size > 1 && combinator == 'and'
          predicates.inject(&:and)
        else
          predicates.inject(&:or)
        end
      end

      # Override to avoid Arel::Nodes::Quoted wrapping (Arel is not loaded for Mongoid).
      # MongoDB uses regex/native operators, not SQL literals.
      def formatted_values_for_attribute(attr)
        formatted = casted_values_for_attribute(attr).map do |val|
          val = attr.ransacker.formatter.call(val) if attr.ransacker&.formatter
          predicate.format(val)
        end
        predicate.wants_array ? formatted : formatted.first
      end

    end # Condition
  end
end
