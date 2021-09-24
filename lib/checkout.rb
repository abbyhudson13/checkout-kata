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
      if item == :apple || item == :pear
        if (count % 2 == 0)
          total += prices.fetch(item) * (count / 2)
        else
          total += prices.fetch(item) * count
        end
      elsif item == :banana || item == :pineapple
        if item == :pineapple
          total += (prices.fetch(item) / 2)
          total += (prices.fetch(item)) * (count - 1)
        else
          total += (prices.fetch(item) / 2) * count
        end
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
end

class Discount
  DISCOUNTS = {
    "apple": { "minimum_quantity": 2, "discount_quantity": 1, "maximum_quantity": nil},
    "pear": { "minimum_quantity": 2, "discount_quantity": 1, "maximum_quantity": nil},
    "banana": { "minimum_quantity": 1, "discount_quantity": 0.5, "maximum_quantity": nil},
    "pineapple": { "minimum_quantity": 1, "discount_quantity": 0.5, "maximum_quantity": 1},
    "mango": { "minimum_quantity": 4, "discount_quantity": 3, "maximum_quantity": nil}
  }
end
