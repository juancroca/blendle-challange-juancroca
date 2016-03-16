class Item < ActiveRecord::Base
  belongs_to :list, inverse_of: :items
  validates :list, presence: true

  has_and_belongs_to_many :tags, :autosave => true
  accepts_nested_attributes_for :tags
end

module HAL
  class ItemRepresenter < InstanceRepresenter
    property :name

    link :list do
      "/lists/#{represented.list.id}"
    end
    link :tags_index do
      "/tags"
    end
    collection :tags, :class => Tag, :extend => TagRepresenter, :embedded => true
  end

  class ItemsRepresenter < CollectionRepresenter
    collection :itself, :class => Item, :extend => ItemRepresenter, :embedded => true, as: :items
  end
end
