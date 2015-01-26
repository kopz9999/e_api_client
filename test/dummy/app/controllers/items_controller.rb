class ItemsController < ApplicationController

  include EApiServer::Web::JSON::ServiceControllable

  protected

  def get_resource_params
    params.require(:item).permit(:id, :name, :quantity)
  end

  def get_query_params
    params.permit(:item_id)
  end

end