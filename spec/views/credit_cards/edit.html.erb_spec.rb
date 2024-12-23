require 'rails_helper'

RSpec.describe "credit_cards/edit", type: :view do
  let(:credit_card) {
    CreditCard.create!(
      digits: "MyString",
      month: 1,
      year: 1
    )
  }

  before(:each) do
    assign(:credit_card, credit_card)
  end

  it "renders the edit credit_card form" do
    render

    assert_select "form[action=?][method=?]", credit_card_path(credit_card), "post" do

      assert_select "input[name=?]", "credit_card[digits]"

      assert_select "input[name=?]", "credit_card[month]"

      assert_select "input[name=?]", "credit_card[year]"
    end
  end
end
