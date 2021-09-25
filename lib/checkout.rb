class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices)
    @prices = prices
  end

  def scan(item)
    if basket[item].nil?
      basket[item] = 1
    else
      basket[item] += 1
    end
  end

  def total
    total = 0
    basket.each do |item, count|
      if count % multibuy_quantity(item) == 0 && Discount::DISCOUNTS[item.to_sym][:restricted] == true
        number_of_discounted_items = count - Discount::DISCOUNTS[item.to_sym][:restriction_quantity]
        number_of_full_priced_items = count - number_of_discounted_items
        total += prices.fetch(item) * discount_value(item) * number_of_discounted_items
        total += prices.fetch(item) * number_of_full_priced_items
      elsif count % multibuy_quantity(item) == 0
        split_count = count.divmod(multibuy_quantity(item))
        discounted_quantity = split_count[0]
        total += prices.fetch(item) * discount_value(item) * discounted_quantity
        total += prices.fetch(item) * split_count[1]
      else
        total += prices.fetch(item) * count
      end
    end
    total
  end

  private

  def basket
    @basket ||= Hash.new
  end

  def multibuy_quantity(item)
    Discount::DISCOUNTS[item.to_sym][:multibuy_quantity]
  end

  def discount_value(item)
    Discount::DISCOUNTS[item.to_sym][:discount_value]
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
