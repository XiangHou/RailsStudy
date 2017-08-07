# == Schema Information
#
# Table name: contents
#
#  id           :integer          not null, primary key
#  article_id   :integer
#  display_text :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_contents_on_article_id  (article_id)
#

require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
