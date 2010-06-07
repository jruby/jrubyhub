Then /^I should see a list of items$/ do
  page.should have_css('ol.items')
end
