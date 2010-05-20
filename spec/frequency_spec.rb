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
       Kernel.should_receive(:rand).with().and_return(0.14999)
       sometimes { true }.should be_true  
     end
     it "should not be execute if rand() returns more than 0.50" do
       Kernel.should_receive(:rand).with().and_return(0.99)
       sometimes { true }.should be_nil
     end   
     it "should be execute if rand return less than 0.15" do
       Kernel.should_receive(:rand).with().and_return(0.14999)
       sometimes :with_probability => 0.15 do
          true
       end.should be_true
       
     end 
     it "should not be execute if rand return more than 0.15" do
       Kernel.should_receive(:rand).with().and_return(0.15)
       sometimes :with_probability => 0.15 do
          true
       end.should be_nil
       
     end
     it "should be execute if rand return less than 15%" do
       Kernel.should_receive(:rand).with().and_return(0.149999)
       sometimes :with_probability => '15%' do
          true
       end.should be_true
       
     end 
     it "should be raise a exception if probability is more than 100%" do
       lambda{
         sometimes :with_probability => '101%' do
          true
         end
       }.should raise_exception(RuntimeError)
     end
     it "should be raise a exception if probability is less than 0%" do
       lambda{
         sometimes :with_probability => '-1%' do
          true
         end
       }.should raise_exception(RuntimeError)
     end     
   end
   
end
