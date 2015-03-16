class ItemsController < ApplicationController

  include EApiServer::Web::JSON::ServiceControllable
  before_action :set_resource, only: [:destroy, :show, :update, :custom_update]

  def error_test
    head :internal_server_error
  end

  def custom_resource
    items = Item.where( "items.quantity > ? ", params[:quantity] ) 
    render json: items
  end

  def custom_update
    @item.assign_attributes resource_params
    @item.quantity = 0
    if @item.save
      render json: @item
    else
      render json: { errors: @product.errors } 
    end
  end

  protected

  def get_query_params
    params.permit(:id)
  end

  def get_order_params( required_params )
    required_params.permit(:id, :quantity)
  end

  def get_resource_params
    params.require(:item).permit(:id, :name, :quantity)
  end

end
