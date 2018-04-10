class ShimsController < ApplicationController

  def show
    resp = RestClient.get("https://js.intercomcdn.com/shim.#{params[:id]}.js")
    raise 'missing js.intercomcdn.com in resp' \
      unless resp.include?('"https://js.intercomcdn.com/"')
    resp['"https://js.intercomcdn.com/"'] = '"https://plus1s.tower.im/"'
    # frame_id = resp[/(?<=\+"frame\.)\w+(?=\.js")/]
    # raise 'missing frame_id' if frame_id.blank?
    # resp[%(+"frame.#{frame_id}.js")] = %(+"#{frame_path(frame_id, format: :js)}")
    render js: resp
  end

end
