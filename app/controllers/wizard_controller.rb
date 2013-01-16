class WizardController < ApplicationController
  def step1
    @wizard = true
    @source = Source.new
    @sources = current_user.sources
    if params[:wizard]
      @databases = params[:wizard][:databases]
    else
      @databases = ""
    end
  end

  def step2
  end

  def step3
  end

  def step4
  end

  def step5
  end
end
