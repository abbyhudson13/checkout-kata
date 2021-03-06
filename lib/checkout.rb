class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices)
    @prices = prices
  end

  def scan(item)
    basket[item].nil? ? basket[item] = 1 : basket[item] += 1
  end

  def total
    total = 0
    basket.each do |item, count|
      @item = item
      price = prices.fetch(item)
      if item_restriction_exists?
        number_of_discounted_items = count - restriction_quantity
        number_of_full_price_items = count - number_of_discounted_items
      else
        discounted_and_full_price_items = count.divmod(multibuy_quantity)
        number_of_discounted_items = discounted_and_full_price_items.first
        number_of_full_price_items = discounted_and_full_price_items.last
      end
      total += price * number_of_discounted_items * discount_value
      total += price * number_of_full_price_items
    end
    total
  end

  private

  def basket
    @basket ||= Hash.new
  end

  def multibuy_quantity
    Discount::DISCOUNTS[@item.to_sym][:multibuy_quantity]
  end

  def discount_value
    Discount::DISCOUNTS[@item.to_sym][:discount_value]
  end

  def item_restriction_exists?
    Discount::DISCOUNTS[@item.to_sym][:restricted] == true
  end

  def restriction_quantity
    Discount::DISCOUNTS[@item.to_sym][:restriction_quantity]
  end
end

class Discount
  DISCOUNTS = {
    "apple": { "multibuy_quantity": 2, "discount_value": 1, "restricted": false},
    "orange": { "multibuy_quantity": 1, "discount_value": 1, "restricted": false},
    "pear": { "multibuy_quantity": 2, "discount_value": 1, "restricted": false},
    "banana": { "multibuy_quantity": 1, "discount_value": 0.5, "restricted": false},
    "pineapple": { "multibuy_quantity": 1, "discount_value": 0.5, "maximum_quantity": 1, "restricted": true, "restriction_quantity": 1},
    "mango": { "multibuy_quantity": 4, "discount_value": 3, "restricted": false}
  }
end
