Tax Calculator
==============

- Ruby Version: 2.1.2
- Gem used: rspec-given, pry-rails

This simple program can receive a csv file and generate an output CSV file contains sales taxes and total ammount.


### Usage

    TaxCalculator.new('./input.csv')
    TaxCalculator.output_csv!
    
### Product

```TaxCalculator::Product``` is used to handle tax counting, and return a valid tax/price\_with\_tax back.

```ruby
    product = TaxCalculator::Product.new(1, 'music cd', 14.99)
    product.tax_rate # 10 for 10%
    product.tax # 1.5
    product.price_with_tax # 12.49
    
    # 100x series method to avoid float problem
    product.price100x # 1499
    product.tax100x # 150
    product.price_with_tax100x # 1249
```
