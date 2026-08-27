require "test_helper"

class SpaceTravelControllerTest < ActionDispatch::IntegrationTest
  test "show renders the simulator" do
    get space_travel_path

    assert_response :success
    assert_select "h1", /fuel calculator/i
    assert_select "form[action=?]", calculate_space_travel_path
  end

  test "add_path_point appends a launch row" do
    post add_path_point_space_travel_path(maneuver: "launch"), as: :turbo_stream

    assert_response :success
    assert_match "Launch", @response.body
    assert_match "path_points[][maneuver]", @response.body
  end

  test "add_path_point appends a landing row through the same endpoint" do
    post add_path_point_space_travel_path(maneuver: "land"), as: :turbo_stream

    assert_response :success
    assert_match "Land", @response.body
  end

  test "add_path_point rejects an unknown maneuver" do
    post add_path_point_space_travel_path(maneuver: "orbit"), as: :turbo_stream

    assert_response :unprocessable_entity
  end

  test "calculate returns the Apollo 11 fuel total" do
    post calculate_space_travel_path, params: apollo_11_params, as: :turbo_stream

    assert_response :success
    assert_match "51,898", @response.body
  end

  test "calculate explains a missing path" do
    post calculate_space_travel_path, params: { mass: 28801 }, as: :turbo_stream

    assert_response :unprocessable_entity
    assert_match "at least one launch or landing", @response.body
  end

  private

  def apollo_11_params
    {
      mass: 28801,
      path_points: [
        { maneuver: "launch", body: "earth" },
        { maneuver: "land", body: "moon" },
        { maneuver: "launch", body: "moon" },
        { maneuver: "land", body: "earth" }
      ]
    }
  end
end
