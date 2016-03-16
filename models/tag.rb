class Tag < ActiveRecord::Base
  has_and_belongs_to_many :items
  accepts_nested_attributes_for :items
end

module HAL
  class TagRepresenter < InstanceRepresenter
    property :name
  end

  class TagsRepresenter < CollectionRepresenter
    collection :itself, :class => Tag, :extend => TagRepresenter, :embedded => true, as: :tags
  end
end
