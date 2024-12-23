require 'rails_helper'

RSpec.describe "credit_cards/index", type: :view do
  before(:each) do
    assign(:credit_cards, [
      CreditCard.create!(
        digits: "Digits",
        month: 2,
        year: 3
      ),
      CreditCard.create!(
        digits: "Digits",
        month: 2,
        year: 3
      )
    ])
  end

  it "renders a list of credit_cards" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Digits".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
