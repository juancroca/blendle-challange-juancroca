class List < ActiveRecord::Base
  has_many :items, inverse_of: :list
  accepts_nested_attributes_for :items
end

module HAL
  class ListRepresenter < InstanceRepresenter
    property :name

    collection :items, :class => Item, :extend => ItemRepresenter, :embedded => true
  end
  class ListsRepresenter < CollectionRepresenter
    collection :itself, :class => List, :extend => ListRepresenter, :embedded => true, as: :lists
  end
end
