module Helpers::ResourceRecordHelper

  # Remove this and call upon the module's methods to include instead to fix performance hit
  def self.included(source)
    define_class_methods(source)
  end

  def define_class_methods(source)
    source.class_eval do 

      source.attribute_names.each do |attribute|
        define_method("next_by_" + attribute) do |user = nil|
          if user
            source.joins(:users).where("#{source.table_name}.#{attribute} > ?", self.public_send(attribute)).where(users: {id: user.id}).first
          else
            source.where("#{attribute} > ?", self.public_send(attribute)).first
          end
        end
  
        define_method("previous_by_" + attribute) do |user = nil|
          if user
            source.joins(:users).where("#{source.table_name}.#{attribute} < ?", self.public_send(attribute)).where(users: {id: user.id}).last
          else
            source.where("#{attribute} < ?", self.public_send(attribute)).last
          end
        end
      end

      def next(user = nil)
        self.next_by_id(user)
      end
    
      def previous(user = nil)
        self.previous_by_id(user)
      end

    end
  end
  
  extend self

end