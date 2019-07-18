class Spree::ReviewsController < Spree::StoreController
  helper Spree::BaseHelper
  before_action :load_product, only: [:index, :new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @approved_reviews = Spree::Review.approved.where(product: @product)
  end

  def new
    @review = Spree::Review.new(product: @product)
    authorize! :create, @review
  end

  # save if all ok
  def create
    params[:review][:rating].sub!(/\s*[^0-9]*\z/, '') unless params[:review][:rating].blank?

    @review = Spree::Review.new(review_params)
    @review.product = @product
    @review.user = spree_current_user if spree_user_signed_in?
    @review.ip_address = request.remote_ip
    @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

    authorize! :create, @review
    if @review.save
      respond_to do |format|
        format.html do
          flash[:notice] = Spree.t(:review_successfully_submitted)
          redirect_to spree.product_path(@product)
        end
        format.js do
          render json: { success: Spree.t(:review_successfully_submitted) }
        end
      end
    else
      error = @review.errors.full_messages.join('. ')
      respond_to do |format|
        format.html do
          render :new
        end
        format.js do
          render json: { error: error }
        end
      end
    end
  end

  private

  def load_product
    @product = Spree::Product.friendly.find(params[:product_id])
  end

  def permitted_review_attributes
    [:rating, :title, :review, :name, :show_identifier]
  end

  def review_params
    params.require(:review).permit(permitted_review_attributes)
  end
end
