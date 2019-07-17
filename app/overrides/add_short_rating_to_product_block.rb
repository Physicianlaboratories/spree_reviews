Deface::Override.new(
  virtual_path: 'spree/products/_product',
  name: 'add_short_rating_to_product_block',
  insert_bottom: '[data-hook="short_rating"]',
  text: '<%= render partial: "spree/shared/shortrating", locals: { product: product } %>'
)
