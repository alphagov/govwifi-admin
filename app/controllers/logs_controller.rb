class LogsController < ApplicationController
  def index
    @logs = [
      {
        "ap" => "",
        "building_identifier" => "",
        "id" => 1,
        "mac" => "",
        "siteIP" => "",
        "start" => "2018-10-01 18:18:09 +0000",
        "stop" => nil,
        "success" => true,
        "username" => params[:username]
      },
      {
        "ap" => "",
        "building_identifier" => "",
        "id" => 1,
        "mac" => "",
        "siteIP" => "",
        "start" => "2018-10-01 18:18:09 +0000",
        "stop" => nil,
        "success" => true,
        "username" => params[:username]
      }
    ]
  end

  def search
  end
end
