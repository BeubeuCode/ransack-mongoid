require 'ransack/context'

module Ransack
  module Adapters
    module Mongoid
      class Context < ::Ransack::Context

        def initialize(object, options = {})
          @object = relation_for(object)
          @klass  = @object.klass
          @search_key = options[:search_key] || Ransack.options[:search_key]
          @base = @klass
        end

        def relation_for(object)
          object.all
        end

        def type_for(attr)
          return nil unless attr && attr.valid?
          name    = attr.arel_attribute.name.to_s.split('.').last
          # table   = attr.arel_attribute.relation.table_name

          # schema_cache = @engine.connection.schema_cache
          # raise "No table named #{table} exists" unless schema_cache.table_exists?(table)
          # schema_cache.columns_hash(table)[name].type

          # when :date
          # when :datetime, :timestamp, :time
          # when :boolean
          # when :integer
          # when :float
          # when :decimal
          # else # :string

          name = '_id' if name == 'id'

          bind_pair = bind_pair_for(attr.name)
          t = object.klass.fields[name].try(:type) ||
              (bind_pair && bind_pair.first&.fields&.[](name)&.type)
          return nil unless t

          t.to_s.demodulize.underscore.to_sym
        end

        def evaluate(search, opts = {})
          viz = Visitor.new
          accepted = viz.accept(search.base)
          relation = accepted ? @object.where(accepted) : @object.all
          if search.sorts.any?
            ary_sorting = viz.accept(search.sorts)
            sorting = {}
            ary_sorting.each do |s|
              sorting.merge! Hash[s.map { |k, d| [k.to_s == 'id' ? '_id' : k, d] }]
            end
            relation = relation.order_by(sorting)
            # relation = relation.except(:order)
            # .reorder(viz.accept(search.sorts))
          end
          # -- mongoid has different distinct method
          # opts[:distinct] ? relation.distinct : relation
          relation
        end

        def attribute_method?(str, klass = @klass)
          exists = false
          if ransackable_attribute?(str, klass)
            exists = true
          elsif (segments = str.split(Constants::UNDERSCORE)).size > 1
            remainder = []
            found_assoc = nil
            while !found_assoc && remainder.unshift(
              segments.pop) && segments.size > 0 do
              assoc, poly_class = unpolymorphize_association(
                segments.join('_')
                )
              if found_assoc = get_association(assoc, klass)
                exists = attribute_method?(remainder.join('_'),
                  poly_class || found_assoc.klass
                )
              end
            end
          end
          exists
        end

        def table_for(parent)
          # parent.table
          Ransack::Adapters::Mongoid::Table.new(parent)
        end

        def klassify(obj)
          if Class === obj && obj.ancestors.include?(::Mongoid::Document)
            obj
          elsif obj.respond_to? :klass
            obj.klass
          elsif obj.respond_to? :base_klass
            obj.base_klass
          else
            raise ArgumentError, "Don't know how to klassify #{obj}"
          end
        end

        def lock_association(association)
          warn "lock_association is not implemented for Ransack mongoid adapter" if $DEBUG
        end

        def remove_association(association)
          warn "remove_association is not implemented for Ransack mongoid adapter" if $DEBUG
        end

      private

        def get_parent_and_attribute_name(str, parent = @base)
          attr_name = nil

          if ransackable_attribute?(str, klassify(parent))
            attr_name = str
          elsif (segments = str.split(Constants::UNDERSCORE)).size > 1
            remainder = []
            found_assoc = nil
            while remainder.unshift(
              segments.pop) && segments.size > 0 && !found_assoc do
              assoc, klass = unpolymorphize_association(segments.join('_'))
              if found_assoc = get_association(assoc, parent)
                parent, attr_name = get_parent_and_attribute_name(
                  remainder.join('_'), found_assoc.klass
                  )
                attr_name = "#{segments.join('_')}.#{attr_name}"
              end
            end
          end

          [parent, attr_name]
        end

        def get_association(str, parent = @base)
          klass = klassify parent
          ransackable_association?(str, klass) &&
            klass.reflect_on_all_associations_all.detect { |a| a.name.to_s == str }
        end

      end
    end
  end
end
