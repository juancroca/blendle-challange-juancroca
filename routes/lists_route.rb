class ListsRoute < ApplicationRoute
  get '/' do
    page = params[:page]
    lists = List.page page
    status 204 if(lists.empty?)
    HAL::ListsRepresenter.new(lists).to_json(page: page)
  end

  get '/:id' do
   list = List.find_by_id(params['id'])
   if(list)
     HAL::ListRepresenter.new(list).to_json
   else
     status 404
   end
  end

  post '/' do
    list_params = params["list"]
    list = List.new(list_params)
    if(list.save)
      HAL::ListRepresenter.new(list).to_json
    else
      status 202
      json({"message": "list not created", "errors": list.errors.messages.to_a})
    end
  end

  put '/:id' do
    list_params = params["list"]
    list = List.find(params['id'])
    if(list.update_attributes(list_params))
      HAL::ListRepresenter.new(list).to_json
    else
      json({"message": "list not created", "errors": list.errors.messages.to_a})
    end
  end

  delete '/:id' do
    list = List.find(params['id'])
    if(list)
      list.destroy
      json({"message": "list #{params['id']} destroyed"})
    else
      status 404
    end

  end
end
