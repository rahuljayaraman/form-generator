class WizardController < ApplicationController
  def step1
    @source = Source.new
    @sources = current_user.sources
    @wizard = Wizard.new(params, view_context)
  end

  def step2
    @sources = current_user.sources
    @wizard = Wizard.new(params, view_context)
  end

  def step3
  end

  def step4
  end

  def step5
  end
end
