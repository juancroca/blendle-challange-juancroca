module HAL
  class LandingRepresenter < Roar::Decorator
    include Roar::JSON::HAL

    link :lists do
      "/lists"
    end

    link :tags do
      "/tags"
    end

    link :items do
      "/items"
    end

    link :sign_up do
      "/sessions/sign_up"
    end

    link :sign_in do
      "/sessions/sign_in"
    end

    link :logout do
      "/sessions/logout"
    end

  end

  class InstanceRepresenter < Roar::Decorator
    include Roar::JSON::HAL
    property :id
    property :created_at
    property :updated_at

    link :self do
      "/#{represented.class.name.tableize}/#{represented.id}"
    end

    link :index do
      "/#{represented.class.name.tableize}"
    end
  end
  class CollectionRepresenter < Roar::Decorator
    include Roar::JSON::HAL
    link :last do
      "/#{represented.table_name}/#{represented.last.id}" if represented.last
    end
    link :first do
      "/#{represented.table_name}/#{represented.first.id}" if represented.first
    end

    link :last_page do
      "/#{represented.table_name}?page=#{represented.num_pages}"
    end

    link :next do |opts|
      if opts[:page]
        "/#{represented.table_name}?page=#{opts[:page].to_i + 1}"
      else
        "/#{represented.table_name}?page=2"
      end
    end

    link :prev do |opts|
      if opts[:page] && opts[:page].to_i > 1
        "/#{represented.table_name}?page=#{opts[:page].to_i - 1}"
      end
    end

  end
end
