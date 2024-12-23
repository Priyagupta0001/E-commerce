require 'rails_helper'

RSpec.describe "credit_cards/new", type: :view do
  before(:each) do
    assign(:credit_card, CreditCard.new(
      digits: "MyString",
      month: 1,
      year: 1
    ))
  end

  it "renders new credit_card form" do
    render

    assert_select "form[action=?][method=?]", credit_cards_path, "post" do

      assert_select "input[name=?]", "credit_card[digits]"

      assert_select "input[name=?]", "credit_card[month]"

      assert_select "input[name=?]", "credit_card[year]"
    end
  end
end
