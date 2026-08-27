require "test_helper"

class TravelPathTest < ActiveSupport::TestCase
  test "allows a first action of either launch or land" do
    assert_nil TravelPath.sequence_error([ TravelStep.launch("earth") ])
    assert_nil TravelPath.sequence_error([ TravelStep.land("moon") ])
  end

  test "requires a landing after a launch, on any body" do
    assert_nil TravelPath.sequence_error([
      TravelStep.launch("earth"),
      TravelStep.land("mars")
    ])

    assert_match(/must be a landing/, TravelPath.sequence_error([
      TravelStep.launch("earth"),
      TravelStep.launch("moon")
    ]))
  end

  test "requires a launch from the same body after a landing" do
    assert_nil TravelPath.sequence_error([
      TravelStep.land("moon"),
      TravelStep.launch("moon"),
      TravelStep.land("earth")
    ])

    error = TravelPath.sequence_error([
      TravelStep.land("moon"),
      TravelStep.launch("earth")
    ])

    assert_match(/launch from Moon/, error)
  end

  test "rejects two landings in a row" do
    assert_match(/launch from Moon/, TravelPath.sequence_error([
      TravelStep.land("moon"),
      TravelStep.land("earth")
    ]))
  end

  test "accepts the Apollo 11 path" do
    assert_nil TravelPath.sequence_error([
      TravelStep.launch("earth"),
      TravelStep.land("moon"),
      TravelStep.launch("moon"),
      TravelStep.land("earth")
    ])
  end
end
