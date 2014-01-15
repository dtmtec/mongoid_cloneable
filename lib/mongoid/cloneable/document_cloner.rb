module Mongoid
  module Cloneable
    class DocumentCloner
      attr_accessor :document, :cloned_document, :options

      def initialize(document, cloned_document)
        self.document = document
        self.cloned_document = cloned_document
        self.options  = document.class.cloneable || {}

        clone_attributes
        clone_relations
      end

      private

      def included_keys
        [*options[:include]].map(&:to_s)
      end

      def excluded_keys
        [*options[:exclude]].map(&:to_s)
      end

      def included_relations
        cloned_document.relations.slice(*included_keys).values
      end

      def excluded_relations
        cloned_document.relations.slice(*excluded_keys).values
      end

      def clone_attributes
        attrs = cloned_document.attributes.except('_id', '_type')

        if included_keys.present?
          attrs.except(*included_keys).each do |attr, value|
            cloned_document[attr] = nil
          end
        end

        attrs.slice(*excluded_keys).each do |attr, value|
          cloned_document[attr] = nil
        end
      end

      def clone_relations
        included_relations.each do |relation|
          Mongoid::Cloneable::RelationshipCloner.clone(document, cloned_document, relation)
        end

        excluded_relations.each do |relation|
          Mongoid::Cloneable::RelationshipCloner.clear(cloned_document, relation)
        end
      end
    end
  end
end
