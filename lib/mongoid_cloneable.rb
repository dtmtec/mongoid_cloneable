require "mongoid/cloneable/version"
require "mongoid"
require "active_support/concern"
require "active_support/core_ext"

module Mongoid
  module Cloneable
    extend ActiveSupport::Concern

    autoload :DocumentCloner, 'mongoid/cloneable/document_cloner'
    autoload :RelationshipCloner, 'mongoid/cloneable/relationship_cloner'

    module ClassMethods
      def cloneable(options=nil)
        @cloneable = options if options
        @cloneable
      end
    end

    def clone
      super.tap do |cloned_document|
        DocumentCloner.new(self, cloned_document)
      end
    end
  end
end

