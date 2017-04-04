class WelcomeController < ApplicationController
  layout "welcome_test", except: [:index]
  def index
  end

  def test
  end
end
