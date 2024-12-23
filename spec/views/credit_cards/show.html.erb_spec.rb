require 'rails_helper'

RSpec.describe "credit_cards/show", type: :view do
  before(:each) do
    assign(:credit_card, CreditCard.create!(
      digits: "Digits",
      month: 2,
      year: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Digits/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
