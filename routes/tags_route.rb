class TagsRoute < ApplicationRoute
  get '/' do
    page = params[:page]
    tags = Tag.page page
    status 204 if(tags.empty?)
    HAL::TagsRepresenter.new(tags).to_json(page: page)
  end

  get '/:id' do
   tag = Tag.find_by_id(params['id'])
   if(tag)
     HAL::TagRepresenter.new(tag).to_json
   else
     status 404
   end
  end

  post '/' do
    tag_params = params["tag"]
    tag = Tag.new(tag_params)
    if(tag.save)
      HAL::TagRepresenter.new(tag).to_json
    else
      status 202
      json({"message": "tag not created", "errors": tag.errors.messages.to_a})
    end
  end

  put '/:id' do
    tag_params = params["tag"]
    tag = Tag.find(params['id'])
    status 404 and return unless tag
    if(tag.update_attributes(tag_params))
      HAL::TagRepresenter.new(tag).to_json
    else
      json({"message": "tag not created", "errors": tag.errors.messages.to_a})
    end
  end

  delete '/:id' do
    tag = Tag.find(params['id'])
    status 404 and return unless tag
    if(tag)
      tag.destroy
      json({"message": "tag #{params['id']} destroyed"})
    else
      status 404
    end

  end
end
