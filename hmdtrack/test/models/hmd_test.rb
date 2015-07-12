require 'test_helper'

class HmdTest < ActiveSupport::TestCase

  test "there should only be one hmd state at first" do
  	assert_equal 1, HmdState.count, "The fixture was not programmed correctly"
  end

  test "there should be no state attribute for hmd" do
    assert_not Hmd.new.has_attribute?(:state), "State is an attribute for Hmd"
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

  test "editting hmd with correct state should add to hmd_state" do
    count = HmdState.count

    test_hmd = hmds(:dk2)
    test_hmd.state = "devkit"
    test_hmd.save!

    assert_equal "devkit", hmds(:dk2).state, "The state was not updated correctly"
    assert_equal count+1, HmdState.count, "There was no state added to the HmdState table"
    assert_equal "devkit", HmdState.where(["hmd_id = ?", test_hmd]).last.state

    count = HmdState.count

    test_hmd.state = "announced"
    test_hmd.save!

    assert_equal "announced", hmds(:dk2).state, "The state was not updated correctly"
    assert_equal count+1, HmdState.count, "There was no state added to the HmdState table"
    assert_equal "announced", HmdState.where(["hmd_id = ?", test_hmd]).last.state

  end

  test "editting hmd with incorrect state should raise validation exception" do

    test_hmd = Hmd.create( name: "Rad VR", company: "AngelTech", image_url: "https://i.imgur.com/rAfh8.jpg", announced_at: DateTime.now(), state: "announced" )
    count = HmdState.count
    previous_state = test_hmd.state
    assert_raises(ActiveRecord::RecordInvalid) do
      test_hmd.state = "completeley bogus state"
      test_hmd.save!
    end

    assert_not_equal "completeley bogus state", test_hmd.state, "The state was updated when it should have failed"
    assert_not_equal count+1, HmdState.count, "A bogus state was added to the HmdState table"
    assert_not_equal "completeley bogus state", HmdState.where(["hmd_id = ?", test_hmd]).last.state

    assert_equal previous_state, test_hmd.state, "The current state is not the same as the previous state"
    assert_equal previous_state, HmdState.where(["hmd_id = ?", test_hmd]).last.state

  end

  test "creating an hmd will have state as announced by default" do
    count = HmdState.count
    test_hmd = Hmd.create!( name: "4D HEAD", company: "AngelTech", image_url: "https://i.imgur.com/VHPmc.jpg", announced_at: DateTime.now(), state: "announced" )

    assert_equal count+1, HmdState.count, "Creating a hmd did not create a hmd state"
    assert_equal "announced", HmdState.where(["hmd_id = ?", test_hmd]).last.state, "The default was not applied"
  end


end
