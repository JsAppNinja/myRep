class PopupSubmitsController < ApplicationController
  # TODO: Find out why it fails on Heroku
  include PagerApi::Pagination::Kaminari

  def index
    popup_submits = PopupSubmit.where(shop_id: current_shop.id)
    paginate popup_submits, per_page: PopupSubmit::PER_PAGE
  end


  def destroy
    popup_submit = current_shop.popup_submits.find_by(id: params[:id])

    if popup_submit.nil?
      render json: { errors: 'You cannot delete this' }, status: 422
      return
    end

    popup_submit.destroy
    head :ok
  end
end
