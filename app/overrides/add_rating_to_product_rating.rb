Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'converted_product_rating',
  insert_bottom: '[data-hook="product_rating"]',
  text: '<%= render partial: "spree/shared/rating", locals: { product: @product } %>'
)
