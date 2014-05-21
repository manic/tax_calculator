require './tax_calculator.rb'
require 'rspec-given'
require 'pry-rails'

describe TaxCalculator do

  describe "Product" do
    Given(:product) { TaxCalculator::Product.new(1, 'book', 12.49) }
    Given(:product2) { TaxCalculator::Product.new(1, 'music cd', 14.99) }
    Given(:product3) { TaxCalculator::Product.new(1, 'imported bottle of perfume', 47.50) }

    context "#tax_rate" do
      Then { product.tax_rate == 0 }
      And { product2.tax_rate == 10 } # 10 %
      And { product3.tax_rate == 15 }
    end

    context "#tax" do
      Then { product2.tax == 1.5 }
      And { product3.tax == 7.15 }
    end

    context "#price_with_tax" do
      Then { product.price_with_tax == 12.49 }
      And { product2.price_with_tax == 16.49 }
      And { product3.price_with_tax == 54.65 }
    end
  end

  Given(:tax_cal) { TaxCalculator.new('./sample1.csv') }
  Given(:tax_cal2) { TaxCalculator.new('./sample2.csv') }
  Given(:tax_cal3) { TaxCalculator.new('./sample3.csv') }

  context "initialize" do
    Then { tax_cal.products[0].to_hash == { :quantity => 1, :product => 'book', :price => 12.49 } }
    And { tax_cal.products[1].to_hash == { :quantity => 1, :product => "music cd", :price => 14.99 } }
    And { tax_cal.products[2].to_hash == { :quantity => 1, :product => "chocolate bar", :price => 0.85 } }
  end

  context "#sale_taxes" do
    Then { tax_cal.sale_taxes == 1.5 }
    And { tax_cal2.sale_taxes == 7.65 }
    And { tax_cal3.sale_taxes == 6.7 }
  end

  context "#total" do
    Then { tax_cal.total == 29.83 }
    And { tax_cal2.total == 65.15 }
    And { tax_cal3.total == 74.68 }
  end

  context "#output_csv!" do
    context "sample1" do
      When { tax_cal.output_csv! }
      When(:rows) { CSV.read('./output.csv') }
      Then { rows[0] == ['1', 'book', '12.49'] }
      And { rows[1] == ['1', 'music cd', '16.49'] }
      And { rows[2] == ['1', 'chocolate bar', '0.85'] }
      And { rows[3] == [] }
      And { rows[4] == ['Sales Taxes: 1.50'] }
      And { rows[5] == ['Total: 29.83'] }
    end

    context "sample2" do
      When { tax_cal2.output_csv! }
      When(:rows) { CSV.read('./output.csv') }
      Then do
        rows == [
          ['1', 'imported box of chocolates', '10.50'],
          ['1', 'imported bottle of perfume', '54.65'],
          [],
          ['Sales Taxes: 7.65'],
          ['Total: 65.15']
        ]
      end
    end

    context "sample3" do
      When { tax_cal3.output_csv! }
      When(:rows) { CSV.read('./output.csv') }
      Then do
        rows == [
          ['1', 'imported bottle of perfume', '32.19'],
          ['1', 'bottle of perfume', '20.89'],
          ['1', 'packet of headache pills', '9.75'],
          ['1', 'box of imported chocolates', '11.85'],
          [],
          ['Sales Taxes: 6.70'],
          ['Total: 74.68']
        ]
      end
    end
  end

end

