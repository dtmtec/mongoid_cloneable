module Mongoid
  module Cloneable
    class RelationshipCloner
      def self.clone(document, cloned_document, relation)
        if [:has_many, :has_one, :has_and_belongs_to_many].include?(relation.macro.to_sym)
          klass = "mongoid/cloneable/relationship_cloner/#{relation.macro}".camelize.constantize
          cloner = klass.new(document, cloned_document, relation)

          cloner.clone
        end
      end

      def self.clear(cloned_document, relation)
        if [:embeds_many, :embeds_one].include?(relation.macro.to_sym)
          cloned_document.send(relation.setter, nil)
        end
      end

      class Base
        attr_accessor :document, :cloned_document, :relation

        def initialize(document, cloned_document, relation)
          self.document = document
          self.cloned_document = cloned_document
          self.relation = relation
        end
      end

      class HasMany < Base
        def clone
          cloned_relation = document.send(relation.name).map { |model| model.clone }
          cloned_document.send(relation.setter, cloned_relation)
        end
      end

      class HasOne < Base
        def clone
          cloned_relation = document.send(relation.name).clone
          cloned_document.send(relation.setter, cloned_relation)
        end
      end

      class HasAndBelongsToMany < Base
        def clone
          document.send(relation.name).each do |target|
            target.send(relation.inverse).send(:<<, cloned_document)
          end
        end
      end
    end
  end
end
