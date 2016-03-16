class ItemsRoute < ApplicationRoute
  get '/' do
    page = params[:page]
    items = Item.page page
    status 204 if(items.empty?)
    HAL::ItemsRepresenter.new(items).to_json(page: page)
  end

  get '/:id' do
   item = Item.find_by_id(params['id'])
   if(item)
     HAL::ItemRepresenter.new(item).to_json
   else
     status 404
   end
  end

  post '/' do
    item_params = params["item"]
    item = Item.new(item_params)
    if(item.save)
      HAL::ItemRepresenter.new(item).to_json
    else
      status 202
      json({"message": "item not created", "errors": item.errors.messages.to_a})
    end
  end

  put '/:id' do
    item_params = params["item"]
    item = Item.find(params['id'])
    if(item.update_attributes(item_params))
      HAL::ItemRepresenter.new(item).to_json
    else
      json({"message": "item not created", "errors": item.errors.messages.to_a})
    end
  end

  delete '/:id' do
    item = Item.find(params['id'])
    if(item)
      item.destroy
      json({"message": "item #{params['id']} destroyed"})
    else
      status 404
    end

  end
end
