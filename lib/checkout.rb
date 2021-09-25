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
      p basket
      if count % multibuy_quantity(item) == 0
        split_count = count.divmod(multibuy_quantity(item))
        p split_count
        discounted_quantity = split_count[0]
        total += prices.fetch(item) * discount_value(item) * discounted_quantity
        total += prices.fetch(item) * split_count[1]
      else
        total += prices.fetch(item) * count
      end

      # if item == :apple || item == :pear
      #   if (count % 2 == 0)
      #     total += prices.fetch(item) * (count / 2)
      #   else
      #     total += prices.fetch(item) * count
      #   end
      # elsif item == :banana || item == :pineapple
      #   if item == :pineapple
      #     total += (prices.fetch(item) / 2)
      #     total += (prices.fetch(item)) * (count - 1)
      #   else
      #     total += (prices.fetch(item) / 2) * count
      #   end
      # else
      #   total += prices.fetch(item) * count
      # end

      #note: make sure if you buy 6 then the discount is also applied
    end
    p total
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
    "apple": { "multibuy_quantity": 2, "discount_value": 1},
    "orange": { "multibuy_quantity": 1, "discount_value": 1},
    "pear": { "multibuy_quantity": 2, "discount_value": 1},
    "banana": { "multibuy_quantity": 1, "discount_value": 0.5},
    "pineapple": { "multibuy_quantity": 1, "discount_value": 0.5, "maximum_quantity": 1},
    "mango": { "multibuy_quantity": 4, "discount_value": 3}
  }
end
