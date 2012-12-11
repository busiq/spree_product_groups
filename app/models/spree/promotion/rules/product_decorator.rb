Spree::Promotion::Rules::Product.class_eval do
  belongs_to :product_group
  preference :group, :boolean, default: false
  attr_accessible :preferred_group

  def eligible_products
    preferred_group ? product_group.products : products
  end

  private
  def only_one_promotion_per_product
    if preferred_group
      if Spree::Promotion::Rules::Product.where("spree_promotion_rules.id != ?", self.id).where(product_group_id: self.product_group_id).present?
        errors[:base] << "You can't create two promotions for the same product"
      end
    else
      if Spree::Promotion::Rules::Product.where("spree_promotion_rules.id != ?", self.id).all.map(&:products).flatten.include?(products)
        errors[:base] << "You can't create two promotions for the same product"
      end
    end
  end

end
