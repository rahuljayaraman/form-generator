require_relative "../../app/models/wizard"

describe Wizard do
  before {
    params = {wizard: {}} 
    wizard_params = params[:wizard]
    @database1 = stub(:database, id: 1)
    @database2 = stub(:database, id: 2)
    wizard_params[:databases] = "#{@database1.id},#{@database2.id}"
    @wizard = Wizard.new params
  }

  it "should render appropriate views as per params provided" do
    @wizard.count_databases.should == 2
  end

  it "should find and list databases" do
    @wizard.should_receive(:find_source).with("1") {@database1}
    @wizard.should_receive(:find_source).with("2") {@database2}
    @wizard.list_databases 
  end
end
