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
      p count
      if count % Discount::DISCOUNTS[item.to_sym][:minimum_quantity] == 0
        split_count = count.divmod(Discount::DISCOUNTS[item.to_sym][:minimum_quantity])
        p split_count
        discounted_quantity = split_count[0]
        total += prices.fetch(item) * Discount::DISCOUNTS[item.to_sym][:discount_quantity] * discounted_quantity
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
end

class Discount
  DISCOUNTS = {
    "apple": { "minimum_quantity": 2, "discount_quantity": 1, "maximum_quantity": 100},
    "orange": { "minimum_quantity": 1, "discount_quantity": 1, "maximum_quantity": 100},
    "pear": { "minimum_quantity": 2, "discount_quantity": 1, "maximum_quantity": 100},
    "banana": { "minimum_quantity": 1, "discount_quantity": 0.5, "maximum_quantity": 100},
    "pineapple": { "minimum_quantity": 1, "discount_quantity": 0.5, "maximum_quantity": 1},
    "mango": { "minimum_quantity": 4, "discount_quantity": 3, "maximum_quantity": 100}
  }
end
