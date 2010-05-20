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
   
   describe "rarely" do
     it "should be execute if rand() returns less than 0.25" do
        Kernel.should_receive(:rand).with().and_return(0.24999)
        rarely { true }.should be_true  
      end

      it "should not be execute if rand() returns more than 0.25" do
        Kernel.should_receive(:rand).with().and_return(0.25)
        rarely { true }.should be_nil
      end
   end
   
   describe "normally" do
      it "should be execute if rand() returns less than 0.75" do
         Kernel.should_receive(:rand).with().and_return(0.74999)
         normally { true }.should be_true  
       end

       it "should not be execute if rand() returns more than 0.75" do
         Kernel.should_receive(:rand).with().and_return(0.75)
         normally { true }.should be_nil
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
       sometimes(:with_probability => 0.15){ true }.should be_true
     end 
     
     it "should not be execute if rand return more than 0.15" do
       Kernel.should_receive(:rand).with().and_return(0.15)
       sometimes(:with_probability => 0.15){ true }.should be_nil
     end
     
     it "should be execute if rand return less than 15%" do
       Kernel.should_receive(:rand).with().and_return(0.149999)
       sometimes(:with_probability => "15%"){ true }.should be_true
     end 
     
     it "should be raise a exception if probability is more than 100%" do
       lambda{
         sometimes(:with_probability => "101%"){ true }
       }.should raise_exception(RuntimeError)
     end
     
     it "should be raise a exception if probability is less than 0%" do
       lambda{
         sometimes(:with_probability => "-0.1%"){ true }
       }.should raise_exception(RuntimeError)
     end
          
   end
   
   describe "maybe" do 
    it "hehe" do
      Kernel.should_receive(:rand).with().and_return(0.99)
      maybe { true }.should be_nil    
    end   
   end
   
end
