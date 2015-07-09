require 'test_helper'

class HmdTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "there should only be one hmd state at first" do
  	assert_equal 1, HmdState.count, "The fixture was not programmed correctly"
  end

  test "editting hmd should add to hmd_state" do

		count = HmdState.count

  	test_hmd = hmds(:dk2)
  	test_hmd.state = "released"
    test_hmd.save!

    assert_equal "released", hmds(:dk2).state, "The state was not updated correctly"
    assert_equal count+1, HmdState.count, "There was no state added to the HmdState table"
    assert_equal "released", HmdState.where(["hmd_id = ?", test_hmd]).last.state
  end

 	#  test "should not save article without title" do
	#   article = Article.new
	#   assert_not article.save
	# end
end
