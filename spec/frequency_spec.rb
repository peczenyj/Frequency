require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include Frequency

describe "Frequency" do
   
   describe "always" do
     it "should be execute always" do
       always { true }.should be_true
     end
   end
   
   describe "never" do
     it "should be not execute never" do
       never { true }.should be_nil
     end
   end
   
   describe "sometimes" do
     it "should be execute if rand() returns less than 0.50" do
       Kernel.should_receive(:rand).with().and_return(0.00)
       sometimes { true }.should be_true  
     end
     it "should not be execute if rand() returns more than 0.50" do
       Kernel.should_receive(:rand).with().and_return(0.99)
       sometimes { true }.should be_nil
     end     
   end

end
