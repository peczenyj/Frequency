require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Frequency" do

   describe "always" do
     
     it "should be execute always" do
       Frequency.always { true }.should be_true
     end
     it "should be not execute never" do
       Frequency.never { true }.should be_nil
     end
     it "should be execute if rand() returns less than 0.50" do
       Kernel.should_receive(:rand).with().and_return(0.00)
       Frequency.sometimes { true }.should be_true  
     end
     it "should not be execute if rand() returns more than 0.50" do
       Kernel.should_receive(:rand).with().and_return(0.99)
       Frequency.sometimes { true }.should be_nil
     end     
   
   end

end
