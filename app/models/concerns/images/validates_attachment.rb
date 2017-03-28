module Concerns::Images::ValidatesAttachment
    # Performance hit: Avoids falseClass empty stop along the call chain - https://8thlight.com/blog/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
    # Remove this and call upon the module's methods to include instead to fix performance hit
    def self.included(source)
        source.class_eval do
          after_initialize :set_image_specifications
        end
    end

    # Adds class specifications & validations for :image attribute
    def set_image_specifications(source = self.class)
        source.has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
        source.validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    end

    extend self
end