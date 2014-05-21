require 'csv'

class TaxCalculator

  class Product
    attr_reader :quantity, :name, :price100x

    def initialize(quantity, name, price)
      @quantity = quantity.to_i
      @name = name.strip
      @price100x = (price.to_f * 100).round # to avoid float problem
    end

    def price
      price100x.to_f / 100
    end

    def tax_rate
      rate = name.match(/(book|chocolate|pill)/i) ? 0 : 10
      rate += 5 if name.match(/import/i)
      rate
    end

    def price_with_tax
      price_with_tax100x.to_f / 100
    end

    def price_with_tax100x
      price100x + tax100x
    end

    def tax100x
      (price100x * tax_rate.to_f / 500).ceil * 5
    end

    def tax
      tax100x.to_f / 100
    end

    def to_hash
      { :quantity => quantity, :product => name, :price => price }
    end
  end

  attr_reader :products

  def initialize(file_path)
    @products = CSV.read(file_path, headers: true).map { |row| Product.new(row[0], row[1], row[2]) }
  end

  def sale_taxes
    @products.map { |product| product.tax100x }.inject(:+).to_f / 100
  end

  def total
    @products.map { |product| product.price_with_tax100x }.inject(:+).to_f / 100
  end

  def output_csv!
    CSV.open('output.csv', 'wb') do |csv|
      @products.each do |product|
        csv << [product.quantity, product.name, "%.2f" % product.price_with_tax]
      end
      csv << []
      csv << ["Sales Taxes: %.2f" % sale_taxes]
      csv << ["Total: %.2f" % total]
    end
  end
end
