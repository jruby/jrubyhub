Given /^an item with content: (.*)$/ do |content|
  txn do
    Item.new(:content => content).save.should be_true
  end
end
