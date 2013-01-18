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
    @sources = current_user.sources
    @wizard = Wizard.new(params, view_context)
    @parameters = @wizard.parameters
  end

  def step4
    @report = current_user.reports.new
    @wizard = Wizard.new(params, view_context)
    @sources = @wizard.list_databases
  end

  def step5
  end
end
