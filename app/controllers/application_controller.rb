class ApplicationController < ActionController::API
  include Authenticable
  include ErrorHandling

end
